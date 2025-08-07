import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/post_model.dart';
import '../widgets/post_card.dart';

class ProfileScreen extends StatelessWidget {
  final List<Post> userPosts = [
    Post(
      username: 'Jeff Wayne',
      caption: 'This is about sustainability.',
      image: 'images/eco_system.png',
      likes: 1,
      isLiked: false,
    ),
    Post(
      username: 'Jeff Wayne',
      caption: 'Helping the planet together!',
      image: 'images/hands.png',
      likes: 58,
      isLiked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'Eco', style: TextStyle(color:  Color(0xFF57DE45))),
              TextSpan(text: 'Connect', style: TextStyle(color: Colors.black)),
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
      body: ListView.builder(//list to build profile header and posts for profile 
        padding: EdgeInsets.zero,
        itemCount: userPosts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {    //avoid index 0 for profile section
            //  Profile section
            return Column(
              children: [
                SizedBox(height: 16),
                CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('images/man.png'),
                ),
                SizedBox(height: 12),
                Text(
                  'Jeff Wayne’s Timeline',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {   Navigator.pushNamed(context, '/profile_details');},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Update Profile'),
                ),
                SizedBox(height: 16),
                Container(height: 2, color: const Color.fromARGB(255, 0, 0, 0)),
              ],
            );
          } else {
            //  Posts below profile section
            return Container(
              color: Colors.grey[100],

              child: PostCard(post: userPosts[index - 1]),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/create');
              break;
            case 2:
              break; // current profile screen
          }
        },
      ),
    );
  }
}
