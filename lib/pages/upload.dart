import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/constant/colors.dart';
import 'package:social/models/user.dart';
import 'package:social/widgets/custom_button.dart';
import 'package:social/widgets/progress.dart';
import 'package:uuid/uuid.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key, required this.currentUser}) : super(key: key);
  final User? currentUser;

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  final storage = FirebaseStorage.instance.ref();
  final postRef = FirebaseFirestore.instance.collection('posts');
  var file;
  bool isUploading = false;
  var imageFile;
  String postId = Uuid().v4();
  final ImagePicker _picker = ImagePicker();
  final timestamp = DateTime.now();

  selectCamera() async {
    Navigator.pop(context);
    file = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      file = File(file!.path);
    });
  }

  selectGallery() async {
    Navigator.pop(context);
    file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(file!.path);
    });
  }

  clearImage() {
    setState(() {
      file = null;
      isUploading = false;
    });
  }

  createPostInFirestore({
    String? mediaUrl,
    String? location,
    String? caption,
  }) {
    postRef
        .doc(widget.currentUser!.id)
        .collection('userPosts')
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": widget.currentUser!.id,
      "userName": widget.currentUser!.userName,
      "mediaUrl": mediaUrl,
      "caption": caption,
      "location": location,
      "timestamp": timestamp,
      "likes": {}
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    file = await compressImage(image: file);
    String mediaUrl = await uploadImage(file);
    createPostInFirestore(
        mediaUrl: mediaUrl,
        location: locationController.text,
        caption: captionController.text);
    locationController.clear();
    captionController.clear();
    setState(() {
      isUploading = false;
      file = null;
      postId = Uuid().v4();
    });
  }

  Future<String> uploadImage(image) async {
    UploadTask uploadTask = storage.child('post_$postId.jpg').putFile(image);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    var url = imageUrl.toString();
    return url;
  }

  compressImage(
      {required File image, int quality = 85, percentage = 30}) async {
    File path = await FlutterNativeImage.compressImage(image.absolute.path,
        quality: quality, percentage: percentage);
    return path;

    // final tempdir = await getTemporaryDirectory();
    // final path = tempdir.path;

    // imageFile = im.decodeImage(file.readAsBytesSync());
    // print(" imageFile : $imageFile");
    // final compressedImage = File('$path/img_/$postId')
    //   ..writeAsBytesSync(im.encodeJpg(imageFile, quality: 85));
  }

  buildUploadScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Post",
        ),
        leading: IconButton(
            onPressed: clearImage,
            icon: const Icon(
              Icons.clear,
            )),
        actions: [
          isUploading
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.done,
                    color: Colors.grey,
                  ))
              : IconButton(
                  onPressed: () => handleSubmit(), icon: const Icon(Icons.done))
        ],
      ),
      body: ListView(
        children: [
          isUploading ? linearProgress() : SizedBox(),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: Container(
                height: 220,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: primaryColor,
                  image: DecorationImage(
                    image: FileImage(file),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    widget.currentUser!.photoUrl.toString())),
            title: SizedBox(
              height: 50,
              child: TextField(
                controller: captionController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: const InputDecoration(
                    hintText: "Write a caption ..", border: InputBorder.none),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Theme.of(context).primaryColor,
              size: 30.0,
            ),
            title: TextField(
              controller: locationController,
              decoration: const InputDecoration(
                  hintText: "Where was this photo taken?",
                  border: InputBorder.none),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.my_location,
                color: primaryText,
              ),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  maximumSize:
                      Size(MediaQuery.of(context).size.width * 0.7, 50),
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.5, 40)),
              onPressed: () => getCurrentLocation(),
              label: const Text("Use Current Location"),
            ),
          )
        ],
      ),
    );
  }

  buildSplashScreen(Orientation orientation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/upload_image.svg',
          height: orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.4
              : MediaQuery.of(context).size.height * 0.5,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    children: [
                      SimpleDialogOption(
                        onPressed: selectCamera,
                        child: Row(
                          children: [
                            Icon(Icons.camera),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Camera")
                          ],
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: selectGallery,
                        child: Row(
                          children: [
                            Icon(Icons.photo),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Gallery")
                          ],
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context),
                        child: Row(
                          children: [
                            Icon(Icons.clear),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Cancel")
                          ],
                        ),
                      ),
                    ],
                  );
                });
          },
          child: CustomButton(text: "Upload Image"),
        ),
      ],
    );
  }

  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Please ! Keep your location ON");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(msg: "Location permission is denied");
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemark =
        await placemarkFromCoordinates(position.altitude, position.longitude);
    Placemark place = placemark[0];
    String address = '${place.locality}(${place.postalCode}), ${place.country}';

    setState(() {
      locationController.text = address == '' ? "Location Not Found" : address;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return file == null ? buildSplashScreen(orientation) : buildUploadScreen();
  }
}
