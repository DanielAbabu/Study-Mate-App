import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'dart:typed_data'; // For Uint8List
import '../services/api_services.dart';
import '../entity/entities.dart';
import 'study_detail_screen.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _filePath;
  bool _isLoading = false;
  PlatformFile? _pickedFile;
  final TextEditingController _titleController = TextEditingController();

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = result.files.single;
        if (kIsWeb) {
          _filePath = _pickedFile!.name;
        } else {
          _filePath = _pickedFile!.path;
        }
      });
    } else {
      setState(() {
        _pickedFile = null;
        _filePath = null;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a file before uploading.')),
      );
      return;
    }

    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title before uploading.')),
      );
      return;
    }

    final apiService = ApiService();
    setState(() {
      _isLoading = true;
    });

    if (_pickedFile != null) {
      final String title = _titleController.text;

      if (title.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please provide a title for the file.')),
        );
        return;
      }

      try {
        CourseEntity uploadedCourse;

        if (kIsWeb) {
          // Handle file upload for web
          final fileBytes = _pickedFile!.bytes;
          uploadedCourse = await apiService.uploadFile(title, fileBytes!);
        } else {
          // Handle file upload for mobile
          File file = File(_filePath!);
          uploadedCourse = await apiService.uploadFile(title, file);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded successfully')),
        );

        _navigateToCourseSection(id: uploadedCourse.id);
      } catch (error) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during upload: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a file before uploading.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _removeFile() {
    setState(() {
      _filePath = null;
      _pickedFile = null;
    });
  }

  void _navigateToCourseSection({required id}) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => StudyDetailScreen(id: id)),
      (route) =>
          route.isFirst, // Ensures back navigation goes to the main screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Your File'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Upload Your Course File',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF028960),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Enter Course Title',
                    border: OutlineInputBorder(),
                    hintText: 'Course Title',
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _selectFile,
                  child: Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xFF028960),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Select File',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF028960),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_filePath != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,
                          color: const Color.fromARGB(255, 54, 67, 55)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _filePath!,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: _removeFile,
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      _filePath == null || _isLoading ? null : _uploadFile,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Upload File'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 42, vertical: 24),
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
