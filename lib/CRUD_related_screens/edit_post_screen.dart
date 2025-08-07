import 'package:flutter/material.dart';
import '../models/post_model.dart';

class EditPostScreen extends StatelessWidget {
  final Post post;
  final TextEditingController captionController;

  EditPostScreen({required this.post})
    : captionController = TextEditingController(
        text: post.caption,
      ); //load the existing caption

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'Eco', style: TextStyle(color: Color(0xFF57DE45))),
              TextSpan(text: 'Connect', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        actions: [
          // Search and Settings buttons
          IconButton(
            icon: Icon(Icons.search, color: Colors.black, size: 35),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black, size: 35),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('images/man.png'),
                        radius: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        post.username,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            //  Image
            Image.asset(
              post.image,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),

            SizedBox(height: 16),

            // Caption input and load old caption text from post
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Color(0xFFD8EFD5)),
                child: TextField(
                  controller: captionController,
                  maxLines: null,
                  decoration: InputDecoration.collapsed(
                    hintText: "Edit caption...",
                  ),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Change picture option
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.image, size: 35),
                  SizedBox(width: 8),
                  Text("Change picture", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            SizedBox(height: 140),

            // Update Button
            Center(
              child: SizedBox(
                width: 140,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF57DE45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
