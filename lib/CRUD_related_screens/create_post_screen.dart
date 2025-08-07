import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class CreatePostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Eco',
                style: TextStyle(
                  color: Color(0xFF57DE45),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              TextSpan(
                text: 'Connect',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.black, size: 38),
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.black, size: 38),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('images/man.png'),
                  radius: 24,
                ),
                SizedBox(width: 12),
                Text(
                  "Jeff Wayne",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Input box
            Container(
              height: 250,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Color(0xFFD8EFD5)),
              child: TextField(
                maxLines: null,
                decoration: InputDecoration.collapsed(
                  hintText: "What is on your mind ?",
                ),
              ),
            ),
            SizedBox(height: 30),

            // Take a picture
            Row(
              children: [
                Image.asset('images/camera.png', width: 38, height: 38),
                SizedBox(width: 8),
                Text("Take a picture", style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 50),
            // Add a picture
            Row(
              children: [
                Icon(Icons.image, size: 40),
                SizedBox(width: 8),
                Text("Add a picture", style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 50),

            // Post Button
            Center(
              child: SizedBox(
                width: 120,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    //leaved for  Post function
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF57DE45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Post",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              break; // current screen
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
