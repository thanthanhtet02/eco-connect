import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../CRUD_related_screens/edit_post_screen.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({required this.post});

  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder:
          (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Delete Post",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  trailing: Transform.scale(
                    scale: 1.6,
                    child: Image.asset('images/delete.png'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showCustomDeleteDialog(context);
                  },
                ),
                const SizedBox(height: 25),
                ListTile(
                  title: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Edit Post",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  trailing: Transform.scale(
                    scale: 1.6,
                    child: const Icon(Icons.edit, color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPostScreen(post: post),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showCustomDeleteDialog(BuildContext context) {
    //dialog box for delete confirmation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.greenAccent),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 28, 20, 20),
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Are you sure you want to delete this post?',
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 34,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Cancel"),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 34,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Post deleted",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Color.fromARGB(255, 40, 176, 47),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('images/man.png'),
                ),
                const SizedBox(width: 10),
                Text(
                  post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showPostOptions(context),
                  child: const Icon(Icons.more_vert, size: 30),
                ),
              ],
            ),
          ),

          // Image
          Image.asset(
            post.image,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          // Caption and Actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      post.likes.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: post.isLiked ? Colors.red : Colors.black,
                      size: 30,
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.comment, size: 30),
                    const Spacer(),
                    const Icon(Icons.share, size: 30),
                  ],
                ),
                const SizedBox(height: 8),
                Text(post.caption, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
