class Post {
  final String username;
  final String caption;
  final String image; 
  final int likes;
  final bool isLiked;

  Post({
    required this.username,
    required this.caption,
    required this.image, 
    required this.likes,
    this.isLiked = false,
  });
}
