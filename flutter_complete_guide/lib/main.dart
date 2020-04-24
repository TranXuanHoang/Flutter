import 'package:flutter/material.dart';

import './quiz.dart';
import './result.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _questions = [
    {
      'questionText': 'What\'s your favorite color?',
      'answers': [
        {'text': 'Black', 'score': 10},
        {'text': 'Blue', 'score': 7},
        {'text': 'White', 'score': 1},
        {'text': 'Green', 'score': 5}
      ],
    },
    {
      'questionText': 'What\'s your favorite animal?',
      'answers': [
        {'text': 'Rabbit', 'score': 6},
        {'text': 'Elephant', 'score': 9},
        {'text': 'Dolphin', 'score': 5},
        {'text': 'Shark', 'score': 1}
      ],
    },
    {
      'questionText': 'What\'s your favorite food?',
      'answers': [
        {'text': 'Pizza', 'score': 5},
        {'text': 'Banh My', 'score': 3},
        {'text': 'Sushi', 'score': 10},
        {'text': 'Hamburger', 'score': 2}
      ],
    },
    {
      'questionText': 'What\'s your hobby?',
      'answers': [
        {'text': 'Reading Books', 'score': 6},
        {'text': 'Playing Games', 'score': 2},
        {'text': 'Traveling', 'score': 8},
        {'text': 'Watching Movie', 'score': 4},
        {'text': 'Doing Programming with Flutter', 'score': 10},
      ],
    }
  ];

  var _questionIndex = 0;
  var _totalScore = 0;

  void _changeQuestion() {
    _questionIndex++;

    // Uncomment the following line if you want to limit the questions
    // to only increasing or decreasing order without rounding backward or forward
    //_questionIndex = max(min(_questions.length - 1, _questionIndex), 0);

    // Turn around the order of questions
    /*if (_questionIndex >= _questions.length) {
      _questionIndex = 0;
    } else if (_questionIndex < 0) {
      _questionIndex = _questions.length - 1;
    }*/
  }

  void initializeQuizes() {
    _questionIndex = 0;
    _totalScore = 0;
  }

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(_changeQuestion);
  }

  void _restartQuiz() {
    setState(initializeQuizes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text("My First App 1"),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                questions: _questions,
                questionIndex: _questionIndex,
                answerQuestion: _answerQuestion,
              )
            : Result(
                resultScore: _totalScore,
                restartHandler: _restartQuiz,
              ),
      ),
    );
  }
}
