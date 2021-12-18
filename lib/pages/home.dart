import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social/constant/colors.dart';
import 'package:social/models/user.dart';
import 'package:social/pages/activity_feed.dart';
import 'package:social/pages/create_account.dart';
import 'package:social/pages/profile.dart';
import 'package:social/pages/search.dart';
import 'package:social/pages/upload.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  String gLogo = "assets/images/Glogo.svg";
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? user;
  PageController? pageController;
  int pageIndex = 0;
  final userRef = FirebaseFirestore.instance.collection("users");
  final timestamp = DateTime.now();
  User? currentUser;

  @override
  void initState() {
    super.initState();

    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (error) {});
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((error) {
      // print("Error in : $error");
    });
    pageController = PageController();
  }

  void logout() async {
    await googleSignIn.signOut();
    setState(() {
      isAuth = false;
    });
  }

  handleSignIn(GoogleSignInAccount? account) {
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    // 1)check if user exists in users collection in database (according to their id)
    // 2)if the user doesn't exists in databse then we want to take them to the create page account
    // 3)get username from create account, use it to make new user document in user collection
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    DocumentSnapshot doc = await userRef.doc(user!.id).get();

    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
      userRef.doc(doc.id).set({
        'id': doc.id,
        'userName': username,
        'photoUrl': user.photoUrl,
        'email': user.email,
        'displayName': user.displayName,
        'bio': "",
        'timestamp': timestamp,
      });
      doc = await userRef.doc(user.id).get();
    }
    currentUser = User.fromDocument(doc);
  }

  void login() {
    googleSignIn.signIn();
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  void onTap(int pageIndex) {
    pageController!.animateToPage(pageIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }

  Widget buildAuthScreen() {
    return Scaffold(
        body: PageView(
          children: [
            // Timeline(),
            ElevatedButton(
              onPressed: () => logout(),
              child: Text("logout"),
            ),
            ActivityFeed(),
            Upload(
              currentUser: currentUser,
            ),
            Search(),
            Profile(
              profile: currentUser,
            ),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.whatshot),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera_back,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
            ),
          ],
        ));
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 300,
                width: 300,
                child: SvgPicture.asset("assets/images/logo.svg")),
            Text(
              "Social",
              style: Theme.of(context).textTheme.headline1!.copyWith(
                  fontSize: 90,
                  color: Theme.of(context).primaryColor,
                  fontFamily: "signatra"),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  login();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        gLogo,
                      ),
                      Text(
                        "Sign in With Google",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            letterSpacing: 1,
                            color: primaryText,
                            fontSize: 18,
                            fontFamily: "signatra"),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController!.dispose();
  }
}
