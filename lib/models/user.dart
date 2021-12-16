import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String? userName;
  final String? displayName;
  final String? email;
  final String? bio;
  final String? photoUrl;

  User({
    this.id,
    this.userName,
    this.displayName,
    this.email,
    this.bio,
    this.photoUrl,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      userName: doc['userName'],
      displayName: doc['displayName'],
      email: doc['email'],
      bio: doc['bio'],
      photoUrl: doc['photoUrl'],
    );
  }
}
