import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social/constant/colors.dart';
import 'package:social/models/user.dart';
import 'package:social/pages/home.dart';
import 'package:social/widgets/custom_button.dart';
import 'package:social/widgets/progress.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    Key? key,
    this.currentUser,
  }) : super(key: key);
  final currentUser;
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final userRef = FirebaseFirestore.instance.collection("users");
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  User? user;
  DocumentSnapshot? doc;
  bool _displayNameValid = true;
  bool _bioValid = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });

    doc = await userRef.doc(widget.currentUser!.id).get();
    user = User.fromDocument(doc);
    displayNameController.text = user!.displayName.toString();
    bioController.text = user!.bio.toString();
    setState(() {
      isLoading = false;
    });
  }

  void logout() async {
    await googleSignIn.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      bioController.text.trim().length > 50
          ? _bioValid = false
          : _bioValid = true;
    });
    if (_displayNameValid && _bioValid) {
      print(widget.currentUser.id);
      userRef.doc(widget.currentUser.id).update({
        "displayName": displayNameController.text,
        "bio": bioController.text
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Profile Updated"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: const Text("Edit Profile"),
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: CachedNetworkImageProvider(
                            user!.photoUrl.toString()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          buildTextField(
                              "Display Name",
                              "Update Display Name",
                              _displayNameValid
                                  ? ""
                                  : "Display Name can't be less than 3 letters",
                              displayNameController),
                          buildTextField(
                              "Bio",
                              "Update Bio",
                              _bioValid
                                  ? ""
                                  : "Bio can't be more than 50 letters",
                              bioController),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: updateProfileData,
                      child: const CustomButton(text: "Update Profile"),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(primary: primaryColor),
                      onPressed: logout,
                      icon: const Icon(
                        Icons.cancel,
                        size: 28,
                      ),
                      label: Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  buildTextField(
    String? label,
    String? hint,
    String? error,
    TextEditingController? controller,
  ) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          style: TextStyle(color: Theme.of(context).primaryColor),
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            errorText: error,
            hintText: hint,
            labelText: label,
            labelStyle: TextStyle(color: secondaryText),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            fillColor: Colors.white,
            focusColor: Theme.of(context).primaryColor,
            filled: true,
          ),
        ));
  }
}
