import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/widgets/header.dart';
import 'package:social/widgets/progress.dart';

class ActivityFeed extends StatefulWidget {
  const ActivityFeed({Key? key}) : super(key: key);

  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  final activityFeedRef = FirebaseFirestore.instance.collection("activityFeed");
  final userRef = FirebaseFirestore.instance.collection("users");
  final postRef = FirebaseFirestore.instance.collection("posts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title: "Activity Feed", removeBackButton: true),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://mirchiplay.com/wp-content/uploads/2020/06/akshay-kumar-scheme-pose.jpg'),
            ),
            title: Row(
              children: [
                Text(
                  "Raju ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "likes your post",
                ),
              ],
            ),
            subtitle: Text(
              "2 hours ago",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            trailing: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/social-13dab.appspot.com/o/post_35fa2c88-1225-407f-8e94-dd9edab155f1.jpg?alt=media&token=3ce7efcb-6535-4d3b-8e68-2d6f265279f5"),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://mirchiplay.com/wp-content/uploads/2020/06/akshay-kumar-scheme-pose.jpg'),
            ),
            title: Row(
              children: [
                Text(
                  "Raju ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "commented on your post",
                ),
              ],
            ),
            subtitle: Text(
              "2 hours ago",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            trailing: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/social-13dab.appspot.com/o/post_35fa2c88-1225-407f-8e94-dd9edab155f1.jpg?alt=media&token=3ce7efcb-6535-4d3b-8e68-2d6f265279f5"),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage('https://static.toiimg.com/photo/34967827.cms'),
            ),
            title: Row(
              children: [
                Text(
                  "Babu Rao ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "started following you.",
                ),
              ],
            ),
            subtitle: Text(
              "4 hours ago",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            // trailing: Container(
            //   height: 50,
            //   width: 50,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: NetworkImage(
            //             "https://firebasestorage.googleapis.com/v0/b/social-13dab.appspot.com/o/post_35fa2c88-1225-407f-8e94-dd9edab155f1.jpg?alt=media&token=3ce7efcb-6535-4d3b-8e68-2d6f265279f5"),
            //         fit: BoxFit.cover),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}

class ActivityFeedItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Activity Feed Item');
  }
}
