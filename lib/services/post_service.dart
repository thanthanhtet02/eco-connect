import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'posts';

  PostService() {
    // Debug initialization
    print('PostService: Initializing with Firestore instance');
    print('PostService: Database exists: ${_firestore != null}');
    print('PostService: Database settings: ${_firestore.settings.toString()}');
    print('PostService: Host: ${_firestore.settings.host}');
    // Test collection access
    _firestore.collection(_collection).get().then((snapshot) {
      print('PostService: Successfully accessed posts collection');
    }).catchError((error) {
      print('PostService: Error accessing posts collection: $error');
    });
  }

  // CREATE: Add a new post
  Future<String> createPost(String userId, String username, String caption, String? imageUrl) async {
    try {
      print('PostService: Starting createPost');
      print('PostService: User ID: $userId');
      
      // First check if the collection exists, if not create it
      final collectionRef = _firestore.collection(_collection);
      print('PostService: Got collection reference');
      
      // Set a longer timeout for web operations
      final timeout = Duration(seconds: 30);
      
      // Test collection access before creating
      try {
        // Use a timeout for the test query
        await Future.any([
          collectionRef.limit(1).get(),
          Future.delayed(timeout).then((_) => throw TimeoutException('Test query timed out')),
        ]);
        print('PostService: Successfully tested collection access');
      } catch (e) {
        print('PostService: Error testing collection access: $e');
        if (e is TimeoutException) {
          print('PostService: Test query timed out - trying to proceed anyway');
        } else {
          throw Exception('Collection access failed: $e');
        }
      }
      
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
      
      print('PostService: Attempting to create post with data: $data');
      
      try {
        // Use timeout for the operation
        final docRef = await Future.any([
          collectionRef.add(data),
          Future.delayed(timeout).then((_) => throw TimeoutException('Operation timed out')),
        ]);
        print('PostService: Post created successfully with ID: ${docRef.id}');
        return docRef.id;
      } catch (e) {
        print('PostService: Error in add() operation: $e');
        if (e is TimeoutException) {
          print('PostService: Operation timed out - this might be a network issue');
        }
        throw e;
      }
    } catch (e, stackTrace) {
      print('PostService: Error creating post: $e');
      print('PostService: Stack trace: $stackTrace');
      if (e is FirebaseException) {
        print('PostService: Firebase error code: ${e.code}');
        print('PostService: Firebase error message: ${e.message}');
      }
      throw Exception('Failed to create post: $e');
    }
  }

  // READ: Get all posts
  Stream<List<Post>> getAllPosts() {
    print('PostService: Starting getAllPosts stream');
    
    // First test if we can access the collection
    _firestore.collection(_collection).limit(1).get().then((snapshot) {
      print('PostService: Test query successful');
    }).catchError((error) {
      print('PostService: Test query failed: $error');
      if (error is FirebaseException) {
        print('PostService: Firebase error code: ${error.code}');
        print('PostService: Firebase error message: ${error.message}');
      }
    });

    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .handleError((error) {
          print('PostService: Error in getAllPosts stream: $error');
          if (error is FirebaseException) {
            print('PostService: Firebase error code: ${error.code}');
            print('PostService: Firebase error message: ${error.message}');
          }
          throw Exception('Failed to fetch posts: $error');
        })
        .map((snapshot) {
          print('PostService: Received snapshot with ${snapshot.docs.length} documents');
          try {
            return snapshot.docs.map((doc) {
              try {
                final data = doc.data();
                print('PostService: Processing document ${doc.id}: $data');
                return Post.fromMap(doc.id, data);
              } catch (e) {
                print('PostService: Error parsing post ${doc.id}: $e');
                rethrow;
              }
            }).toList();
          } catch (e) {
            print('PostService: Error processing posts: $e');
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
