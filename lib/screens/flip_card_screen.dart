import 'package:flutter/material.dart';
import 'flip_card_detail_screen.dart';
import '../entity/entities.dart';
import '../services/api_services.dart';


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
    course = widget.course; // Initialize course from the widget
  }

  Future<void> generateCards() async {
    final ApiService apiService = ApiService(); // Ensure ApiService is defined
    try {
      // Call the API to generate questions
      await apiService.generateCard(course.id);

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
      body: course.cards != null && course.cards!.isNotEmpty
          ? ListView.builder(
              itemCount: course.cards!.length,
              itemBuilder: (context, listIndex) {
                return ListTile(
                  title: Text('Card List ${listIndex + 1}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlipCardDetailScreen(
                          cards: course.cards![listIndex],
                        ),
                      ),
                    );
                  },
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
