import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social/constant/colors.dart';
import 'package:social/models/user.dart';
import 'package:social/pages/comments.dart';
import 'package:social/pages/edit_profile.dart';
import 'package:social/widgets/custom_button.dart';
import 'package:social/widgets/custom_image.dart';
import 'package:social/widgets/header.dart';
import 'package:social/widgets/post.dart';
import 'package:social/widgets/post_tile.dart';
import 'package:social/widgets/progress.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, this.profile}) : super(key: key);
  final profile;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  final userRef = FirebaseFirestore.instance.collection("users");
  final postRef = FirebaseFirestore.instance.collection("posts");

  bool isLoading = false;
  int? postCount;
  List<Post> posts = [];
  bool isLiked = false;

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

  @override
  void initState() {
    super.initState();
    getProfilePost();
  }

  getProfilePost() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postRef
        .doc(widget.profile.id)
        .collection("userPosts")
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      isLoading = false;
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  showComments() {
    return Column(
      children: [
        SizedBox(
          height: 20,
          child: Text(
            "Comments",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://scontent.fktm9-2.fna.fbcdn.net/v/t39.30808-6/255561406_1591474381213575_938542215159620760_n.jpg?_nc_cat=107&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=Z1LVpl4AEUAAX9pz7o7&tn=HwUJLqiSfo5LGBQy&_nc_ht=scontent.fktm9-2.fna&oh=00_AT8YPLUuApxDbP43q25O8dAOs6wiu_f-mPfKhJcRLPoX3w&oe=61C61347'),
          ),
          title: Text(
            "Kristen",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Testing Comment",
            style: TextStyle(backgroundColor: Colors.grey),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: primaryColor,
            ),
            onPressed: () {},
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://mirchiplay.com/wp-content/uploads/2020/06/akshay-kumar-scheme-pose.jpg'),
          ),
          title: Text(
            "Raju",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Aha, Nice design",
            style: TextStyle(backgroundColor: Colors.grey),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.favorite,
              color: primaryColor,
            ),
            onPressed: () {},
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage:
                NetworkImage('https://static.toiimg.com/photo/34967827.cms'),
          ),
          title: Text(
            "Babu Rao Ganpat Rao Aapte",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Ae Dewa! ",
            style: TextStyle(backgroundColor: Colors.grey),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.favorite,
              color: primaryColor,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  handleLikePost() {
    setState(() {
      isLiked = isLiked ? false : true;
    });
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
                    const SizedBox(
                      height: 5,
                    ),
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

  buildPostHeader({
    required String? ownerId,
    required String? location,
  }) {
    return FutureBuilder(
        future: userRef.doc(ownerId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument(snapshot.data);
          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(user.photoUrl.toString()),
            ),
            title: GestureDetector(
              onTap: () => print("profile Clicked"),
              child: Text(
                user.displayName.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Text(
              location.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 14, color: Colors.grey),
            ),
            trailing: IconButton(
              onPressed: () {
                print("post delete");
              },
              icon: const Icon(Icons.more_vert),
            ),
          );
        });
  }

  buildPostImage({required String? mediaUrl}) {
    return GestureDetector(
      onDoubleTap: handleLikePost,
      child: Stack(
        alignment: Alignment.center,
        children: [
          cachedNetworkImage(mediaUrl.toString()),
        ],
      ),
    );
  }

  buildPostFooter(
      {required int? likeCount,
      required String? userName,
      required String? caption}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: handleLikePost,
              icon:
                  isLiked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: ((builder) {
                      return showComments();
                    }));
              },
              icon: Icon(Icons.comment),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                isLiked ? "1" : "0",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text("Likes ", style: Theme.of(context).textTheme.bodyText2),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "$userName ",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                caption.toString(),
              ),
            ],
          ),
        )
      ],
    );
  }

  int getLikesCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.foreach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  buildListPost() {
    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, i) {
          return Column(
            children: [
              buildPostHeader(
                  ownerId: posts[i].ownerId, location: posts[i].location),
              buildPostImage(mediaUrl: posts[i].mediaUrl),
              buildPostFooter(
                  likeCount: 0,
                  userName: posts[i].userName,
                  caption: posts[i].caption),
              Divider(),
            ],
          );
        });
  }

  buildGridPost() {
    List<GridTile> gridTiles = [];
    posts.forEach((post) {
      gridTiles.add(GridTile(
        child: PostTile(
          post: post,
        ),
      ));
    });
    return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        shrinkWrap: true,
        children: gridTiles);
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: header(context, title: "Profile"),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  children: [
                    buildProfileHeader(),
                  ],
                ),
              ),
              expandedHeight: 380.0,
              bottom: TabBar(
                  controller: _tabController,
                  labelColor: primaryColor,
                  indicatorColor: primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(
                      iconMargin: EdgeInsets.all(2.0),
                      icon: Icon(Icons.grid_on),
                    ),
                    Tab(
                      iconMargin: EdgeInsets.all(2.0),
                      icon: Icon(Icons.list),
                    ),
                  ]),
            ),
          ];
        },
        body: SizedBox(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: TabBarView(
              controller: _tabController,
              children: [
                posts.isEmpty ? buildNoContent(orientation) : buildGridPost(),
                posts.isEmpty ? buildNoContent(orientation) : buildListPost(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildNoContent(Orientation orientation) {
    return ListView(
      shrinkWrap: true,
      children: [
        SvgPicture.asset(
          "assets/images/no_data.svg",
          height: orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.5
              : MediaQuery.of(context).size.height * 0.5,
        ),
        Text(
          "No  Post  Found",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w900,
              fontFamily: 'signatra'),
        )
      ],
    );
  }
}
