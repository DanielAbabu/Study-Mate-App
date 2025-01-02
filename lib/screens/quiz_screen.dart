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
    final ApiService apiService = ApiService(); // Ensure ApiService is defined
    try {
      // Call the API to generate questions
      await apiService.generateQuestion(course.id);

      // Fetch the updated course data
      final updatedCourse = await apiService.fetchCourse(course.id);

      // Update the state with the new course data
      setState(() {
        course = updatedCourse;
      });
    } catch (error) {
      // Handle any errors
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

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizDetailScreen(
                        questions: questionSet, // Pass the selected list of questions
                      ),
                    ),
                  ),
                  child: CardSet(id: index),
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
