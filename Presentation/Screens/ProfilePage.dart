
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recuirmentapp/Presentation/Screens/ViewPdf.dart';
import 'package:recuirmentapp/Providers/AuthProvider.dart';
import 'package:recuirmentapp/Themes/Themes.dart';
import 'package:recuirmentapp/main.dart';
import "dart:core";

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String country;
  String imageUrl;
  final String gender;
  final String phone;
  final String birthdate;
//  final String imageUrl;
  ProfilePage({
    Key? key,
    required this.name,
    required this.email,
    required this.country,
    required this.gender,
    required this.phone,
    required this.birthdate,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String filepath = "";
  bool isSelected = false;
  String imageUrl = "";
  final user = FirebaseAuth.instance.currentUser;
  QuerySnapshot<Map<String, dynamic>>? userStream;

  getUser() {
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: user!.email)
          .get()
          .then((value) {
        userStream = value;

        imageUrl = userStream!.docs[0]["ProfileImage"].toString();

        // print(name);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Your Profile",
          style: TextStyle(
              color: lightColorScheme.primary, fontFamily: "Roboto-Bold"),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                        radius: 100,
                        // backgroundColor: lightColorScheme.primary,
                        backgroundImage:
                            NetworkImage(user!.photoURL.toString())),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          style: IconButton.styleFrom(
                              backgroundColor: lightColorScheme.primary),
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            if (file == null) {
                              setState(() {
                                isSelected = false;
                              });
                              return;
                            }
                            setState(() {
                              filepath = file.path;
                              print(filepath);
                              isSelected = true;
                            });
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                isSelected
                    ? MaterialButton(
                        color: lightColorScheme.primary,
                        onPressed: () async {
                          Reference referenceImageToUpload =
                              FirebaseStorage.instance.refFromURL(imageUrl);
                          await referenceImageToUpload.putFile(File(filepath));
                          imageUrl =
                              await referenceImageToUpload.getDownloadURL();
                          print("Hii ${imageUrl}");
                          user!.updatePhotoURL(imageUrl);
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user!.email)
                              .update({"ProfileImage": imageUrl}).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Profile Picture Updated...")));
                          });
                          setState(() {
                            isSelected = false;
                          });
                        },
                        child: Text(
                          "Update Profile Image",
                          style: TextStyle(color: Colors.white),
                        ))
                    : Container(),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .where("email", isEqualTo: user!.email)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return MaterialButton(
                        height: 50,
                        elevation: 0,
                        color: lightColorScheme.primary,
                        minWidth: MediaQuery.of(context).size.width,
                        child: Text(
                          "View Resume",
                          style: TextStyle(
                              fontFamily: "Roboto-Bold",
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        onPressed: () {
                          Get.to(
                              ViewPdf(url: snapshot.data.docs[0]["ResumeLink"]),
                              transition: Transition.downToUp,
                              duration: Duration(milliseconds: 500));
                        },
                      );
                    } else {
                      return Text("");
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.name.toString(),
                          style: TextStyle(
                              fontFamily: "Roboto-Bold", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.email),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.email.toString(),
                          style: TextStyle(
                              fontFamily: "Roboto-Bold", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.birthdate.toString(),
                          style: TextStyle(
                              fontFamily: "Roboto-Bold", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.flag_rounded),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.country.toString(),
                          style: TextStyle(
                              fontFamily: "Roboto-Bold", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.phone.toString(),
                          style: TextStyle(
                              fontFamily: "Roboto-Bold", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        widget.gender.toString() == "Male"
                            ? Icon(Icons.male)
                            : Icon(Icons.female),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.gender.toString(),
                          style: TextStyle(
                              fontFamily: "Roboto-Bold", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  color: Colors.redAccent,
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    final provider = Provider.of<Auth>(context, listen: false);
                    provider.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => Main()));
                  },
                  child: Text(
                    "Sign Out",
                    style: TextStyle(fontFamily: "Roboto-Bold", fontSize: 20),
                  ),
                )
                //  Container(
                //   alignment: Alignment.center,
                //   height: 50,
                //   width: MediaQuery.of(context).size.width,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     color: Colors.red
                //   ),
                //   child: Text("Sign Out",style: TextStyle(fontFamily: "Roboto-Bold",fontSize: 20),),
                //  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
