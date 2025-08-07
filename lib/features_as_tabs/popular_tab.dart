import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../widgets/post_card.dart';
import '../services/post_service.dart';

class PopularTab extends StatelessWidget {
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

          // Sort posts by likes in descending order
          posts.sort((a, b) => b.likes.compareTo(a.likes));

          // Take only top 10 posts
          final popularPosts = posts.length > 10 ? posts.sublist(0, 10) : posts;

          if (popularPosts.isEmpty) {
            return Center(
              child: Text(
                'No posts yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: popularPosts.length,
            itemBuilder: (context, index) => PostCard(
              post: popularPosts[index],
            ),
          );
        },
      ),
    );
  }
}
