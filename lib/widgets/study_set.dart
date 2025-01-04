import 'package:flutter/material.dart';
import '../screens/study_detail_screen.dart';
class StudySet extends StatelessWidget {
  final int id;
  final String title;
  final String date;

  StudySet({
    required this.id,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudyDetailScreen(id: id), // Pass the correct id
            ),
          );
        },
        child: Row(
          children: [
            // Circle with first letter of title
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.shade100,
              ),
              width: 50,
              height: 50,
              margin: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  title.isNotEmpty ? title[0].toUpperCase() : 'N', // Default character
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
            ),
            // Title and additional info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Study card",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        date.substring(0, 10),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
