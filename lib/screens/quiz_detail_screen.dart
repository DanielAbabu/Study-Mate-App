import 'package:flutter/material.dart';

class QuizDetailScreen extends StatelessWidget {
  final List<dynamic> questions;

  QuizDetailScreen({required this.questions});

  @override
  Widget build(BuildContext context) {
    // Validate and flatten the questions properly
    final List<Map<String, dynamic>> processedQuestions = questions
        .where((q) => q is List) // Ensure we process nested lists
        .expand((q) => q) // Flatten the nested lists
        .cast<Map<String, dynamic>>() // Ensure proper type casting
        .toList();
    print('Processed questions: $processedQuestions'); // Debugging print

    return Container(
      padding: EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: processedQuestions.length,
        itemBuilder: (context, index) {
          final question = processedQuestions[index];

          return QuestionCard(
            question: {
              'questionText': question['question_text'] ?? 'No question text',
              'answers': question['answers'] ?? [],
            },
          );
        },
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Map<String, dynamic> question;

  QuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    final questionText = question['question_text'] ?? 'No question text';
    final answers = question['answers'] as List<dynamic>? ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...answers.map((answer) {
              return Text('- ${answer['text'] ?? 'No answer text'}');
            }).toList(),
          ],
        ),
      ),
    );
  }
}
