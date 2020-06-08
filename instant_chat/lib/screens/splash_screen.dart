import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Text(
          'Loading',
          style: TextStyle(
            color: Theme.of(context).accentTextTheme.headline6.color,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
