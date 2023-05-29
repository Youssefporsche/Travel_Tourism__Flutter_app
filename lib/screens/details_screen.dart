import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostDetailsScreen extends StatefulWidget {
  final String postId;

  PostDetailsScreen({required this.postId});

  @override
  PostDetailsScreenState createState() => PostDetailsScreenState();
}

class PostDetailsScreenState extends State<PostDetailsScreen> {
  final auth = FirebaseAuth.instance;
  final commentController = TextEditingController();
  double? userRating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final post = snapshot.data!.data() as Map<String, dynamic>;

            // Check if the current user is the author of the post
            // final currentUser = auth.currentUser;
            // final isAuthor = currentUser != null &&post['user_Id'].toString() == currentUser.uid;
            return Column(
              children: [
                Image.network(post['imageUrl']),
                SizedBox(height: 16),
                Text(
                  post['title'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(post['description']),
                SizedBox(height: 16),
                // Display the average rating of the post
                Text(
                  'Average rating: ${post['rating'].toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                // If the user is the author, display edit and delete buttons

                // Add a rating system for the post
                Text(
                  'Rate this post:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (int i = 1; i <= 5; i++) ...[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          userRating = i.toDouble();
                        });
                      },
                      icon: Icon(Icons.rate_review),
                    ),
                  ]
                ]),
              ],
            );
          }),
    );
  }
}
