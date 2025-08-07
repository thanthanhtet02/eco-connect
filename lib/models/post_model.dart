import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String username;
  final String caption;
  final String? image;
  final int likes;
  final List<String> likedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.caption,
    this.image,
    required this.likes,
    required this.likedBy,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert Post object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'caption': caption,
      'image': image,
      'likes': likes,
      'likedBy': likedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Create Post object from Firestore document
  factory Post.fromMap(String id, Map<String, dynamic> map) {
    return Post(
      id: id,
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      caption: map['caption'] ?? '',
      image: map['image'],
      likes: map['likes']?.toInt() ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Create a copy of Post with modified fields
  Post copyWith({
    String? id,
    String? userId,
    String? username,
    String? caption,
    String? image,
    int? likes,
    List<String>? likedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      caption: caption ?? this.caption,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
