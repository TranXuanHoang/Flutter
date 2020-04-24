import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final Function restartHandler;

  Result({this.resultScore, this.restartHandler});

  String get resultPhrase {
    String resultText;

    if (resultScore <= 10) {
      resultText = "You are great!";
    } else if (resultScore <= 14) {
      resultText = "You are awesome!";
    } else if (resultScore <= 18) {
      resultText = "Pretty likeable!";
    } else {
      resultText = "You're ... strange!";
    }

    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            resultPhrase,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent,
            ),
            textAlign: TextAlign.center,
          ),
          FlatButton(
            onPressed: restartHandler,
            child: Text(
              "Restart Quiz!",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.pinkAccent,
          )
        ],
      ),
    );
  }
}
