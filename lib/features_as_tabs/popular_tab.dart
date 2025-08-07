import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../widgets/post_card.dart';

class PopularTab extends StatelessWidget {
  final List<Post> popularPosts = [
    Post(
      username: 'Jeff Wayne',
      caption: 'Sustainability is helping the world from climate change .',
      image: 'images/hands.png',
      likes: 100,
      isLiked: false,
    ),
    Post(
      username: 'Jeff Wayne',
      caption: 'Plastic-free day challenge ',
      image: 'images/hands.png',
      likes: 150,
      isLiked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: popularPosts.length,
        itemBuilder:
            (BuildContext context, int index) =>
                PostCard(post: popularPosts[index]),
      ),
    );
  }
}
