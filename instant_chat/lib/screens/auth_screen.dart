import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

import '../models/auth_mode.dart';
import '../models/user.dart';
import '../widgets/auth/auth_form.dart';

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

        final profileImage = File(user.profileImagePath);
        String fileName = path.basename(user.profileImagePath);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(_authResult.user.uid)
            .child('profile')
            .child(fileName);

        await ref.putFile(profileImage).onComplete;
        final url = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(_authResult.user.uid)
            .setData({
          'username': user.username,
          'email': user.email,
          'profileImageUrl': url,
        });
      }
    } on PlatformException catch (error) {
      _showLoading(false);
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
