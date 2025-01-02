import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';  // for kIsWeb
import 'dart:typed_data'; // For Uint8List
import '../services/api_services.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _filePath;
  bool _isLoading = false;
  PlatformFile? _pickedFile;

  // Function to pick the file
  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = result.files.single;
        if (kIsWeb) {
          _filePath = _pickedFile!.name;  // Use the file name for web
        } else {
          _filePath = _pickedFile!.path;  // Use the path for mobile
        }
      });
    } else {
      setState(() {
        _pickedFile = null;
        _filePath = null;
      });
    }

    print(_filePath);
    print(_pickedFile);
  }

void _uploadFile() async {

  print( "  _uploadFile  ");
  print(_filePath);

  if (_filePath == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please select a file before uploading.'),
    ));
    return;
  }

  final apiService = ApiService();
  setState(() {
    _isLoading = true;
  });
  print( "  _uploadFile  2 ");
  print(_filePath);
  // For web, we will use the bytes from the picked file
  if (kIsWeb && _pickedFile != null) {
    final fileBytes = _pickedFile!.bytes;
    String title = 'Course Title'; // Replace with actual title

    try {
      String result = await apiService.uploadFile(title, fileBytes!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  } else if (_filePath != null) {
    // For mobile, we will use the file path
    File file = File(_filePath!);
    String title = 'Course Title'; // Replace with actual title

    try {
      String result = await apiService.uploadFile(title, file);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Your File'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Choose a File to Upload',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _selectFile,
                child: Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Select File',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent,
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
                    Icon(Icons.check_circle, color: Colors.green),
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
                onPressed: _filePath == null || _isLoading
                    ? null
                    : _uploadFile,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Upload File'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 42, vertical: 24),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
