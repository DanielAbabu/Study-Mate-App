import 'package:flutter/material.dart';

class QuestionCard extends StatefulWidget {
  final Map<String, dynamic> question; // The question as a map

  const QuestionCard({Key? key, required this.question}) : super(key: key);

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? selectedAnswer;
  late List<dynamic> answers;

  @override
  void initState() {
    super.initState();
    answers = List<dynamic>.from(widget.question['answers'] ?? []);
    answers.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    // Extract question text and answers from the map
    String questionText =
        widget.question['question_text'] ?? "No question provided";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionText,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12.0),
            ...answers.map((answer) {
              // Each answer is a map with 'text' and 'is_correct' keys
              String answerText = answer['text'] ?? "No answer text provided";
              bool isCorrect = answer['is_correct'] ?? false;

              Color getTextColor() {
                if (selectedAnswer == null) return Colors.black;
                if (selectedAnswer == answerText) {
                  return isCorrect ? Colors.green : Colors.red;
                }
                if (isCorrect) return Colors.green;
                return Colors.black;
              }

              return GestureDetector(
                onTap: selectedAnswer == null
                    ? () {
                        setState(() {
                          selectedAnswer = answerText;
                        });
                      }
                    : null,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 3.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[100],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          answerText,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: getTextColor(),
                          ),
                        ),
                      ),
                      if (selectedAnswer == answerText)
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
