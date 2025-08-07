import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../widgets/post_card.dart';

class NewsFeedTab extends StatelessWidget {
  final List<Post> posts = [
    Post(
      username: 'Jeff Wayne',
      caption: 'Sustainability is helping the world from climate change .',
      image: 'images/hands.png',
      likes: 101,
      isLiked: true,
    ),
    Post(
      username: 'Jeff Wayne',
      caption: 'Saving energy today.',
      image: 'images/eco_system.png',
      likes: 87,
      isLiked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: posts.length,
        itemBuilder:
            (BuildContext context, int index) => PostCard(post: posts[index]),
      ),
    );
  }
}
