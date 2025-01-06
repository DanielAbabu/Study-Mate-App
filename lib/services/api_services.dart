import 'dart:convert';
import 'dart:typed_data'; // For Uint8List (Web)
import 'dart:io'; // For File (Mobile)
import 'package:flutter/foundation.dart'; // For checking if it's Web
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import '../entity/entities.dart';

const String baseApiUrl = "http://35.174.204.131";

class ApiService {
  Future<List<CourseCardEntity>> fetchAllCourses() async {
    final url = Uri.parse('$baseApiUrl/courses');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> responseData = json.decode(response.body);

        // Extract the 'courses' list
        final List<dynamic> coursesJson = responseData;

        // Map JSON objects to CourseCardEntity instances
        final courses = coursesJson
            .map((courseJson) => CourseCardEntity.fromJson(courseJson))
            .toList();

        return courses;
      } else {
        throw Exception(
            'Failed to load all courses. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load all courses: $error');
    }
  }

  Future<CourseEntity> fetchCourse(int courseId) async {
    final url = Uri.parse('$baseApiUrl/courses/$courseId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
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
      final response = await http.post(url);
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
      final response = await http.post(url);

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

  Future<CourseEntity> uploadFile(String title, dynamic file) async {
    final url = Uri.parse('$baseApiUrl/courses/uploads/');

    var request = http.MultipartRequest('POST', url)..fields['title'] = title;
    // print(file);

    if (file is File) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
    } else if (file is Uint8List) {
      request.files
          .add(http.MultipartFile.fromBytes('file', file, filename: 'file'));
    } else {
      throw Exception('Unsupported file type');
    }

    try {
      final response = await request.send();
      // print(response);

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // final Map<String, dynamic> responseData = json.decode(responseBody);
        final Map<String, dynamic> responseData = json.decode(responseBody);
        return CourseEntity.fromJson(responseData);
        // return 'File uploaded successfully! File URL: ${responseData['file']}';
      } else {
        throw Exception(
            'File upload failed with status: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to upload file: $error');
    }
  }

  // Helper method to pick file
  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }
}
