import 'package:flutter/material.dart';
import 'flip_card_screen.dart';
import 'quiz_screen.dart';
import 'note_summary_screen.dart';
import '../entity/entities.dart';
import '../services/api_services.dart'; // Ensure ApiService is imported

class StudyDetailScreen extends StatelessWidget {
  final int id;

  StudyDetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return FutureBuilder<CourseEntity>(
      future: apiService.fetchCourse(id), // Pass the correct id
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final course = snapshot.data!;

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                title: Text(course.title, style: TextStyle(color: Colors.black)),
                backgroundColor: Colors.white,
                bottom: const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  labelStyle: TextStyle(fontSize: 14.0),
                  unselectedLabelStyle: TextStyle(fontSize: 12),
                  tabs: [
                    Tab(text: 'Summary'),
                    Tab(text: 'Flip Card'),
                    Tab(text: 'Questions'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  NoteSummaryScreen(noteContent: course.noteContent),
                  FlipCardScreen(course: course),
                  QuizScreen(course: course),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text('Course not found with ID: $id'));
        }
      },
    );
  }
}
