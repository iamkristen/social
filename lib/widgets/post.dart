import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String userName;
  final String location;
  final String caption;
  final String mediaUrl;
  final dynamic likes;

  const Post(
      {Key? key,
      required this.postId,
      required this.ownerId,
      required this.userName,
      required this.location,
      required this.caption,
      required this.mediaUrl,
      required this.likes})
      : super(key: key);

  factory Post.fromDocument(doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      userName: doc['userName'],
      location: doc['location'],
      caption: doc['caption'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
    );
  }

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
