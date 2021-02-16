import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hedoragram/pages/post_screen.dart';
import 'package:hedoragram/widgets/post.dart';

class PostTile extends StatelessWidget {
  final Post post;
  const PostTile(this.post);

  showPost(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostScreen(
            postId: post.postId,
            userId: post.ownerId,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPost(context),
      child: CachedNetworkImage(
        imageUrl: post.mediaUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.orange),
          ),
        ),
      ),
    );
  }
}
