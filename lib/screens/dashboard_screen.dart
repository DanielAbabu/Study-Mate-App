import 'package:flutter/material.dart';
import '../widgets/study_set.dart';
import 'upload_screen.dart'; // Add the upload screen for file upload
import 'study_detail_screen.dart';
import '../entity/entities.dart';
import '../services/api_services.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<List<CourseCardEntity>>(

          future: apiService.fetchAllCourses(),

          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());

            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));

            } else if (snapshot.hasData) {
              final courses = snapshot.data!;

              return ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];

                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudyDetailScreen(id: course.id), // Use course.id
                      ),
                    ),
                    child: StudySet(
                      id : course.id,
                      title: course.title, // Use course.title
                      date: course.date, // Use course.date
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   shape: CircularNotchedRectangle(),
      //   notchMargin: 8.0,
      //   color: Color(0xFF028960),
      //   child: Padding(
      //     padding: const EdgeInsets.all(20),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadScreen(), // Redirect to upload screen
            ),
          );
        },

        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
