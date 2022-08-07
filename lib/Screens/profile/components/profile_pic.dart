import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? _imageFile;
  String? uid;
  String imageUrl = "";
  DatabaseReference? _dbref;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    _dbref = FirebaseDatabase.instance.ref('users');
    getData();
  }

  void getData() {
    _dbref!
        .child(uid!)
        .child('basic_details')
        .child('profilepic')
        .onValue
        .listen((DatabaseEvent event) {
      final url = event.snapshot.value.toString();
      print(url);
      setState(() {
        imageUrl = url;
      });
    });
  }

  void takePhoto(ImageSource source) async {
    final storageRef =
        FirebaseStorage.instance.ref().child("/$uid/profile.jpg");
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");

    final pickedFile = await _picker.pickImage(source: source);
    final tempFile;
    if (pickedFile != null) {
      tempFile = File(pickedFile.path);
      try {
        await storageRef.putFile(tempFile);
      } on FirebaseException catch (e) {
        // ...
      }
      try {
        imageUrl = await storageRef.getDownloadURL();
        print(imageUrl);
        await ref.child('basic_details').update({
          "profilepic": imageUrl,
        });
      } on FirebaseException catch (e) {
        // ...
      }
    } else {
      return;
    }
    setState(() {
      _imageFile = tempFile;
    });
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile Picture",
            style: TextStyle(
              color: kTextColor,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.image),
                label: Text("Gallery"),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: //(_imageFile == null)
                //     ? const AssetImage("assets/images/Pofile Image.png")
                //     : FileImage(_imageFile!) as ImageProvider,
                (imageUrl == "")
                    ? const AssetImage("assets/images/Pofile Image.png")
                    : Image.network(imageUrl).image,
          ),
          Positioned(
              right: -12,
              bottom: 0,
              child: SizedBox(
                height: 46,
                width: 46,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white),
                    ),
                    backgroundColor: Color(0xfff5f6f9),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context, builder: (builder) => bottomSheet());
                  },
                  child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                ),
              )),
        ],
      ),
    );
  }
}
