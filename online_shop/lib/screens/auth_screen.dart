import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color:
                              Theme.of(context).accentTextTheme.headline6.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _emailFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordController = TextEditingController();
  final _confirmPasswordFocusNode = FocusNode();
  var _autovalidateConfirmPassword = false;
  var _confirmPassworMatches = false;

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _confirmPasswordController.addListener(_confirmPasswordListener);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  void _confirmPasswordListener() {
    if (_confirmPasswordFocusNode.hasFocus &&
        _confirmPasswordController.text.isNotEmpty) {
      _autovalidateConfirmPassword = true;

      if (_confirmPasswordController.text == _passwordController.text) {
        setState(() {
          _confirmPassworMatches = true;
        });
      } else {
        setState(() {
          _confirmPassworMatches = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordController.removeListener(_confirmPasswordListener);
    _confirmPasswordController.dispose();
    _confirmPasswordFocusNode.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    print('Before: ' + _authData['email']);
    print('Before: ' + _authData['password']);
    if (!_formKey.currentState.validate()) {
      // Invalid
      return;
    }
    _formKey.currentState.save();
    print('Saved: ' + _authData['email']);
    print('Saved: ' + _authData['password']);

    _showLoading(true);
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      final errorMessage = Auth.errorMessage(error.toString());
      _showErrorDialog(errorMessage);
    } catch (error) {
      // Other kinds of errors (network connnection, etc.)
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    _showLoading(false);
  }

  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.Login) {
        // Change auth mode
        _authMode = AuthMode.Signup;
        _confirmPasswordController.addListener(_confirmPasswordListener);
        _controller.forward();
      } else {
        // Change auth mode
        _authMode = AuthMode.Login;
        _confirmPasswordController.removeListener(_confirmPasswordListener);
        _controller.reverse();
      }

      // Clear input fields
      _authData['password'] = '';
      _passwordController.clear();
      _confirmPasswordController.clear();
      _autovalidateConfirmPassword = false;
      _confirmPassworMatches = false;
    });
  }

  void _showLoading(bool shouldShow) {
    setState(() {
      _isLoading = shouldShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build()');
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        // height: _heightAnimation.value.height,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  focusNode: _emailFocusNode,
                  onFieldSubmitted: (value) {
                    // Move cursor to the password input field
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please input email.';
                    }
                    if (!value.contains('@')) {
                      // For the purpose of demonstrating validation
                      // we simply check whether the input contains @.
                      // For more correct validation, consider using
                      // validator libraries i.e., string_validator
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _authData['email'] = newValue,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.fingerprint),
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: _authMode == AuthMode.Signup
                      ? TextInputAction.next
                      : TextInputAction.go,
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  onFieldSubmitted: (value) {
                    if (_authMode == AuthMode.Signup) {
                      // Move cursor to the confirm password field
                      FocusScope.of(context)
                          .requestFocus(_confirmPasswordFocusNode);
                    } else {
                      // If the _authMode is AuthMode.Login, call _submit() immediately
                      _submit();
                    }
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please input password.';
                    }
                    if (value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _authData['password'] = newValue,
                ),
                // if (_authMode == AuthMode.Signup)
                  AnimatedContainer(
                    constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                    ),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              icon: Icon(
                                Icons.check,
                                color: _confirmPassworMatches
                                    ? Colors.green
                                    : Colors.white,
                              )),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          autovalidate: _autovalidateConfirmPassword,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value.isEmpty) {
                                    return 'Please input your password again.';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
