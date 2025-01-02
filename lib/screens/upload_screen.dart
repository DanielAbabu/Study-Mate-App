import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _filePath;

  // Function to pick a file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        // Use 'name' and 'bytes' for web and other platforms.
        _filePath = result.files.single.name; // Get the file name
        final fileBytes = result.files.single.bytes; // Access file content

        // You can handle the bytes for upload if needed
        if (fileBytes != null) {
          // Simulate saving or uploading the fileBytes
          print('File selected: $_filePath');
        }
      });
    }
  }

  // Function to simulate file upload
  Future<void> _uploadFile() async {
    if (_filePath != null) {
      // Simulate upload process with a delay
      await Future.delayed(Duration(seconds: 3));
      // Here you can add actual upload code (e.g., API call)
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('File uploaded successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Your File'),
        backgroundColor: Colors.blueAccent,
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Display selected file name or prompt for file selection
              Text(
                _filePath == null
                    ? 'No file selected'
                    : 'Selected file: ${_filePath!.split('/').last}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickFile,
                child: Text('Select File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadFile,
                child: Text('Upload File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              // Show progress indicator while uploading
              if (_filePath != null) CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
