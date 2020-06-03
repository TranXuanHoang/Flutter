import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/auth_mode.dart';
import '../models/user.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isAuthBeingRun = false;
  final _auth = FirebaseAuth.instance;

  void _showLoading(bool shouldShow) {
    setState(() {
      _isAuthBeingRun = shouldShow;
    });
  }

  void _submitAuthForm(
    User user,
    AuthMode authMode,
    BuildContext context,
  ) async {
    AuthResult _authResult;

    try {
      _showLoading(true);
      if (authMode == AuthMode.LOGIN) {
        _authResult = await _auth.signInWithEmailAndPassword(
          email: user.email.trim(),
          password: user.password,
        );
      } else if (authMode == AuthMode.SIGNUP) {
        _authResult = await _auth.createUserWithEmailAndPassword(
          email: user.email.trim(),
          password: user.password,
        );
        await Firestore.instance
            .collection('users')
            .document(_authResult.user.uid)
            .setData({
          'username': user.username,
          'email': user.email,
        });
      }
    } on PlatformException catch (error) {
      var message =
          'An error occurred. ${authMode == AuthMode.SIGNUP ? 'Signup' : 'Login'} failed.';

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (error) {
      print(error);
    } finally {
      _showLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isAuthBeingRun),
    );
  }
}
