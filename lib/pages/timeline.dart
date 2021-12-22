import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/constant/colors.dart';
import 'package:social/models/user.dart';
import 'package:social/widgets/custom_image.dart';
import 'package:social/widgets/header.dart';
import 'package:social/widgets/post.dart';
import 'package:social/widgets/progress.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isApptitle: true),
        body: Center(
          child: Text("Currently Timeline Not Available"),
        ));
  }
}
