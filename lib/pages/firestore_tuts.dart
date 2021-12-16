 //final userRef = FirebaseFirestore.instance.collection("users");
  // FirebaseFirestore? firestore;

 
 // getUser() async {
  //   final QuerySnapshot snapshot = await userRef.get();
  //   setState(() {
  //     users = snapshot.docs;
  //   });
  // }
  // getUserById() async {
  //   const String id = "Di72wdTaPVL87Ggoux3o";
  //   const String id2 = "Vyo7nnRZwWSEoGOO66yq";
  //   final DocumentSnapshot doc = await userRef.doc(id2).get();
  //   print(doc.data());
  //   print(doc.id);
  //   print(doc.exists);
  // }
  // createUser()  {
  //    userRef.doc("doctor").set({
  //     'isAdmin': false,
  //     'postsCount': 12,
  //     'userName': 'hamraj',
  //   });
  // }
  // updateUser() {
  //   userRef.doc('doctor').update({
  //     'isAdmin': false,
  //     'postsCount': 12,
  //     'userName': 'shyam',
  //   });
  // }
  // deleteUser() {
  //   userRef.doc('doctor').delete();
  // }

   // getUser();
    // getUserById();
    // createUser();
    // updateUser();
    // deleteUser();

    // body: StreamBuilder(
      //   stream: userRef.snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return circularProgress();
      //     }
      //     if (!snapshot.hasData) {
      //       return const Text("No Data Found");
      //     }
      //     final List<Text> children = snapshot.data!.docs
      //         .map((user) => Text(user['userName']))
      //         .toList();
      //     return ListView(
      //       children: children,
      //     );
      //   },
      // ),