import 'package:flutter/material.dart';
import 'package:social/widgets/custom_image.dart';
import 'package:social/widgets/post.dart';

class PostTile extends StatelessWidget {
  PostTile({Key? key, required this.post}) : super(key: key);
  Post post;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print("show image"),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
