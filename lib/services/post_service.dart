import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'posts';

  // CREATE: Add a new post
  Future<String> createPost(String userId, String username, String caption, String? imageUrl) async {
    try {
      // First check if the collection exists, if not create it
      final collectionRef = _firestore.collection(_collection);
      
      // Create the post document
      final data = {
        'userId': userId,
        'username': username,
        'caption': caption,
        'image': imageUrl,
        'likes': 0,
        'likedBy': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': null,
      };
      
      print('Attempting to create post with data: $data'); // Debug log
      
      final docRef = await collectionRef.add(data);
      print('Post created successfully with ID: ${docRef.id}'); // Debug log
      
      return docRef.id;
    } catch (e, stackTrace) {
      print('Error creating post: $e'); // Debug log
      print('Stack trace: $stackTrace'); // Debug stack trace
      throw Exception('Failed to create post: $e');
    }
  }

  // READ: Get all posts
  Stream<List<Post>> getAllPosts() {
    print('Starting getAllPosts stream'); // Debug log
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .handleError((error) {
          print('Error in getAllPosts stream: $error'); // Debug log
          throw Exception('Failed to fetch posts: $error');
        })
        .map((snapshot) {
          print('Received snapshot with ${snapshot.docs.length} documents'); // Debug log
          try {
            return snapshot.docs.map((doc) {
              try {
                return Post.fromMap(doc.id, doc.data());
              } catch (e) {
                print('Error parsing post ${doc.id}: $e'); // Debug log
                rethrow;
              }
            }).toList();
          } catch (e) {
            print('Error processing posts: $e'); // Debug log
            rethrow;
          }
        });
  }

  // READ: Get a single post by ID
  Future<Post?> getPostById(String postId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(postId).get();
      if (doc.exists) {
        return Post.fromMap(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get post: $e');
    }
  }

  // READ: Get user's posts
  Stream<List<Post>> getUserPosts(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Post.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  // UPDATE: Update a post
  Future<void> updatePost(String postId, String caption, String? imageUrl) async {
    try {
      await _firestore.collection(_collection).doc(postId).update({
        'caption': caption,
        'image': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  // UPDATE: Toggle like on a post
  Future<void> toggleLike(String postId, String userId) async {
    try {
      final postRef = _firestore.collection(_collection).doc(postId);
      
      return _firestore.runTransaction((transaction) async {
        final postDoc = await transaction.get(postRef);
        if (!postDoc.exists) {
          throw Exception('Post does not exist!');
        }

        final List<String> likedBy = List<String>.from(postDoc.data()!['likedBy'] ?? []);
        
        if (likedBy.contains(userId)) {
          likedBy.remove(userId);
          transaction.update(postRef, {
            'likes': FieldValue.increment(-1),
            'likedBy': likedBy,
          });
        } else {
          likedBy.add(userId);
          transaction.update(postRef, {
            'likes': FieldValue.increment(1),
            'likedBy': likedBy,
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  // DELETE: Delete a post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection(_collection).doc(postId).delete();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }
}
