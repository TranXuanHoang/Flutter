import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './answer.dart';
import './question.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int questionIndex;
  final Function answerQuestion;

  Quiz({
    @required this.questions,
    @required this.questionIndex,
    @required this.answerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Question(questions.elementAt(questionIndex)['questionText']),

        // List of Answer widgets
        ...answerWidgets(AnswerType.UN_NUMBERED),
      ],
    );
  }

  List<Widget> answerWidgets(AnswerType answerType) {
    switch (answerType) {
      case AnswerType.UN_NUMBERED:
        return _unNumberedAnswerWidgets(questions[questionIndex]['answers']);

      case AnswerType.NUMBERED:
        return _numberedAnswerWidgets(questions[questionIndex]['answers']);
    }

    return null;
  }

  List<Widget> _unNumberedAnswerWidgets(List<Map<String, Object>> answers) {
    return answers.map((answer) {
      return Answer(
        answer: answer['text'],
        selectHandler: () => answerQuestion(answer['score']),
      );
    }).toList();
  }

  List<Widget> _numberedAnswerWidgets(List<Map<String, Object>> answers) {
    List<Widget> widgets = [];

    int answerNo = 1;
    answers.forEach((answer) => {
          widgets.add(Answer(
            answerNo: answerNo++,
            answer: answer['text'],
            selectHandler: () => answerQuestion(answer['score']),
          ))
        });

    return widgets;
  }
}
