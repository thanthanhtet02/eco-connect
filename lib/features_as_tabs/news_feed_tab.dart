import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';
import '../widgets/post_card.dart';
import '../CRUD_related_screens/edit_post_screen.dart';

class NewsFeedTab extends StatelessWidget {
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: StreamBuilder<List<Post>>(
        stream: _postService.getAllPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.post_add,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No posts yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/create'),
                    child: Text('Create a post'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: posts.length,
            itemBuilder: (context, index) => PostCard(
              post: posts[index],
              onDelete: () async {
                try {
                  await _postService.deletePost(posts[index].id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Post deleted successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete post: $e')),
                  );
                }
              },
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPostScreen(post: posts[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
