import 'package:flutter/material.dart';

class AIScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Consultation'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back press to navigate to Home
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.deepPurpleAccent, // AppBar color
      ),
      body: Container(
        color: Colors.blue.shade50, // Background color
        child: Column(
          children: [
            // Expanded section for the main content
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    'AI Consultation Content Here',
                    style:
                        TextStyle(fontSize: 20, color: Colors.deepPurpleAccent),
                  ),
                ),
              ),
            ),

            // Bottom input area with message box and send button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.shade100,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Files button (Attachment Icon)
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.deepPurple),
                    onPressed: () {
                      // Handle file attachment action
                    },
                  ),

                  // Message input field
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Message Box',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  // Send button with send icon
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurpleAccent,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        // Handle send action
                      },
                    ),
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
