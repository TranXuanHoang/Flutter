import 'package:flutter/material.dart';

import '../../models/auth_mode.dart';
import '../../models/user.dart';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isAuthBeingRun;
  final void Function(
    User user,
    AuthMode authMode,
    BuildContext context,
  ) submitFn;

  AuthForm(this.submitFn, this.isAuthBeingRun);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _authMode = AuthMode.LOGIN;
  var _user = User();

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus(); // Turn of soft keyboard
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    widget.submitFn(_user, _authMode, context);
  }

  void _changeAuthMode(AuthMode newAuthMode) {
    setState(() {
      _authMode = newAuthMode;
    });
  }

  void _toggleSignupLogin() {
    if (_authMode == AuthMode.LOGIN) {
      _changeAuthMode(AuthMode.SIGNUP);
    } else if (_authMode == AuthMode.SIGNUP) {
      _changeAuthMode(AuthMode.LOGIN);
    } else {
      _changeAuthMode(AuthMode.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (_authMode == AuthMode.SIGNUP) UserImagePicker(),
                    TextFormField(
                      key: ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please input your email address.';
                        }
                        // The following check use a simple regex (as a demonstration)
                        // to check whether the email is in valid format.
                        if (!value.contains(new RegExp(
                            r"^[a-zA-Z0-9]+([\-\_\.]{1}[a-zA-Z0-9]+)*@[a-zA-Z0-9]+([\-\_\.]{1}[a-zA-Z0-9]+)*([\.]{1}[a-z]+)$"))) {
                          return 'Invalid email address!';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _user = User(
                          email: newValue,
                          username: _user.username,
                          password: _user.password,
                        );
                      },
                    ),
                    if (_authMode == AuthMode.SIGNUP)
                      TextFormField(
                        key: ValueKey('username'),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          icon: Icon(Icons.account_box),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please input a username.';
                          }
                          // The following check use a simple regex (as a demonstration)
                          // to check whether the email is in valid format.
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters long!';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _user = User(
                            email: _user.email,
                            username: newValue,
                            password: _user.password,
                          );
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.fingerprint),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please input a password.';
                        }
                        // The following check use a simple regex (as a demonstration)
                        // to check whether the email is in valid format.
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long!';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _user = User(
                          email: _user.email,
                          username: _user.username,
                          password: newValue,
                        );
                      },
                    ),
                    SizedBox(height: 12),
                    if (widget.isAuthBeingRun) CircularProgressIndicator(),
                    if (!widget.isAuthBeingRun)
                      RaisedButton(
                        child: Text(
                            _authMode == AuthMode.LOGIN ? 'Login' : 'Sign Up'),
                        onPressed: _trySubmit,
                      ),
                    if (!widget.isAuthBeingRun)
                      FlatButton(
                        child: Text(_authMode == AuthMode.LOGIN
                            ? 'Create new account'
                            : 'Login'),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: _toggleSignupLogin,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
