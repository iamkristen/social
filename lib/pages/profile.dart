import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/constant/colors.dart';
import 'package:social/models/user.dart';
import 'package:social/pages/edit_profile.dart';
import 'package:social/widgets/custom_button.dart';
import 'package:social/widgets/header.dart';
import 'package:social/widgets/progress.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, this.profile}) : super(key: key);
  final profile;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final userRef = FirebaseFirestore.instance.collection("users");

  Column buildCountColumn(String text, int number) {
    return Column(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.headline2,
        ),
        Text(number.toString()),
      ],
    );
  }

  buildProfileHeader() {
    return FutureBuilder(
        future: userRef.doc(widget.profile.id).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument(snapshot.data);

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: 10,
              shadowColor: primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          CachedNetworkImageProvider(user.photoUrl ?? ""),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      user.displayName.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: primaryColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildCountColumn("Posts", 0),
                        buildCountColumn("Followers", 0),
                        buildCountColumn("Following", 0),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                        currentUser: widget.profile,
                                      )));
                        },
                        child: const CustomButton(text: "Edit Profile")),
                    SizedBox(
                      height: 5,
                    ),
                    // buildProfileButton(),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          // color: primaryColor,
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        user.bio.toString() != ""
                            ? user.bio.toString()
                            : "Everyone has limited time and energy",
                        // style: TextStyle(color:),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // buildProfileButton() {
  //   bool isProfileOwner = widget.profile.id == widget.profile.id;
  //   If(isProfileOwner) {
  //     return InkWell(
  //         onTap: () {}, child: const CustomButton(text: "Edit Profile"));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, title: "Profile"),
        body: ListView(
          children: [
            buildProfileHeader(),
          ],
        ));
  }
}
