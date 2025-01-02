import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../entity/entities.dart';

const String baseApiUrl = "http://100.26.218.74:80";

class ApiService {
  Future<List<CourseCardEntity>> fetchAllCourses() async {
    final url = Uri.parse('$baseApiUrl/courses');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON as a List
        final List<dynamic> responseData = json.decode(response.body);

        // Map JSON objects to CourseCardEntity instances
        return responseData
            .map((courseJson) => CourseCardEntity.fromJson(courseJson))
            .toList();
      } else {
        throw Exception(
            'Failed to load courses. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load courses: $error');
    }
  }

  Future<CourseEntity> fetchCourse(int courseId) async {
    final url = Uri.parse('$baseApiUrl/courses/$courseId');

    try {
      final response = await http.get(url);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response as a Map
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Use the response directly (no "data" field in the JSON)
        return CourseEntity.fromJson(responseData);
      } else {
        throw Exception(
            'Failed to load course with ID: $courseId. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load course with ID: $courseId: $error');
    }
  }

  Future<String> generateCard(int courseId) async {
    final url = Uri.parse('$baseApiUrl/courses/$courseId/generate-c');

    try {
      final response = await http.get(url);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check the "status" key in the response
        if (responseData['status'] == 'success') {
          return 'Card generation successful';
        } else {
          throw Exception('Card generation failed');
        }
      } else {
        throw Exception(
            'Failed to generate card. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to generate card: $error');
    }
  }

  Future<String> generateQuestion(int courseId) async {
    final url = Uri.parse('$baseApiUrl/courses/$courseId/generate-q');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check the "status" key in the response
        if (responseData['status'] == 'success') {
          return 'Question generation successful';
        } else {
          throw Exception('Question generation failed');
        }
      } else {
        throw Exception(
            'Failed to generate question. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to generate question: $error');
    }
  }
}
