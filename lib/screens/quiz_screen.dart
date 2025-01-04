import 'package:flutter/material.dart';
import '../entity/entities.dart';
import '../widgets/card_set.dart';
import '../services/api_services.dart';
import 'quiz_detail_screen.dart';

class QuizScreen extends StatefulWidget {
  final CourseEntity course;

  QuizScreen({required this.course});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late CourseEntity course;

  @override
  void initState() {
    super.initState();
    course = widget.course;
  }

  Future<void> generateQuestions() async {

    final ApiService apiService = ApiService();


    try {
      await apiService.generateQuestion(course.id);

      final updatedCourse = await apiService.fetchCourse(course.id);

      setState(() {
        course = updatedCourse;
      });

    } catch (error) {

      print("Error generating questions: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate questions. Please try again.')),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: course.questions != null && course.questions!.isNotEmpty
          ? ListView.builder(
              itemCount: course.questions!.length,
              itemBuilder: (context, index) {
                final questionSet = course.questions![index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical spacing
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizDetailScreen(
                          questions: questionSet,
                        ),
                      ),
                    ),
                    child: CardSet(value:"Question",id: index+1),
                  ),
                );
              },
            )
          : Center(
              child: Text('No Questions available'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: generateQuestions,
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );

  }
}
