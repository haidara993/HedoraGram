import 'package:flutter/material.dart';
import 'package:hedoragram/pages/Home.dart';
import 'package:hedoragram/widgets/header.dart';
import 'package:hedoragram/widgets/post.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;

  const PostScreen({
    this.userId,
    this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef.doc(userId).collection("userPosts").doc(postId).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.orange),
          );
        }
        Post post = Post.fromDocument(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: header(context, titleText: post.description),
            body: ListView(
              children: [
                Container(
                  child: post,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
