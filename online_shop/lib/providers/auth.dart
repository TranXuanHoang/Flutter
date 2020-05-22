import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Auth with ChangeNotifier {
  /// Saves 'idToken' - A Firebase Auth ID token for the newly created user.
  String _token;

  /// Holds 'expiresIn' - The number of seconds in which the ID token expires.
  DateTime _expiryDate;

  /// Saves 'localId' - The uid of the newly created user.
  String _userId;

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

    if (response.statusCode >= 400) {
      final errorMsg = json.decode(response.body)['error']['message'];
      print(response.body);
      // throw Exception(errorMsg);
    }

    final signupResponse = json.decode(response.body);
    _token = signupResponse['idToken'];
    _expiryDate = DateTime.now()
        .add(Duration(seconds: int.parse(signupResponse['expiresIn'])));
    _userId = signupResponse['localId'];
    print('Token: $_token');
    print(
        'ExpiryDate: ${DateFormat("yyyy-MM-dd HH:mm:ss").format(_expiryDate)}');
    print('UserID: $_userId');
    notifyListeners();
  }

  /// See [sign up with email / password with Firebase](https://firebase.google.com/docs/reference/rest/auth#section-create-email-password)
  /// for more information about how to sign user up with email and password
  Future<void> signup(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  /// Sign in a user using email and password. The sign in here is
  /// conducted by sending a HTTP POST request and authenticate with
  /// Firebase. See [Firebase Doc](https://firebase.google.com/docs/reference/rest/auth#section-sign-in-email-password)
  /// for more information.
  Future<void> login(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }
}
