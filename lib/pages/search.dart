import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social/constant/colors.dart';
import 'package:social/models/user.dart';
import 'package:social/widgets/progress.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  final userRef = FirebaseFirestore.instance.collection("users");
  Future<QuerySnapshot>? searchResultFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users =
        userRef.where("userName", isGreaterThanOrEqualTo: query).get();
    setState(() {
      searchResultFuture = users;
      print(searchResultFuture);
    });
  }

  buildSearchContent() {
    return FutureBuilder(
        future: searchResultFuture,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<UserResult> searchResult = [];
          snapshot.data!.docs.forEach((doc) {
            User user = User.fromDocument(doc);
            UserResult searchResults = UserResult(user: user);

            searchResult.add(searchResults);
          });
          return ListView(
            children: searchResult,
          );
        });
  }

  AppBar buildSearchBar() {
    return AppBar(
      title: SizedBox(
        height: 50.0,
        child: TextFormField(
          controller: searchController,
          style: TextStyle(color: Theme.of(context).primaryColor),
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              fillColor: Colors.white,
              focusColor: Theme.of(context).primaryColor,
              filled: true,
              hintText: "Search for a user ...",
              prefixIcon: Icon(Icons.account_box,
                  color: Theme.of(context).primaryColor),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  searchController.clear();
                },
              )),
          onFieldSubmitted: handleSearch,
        ),
      ),
    );
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          SvgPicture.asset(
            "assets/images/search.svg",
            height: orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.7
                : MediaQuery.of(context).size.height * 0.5,
          ),
          // Text(
          //   "Find Users",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //       color: Theme.of(context).primaryColor,
          //       fontFamily: 'signatra',
          //       fontSize: orientation == Orientation.portrait ? 50 : 30,
          //       letterSpacing: 1.5),
          // )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchBar(),
      body:
          searchResultFuture == null ? buildNoContent() : buildSearchContent(),
    );
  }
}

class UserResult extends StatelessWidget {
  const UserResult({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("tapped");
      },
      child: ListTile(
        // tileColor: Theme.of(context).primaryColor,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          backgroundImage: CachedNetworkImageProvider(
            user.photoUrl.toString(),
          ),
        ),
        title: Text(user.displayName.toString(),
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(user.userName.toString(),
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: secondaryText)),
      ),
    );
  }
}
