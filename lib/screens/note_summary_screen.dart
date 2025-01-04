import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NoteSummaryScreen extends StatelessWidget {
  final String noteContent;

  NoteSummaryScreen({
    required this.noteContent,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(  // Make the screen scrollable
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 10),
            // Using MarkdownBody to parse and display the markdown content
            MarkdownBody(
              data: noteContent,
              styleSheet: MarkdownStyleSheet(
                h1: TextStyle(fontSize: 20,fontFamily: 'OpenSans', fontWeight: FontWeight.bold, color: Colors.blueAccent),
                h2: TextStyle(fontSize: 18,fontFamily: 'OpenSans', fontWeight: FontWeight.bold, color: Colors.blue),
                h3: TextStyle(fontSize: 16,fontFamily: 'OpenSans', fontWeight: FontWeight.bold, color: Colors.green),
                p: TextStyle(fontSize: 14,fontFamily: 'OpenSans', height: 1.5), // Corrected lineHeight to height
                strong: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.bold), // Bold text
                em: TextStyle(fontFamily: 'OpenSans',fontStyle: FontStyle.italic), // Italicized text
                blockquote: TextStyle(fontFamily: 'OpenSans',fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey), // Blockquotes
                code: TextStyle(fontFamily: 'Courier', fontSize: 14, color: Colors.green), // Inline code
                codeblockDecoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
                blockSpacing: 10,  // Adjust space between blocks
              ),
            ),
          ],
        ),
      ),
    );
  }
}
