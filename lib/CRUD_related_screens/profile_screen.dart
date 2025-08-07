import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/post_model.dart';
import '../widgets/post_card.dart';
import '../services/post_service.dart';

class ProfileScreen extends StatelessWidget {
  final PostService _postService = PostService();
  final user = FirebaseAuth.instance.currentUser;

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
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'Eco', style: TextStyle(color: Color(0xFF57DE45))),
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
                  icon: const Icon(Icons.search, color: Colors.black, size: 38),
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
                IconButton(
                  icon:
                      const Icon(Icons.settings, color: Colors.black, size: 38),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: user == null
          ? const Center(
              child: Text('Please sign in to view your profile'),
            )
          : StreamBuilder<List<Post>>(
              stream: _postService.getUserPosts(user!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final posts = snapshot.data ?? [];

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          const SizedBox(height: 16),
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: user?.photoURL != null
                                ? NetworkImage(user!.photoURL!)
                                : const AssetImage('images/man.png')
                                    as ImageProvider,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${user?.displayName ?? 'User'}\'s Timeline',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/profile_details');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Update Profile'),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 2,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          if (posts.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'No posts yet',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    } else {
                      final post = posts[index - 1];
                      return Container(
                        color: Colors.grey[100],
                        child: PostCard(
                          post: post,
                          onDelete: () async {
                            try {
                              await _postService.deletePost(post.id);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Post deleted successfully'),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to delete post: $e'),
                                ),
                              );
                            }
                          },
                          onEdit: () {
                            Navigator.pushNamed(
                              context,
                              '/edit',
                              arguments: post,
                            );
                          },
                        ),
                      );
                    }
                  },
                );
              },
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
            case 1:
              Navigator.pushReplacementNamed(context, '/create');
            case 2:
              break; // current profile screen
          }
        },
      ),
    );
  }
}
