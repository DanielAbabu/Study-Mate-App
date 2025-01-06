import 'package:flutter/material.dart';
import 'flip_card_detail_screen.dart';
import '../entity/entities.dart';
import '../services/api_services.dart';
import '../widgets/card_set.dart';

class FlipCardScreen extends StatefulWidget {
  final CourseEntity course;

  FlipCardScreen({required this.course});

  @override
  _FlipCardScreenState createState() => _FlipCardScreenState();
}

class _FlipCardScreenState extends State<FlipCardScreen> {
  late CourseEntity course;

  @override
  void initState() {
    super.initState();
    course = widget.course;
  }

  Future<void> generateCards() async {
    final ApiService apiService = ApiService();

    try {
      await apiService.generateCard(course.id);

      final updatedCourse = await apiService.fetchCourse(course.id);

      setState(() {
        course = updatedCourse;
      });
    } catch (error) {
      print("Error generating questions: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to generate questions. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: course.cards != null && course.cards!.isNotEmpty
          ? ListView.builder(
              itemCount: course.cards!.length,
              itemBuilder: (context, listIndex) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0), // Add padding
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlipCardDetailScreen(
                          cards: course.cards![listIndex],
                        ),
                      ),
                    ),
                    child: CardSet(value: "Question", id: listIndex + 1),
                  ),
                );
              },
            )
          : Center(child: Text('No card lists available')),
      floatingActionButton: FloatingActionButton(
        onPressed: generateCards,
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
