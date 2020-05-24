import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  /// Saves 'idToken' - A Firebase Auth ID token for the newly created user.
  String _token;

  /// Holds 'expiresIn' - The number of seconds in which the ID token expires.
  DateTime _expiryDate;

  /// Saves 'localId' - The uid of the newly created user.
  String _userId;

  /// Automatically runs the 'logout' method t log the user out.
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null &&
        _userId != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> authenticate(
      String email, String password, String endpointSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$endpointSegment?key=AIzaSyD-bnJ61A8Ydlf79HU-11ryiL8K9Nmv920';
    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final responseData = json.decode(response.body);
    print(response.statusCode);

    if (response.statusCode >= 400) {
      final errorMsg = responseData['error']['message'];
      print(response.body);
      throw HttpException(errorMsg);
    }

    _token = responseData['idToken'];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(
          responseData['expiresIn'],
        ),
      ),
    );
    _userId = responseData['localId'];
    _autoLogout();
    notifyListeners();

    // Save authentication data to the persistent storage of device
    final prefs = await SharedPreferences.getInstance();
    if (prefs != null && prefs.containsKey('userData')) {
      await prefs.remove('userData');
    }
    prefs.setString(
      'userData',
      json.encode({
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
        'userId': _userId,
      }),
    );
  }

  /// Signs up a user using email and password. The sign up here uses the Firebase's
  /// [sign up with email / password API](https://firebase.google.com/docs/reference/rest/auth#section-create-email-password).
  Future<void> signup(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  /// Signs in a user using email and password. The sign in here is
  /// conducted by sending an HTTP POST request and authenticates the user with
  /// Google Firebase. See Firebase's
  /// [sign in with email / password](https://firebase.google.com/docs/reference/rest/auth#section-sign-in-email-password)
  /// doc for more information.
  Future<void> login(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs == null || !prefs.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData['token'];
    _expiryDate = expiryDate;
    _userId = userData['userId'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    if (prefs != null && prefs.containsKey('userData')) {
      await prefs.remove('userData');
      prefs = null;
    }
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  static String errorMessage(String inputMsg) {
    var outputMsg = 'Authentication failed.';

    if (inputMsg.contains('EMAIL_EXISTS')) {
      outputMsg = 'The email address is already in use.';
    } else if (inputMsg.contains('EMAIL_NOT_FOUND')) {
      outputMsg = 'Could not find a user with that email.';
    } else if (inputMsg.contains('INVALID_EMAIL')) {
      outputMsg = 'This is not a valid email address.';
    } else if (inputMsg.contains('WEAK_PASSWORD')) {
      outputMsg = 'The password must be 6 characters long or more.';
    } else if (inputMsg.contains('INVALID_PASSWORD')) {
      outputMsg = 'Invalid password.';
    } else if (inputMsg.contains('USER_DISABLED')) {
      outputMsg = 'The user account has been disabled.';
    } else if (inputMsg.contains('USER_NOT_FOUND')) {
      outputMsg = 'Could not find that user';
    } else if (inputMsg.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
      outputMsg =
          'Authentication has been blocked due to unusual activity. Try again later.';
    }

    return outputMsg;
  }
}
