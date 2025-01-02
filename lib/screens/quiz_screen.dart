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
      print("Error generating question cards: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to generate question cards. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: course.questions != null && course.questions!.isNotEmpty
              ? ListView.builder(
                  itemCount: course.questions!.length,
                  itemBuilder: (context, index) {
                    final card = course.questions![index];

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizDetailScreen(
                            questions: course.questions ?? [],
                          ),
                        ),
                      ),
                      child: CardSet(id: index),
                    );
                  },
                )
              : Center(child: Text('No Questions available')),
        ),
        FloatingActionButton(
          onPressed: generateQuestions,
          backgroundColor: Colors.green,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }
}
