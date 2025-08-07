import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import '../widgets/bottom_nav_bar.dart';
import '../services/post_service.dart';
import '../services/storage_service.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final PostService _postService = PostService();
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _createPost() async {
    if (_captionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a caption')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _storageService.uploadPostImage(user.uid, _imageFile!);
      }

      await _postService.createPost(
        user.uid,
        user.displayName ?? 'Anonymous',
        _captionController.text.trim(),
        imageUrl,
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
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
              decoration: BoxDecoration(
                color: Color(0xFFD8EFD5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _captionController,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                  hintText: "What is on your mind?",
                ),
              ),
            ),
            if (_imageFile != null) ...[
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _imageFile!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            SizedBox(height: 30),

            // Take a picture
            InkWell(
              onTap: () => _pickImage(ImageSource.camera),
              child: Row(
                children: [
                  Image.asset('images/camera.png', width: 38, height: 38),
                  SizedBox(width: 8),
                  Text("Take a picture", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 50),
            // Add a picture
            InkWell(
              onTap: () => _pickImage(ImageSource.gallery),
              child: Row(
                children: [
                  Icon(Icons.image, size: 40),
                  SizedBox(width: 8),
                  Text("Add a picture", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 50),

            // Post Button
            Center(
              child: SizedBox(
                width: 120,
                height: 45,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createPost,
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
