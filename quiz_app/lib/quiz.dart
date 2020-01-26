import 'package:flutter/material.dart';
import 'package:quiz_app/answer.dart';
import 'package:quiz_app/question.dart';

class Quiz extends StatelessWidget {
  final Function answerHandler;
  final int questionIndex;
  final List<Map<String, Object>> questions;

  Quiz({
    @required this.answerHandler,
    @required this.questions,
    @required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        Question(
          questions[questionIndex]['questionText'],
        ),
        ...(questions[questionIndex]['answers'] as List<Map<String, Object>>)
            .map((answer) =>
                Answer(() => answerHandler(answer['score']), answer['text']))
            .toList(),
      ],
    );
  }
}
