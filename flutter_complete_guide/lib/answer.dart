import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final int answerNo;
  final String answer;
  final Function selectHandler;

  Answer({this.answerNo, this.answer, this.selectHandler});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.pinkAccent,
        textColor: Colors.white,
        child: Text(
            (this.answerNo != null ? this.answerNo.toString() + ' - ' : '') +
                answer),
        onPressed: this.selectHandler,
      ),
    );
  }
}

enum AnswerType {
  NUMBERED,
  UN_NUMBERED
}