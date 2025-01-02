import 'package:flutter/material.dart';
import '../widgets/question_card.dart';

class QuizDetailScreen extends StatelessWidget {
  final List<Map<String, dynamic>> questions;

  QuizDetailScreen({
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Details'),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return QuestionCard(question: questions[index]);
          },
        ),
      ),
    );
  }
}
