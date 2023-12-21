import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:recuirmentapp/Presentation/Screens/AdminDashboard.dart';
import 'package:recuirmentapp/Presentation/Screens/ViewPdf.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class FreelancerDetails extends StatefulWidget {
  final String email;
  final String title;
  FreelancerDetails({Key? key, required this.email, required this.title})
      : super(key: key);

  @override
  State<FreelancerDetails> createState() => _FreelancerDetailsState();
}

class _FreelancerDetailsState extends State<FreelancerDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Freelancer Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where("email", isEqualTo: widget.email)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return CircleAvatar(
                      radius: 100,
                      backgroundImage:
                          NetworkImage(snapshot.data.docs[0]["ProfileImage"]),
                    );
                  } else {
                    return Text("");
                  }
                },
              ),
              SizedBox(
                height: 25,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Jobs")
                    .doc(widget.title)
                    .collection("Proposels")
                    .where("Email", isEqualTo: widget.email)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "Country",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "Email",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "Skill1",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "Skill2",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "Skill3",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "Price",
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ":",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                ":",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                ":",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                ":",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                ":",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                ":",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                ":",
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data.docs[0]["Name"],
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                snapshot.data.docs[0]["Country"],
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                snapshot.data.docs[0]["Email"],
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                snapshot.data.docs[0]["Skill1"],
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                snapshot.data.docs[0]["Skill2"],
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                snapshot.data.docs[0]["Skill3"],
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "Rs. ${snapshot.data.docs[0]["Price"]}",
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return Text("");
                  }
                },
              ),
              SizedBox(
                height: 35,
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .where("email", isEqualTo: widget.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return MaterialButton(
                        height: 50,
                        minWidth: 300,
                        color: lightColorScheme.primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.file,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "See Resume",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Roboto-Bold",
                                  fontSize: 18),
                            )
                          ],
                        ),
                        onPressed: () {
                          Get.to(ViewPdf(
                                  url: snapshot.data!.docs[0]["ResumeLink"]),duration: Duration(milliseconds: 500,),transition: Transition.downToUp);
                        },
                      );
                    } else {
                      return Text("");
                    }
                  }),
                  SizedBox(height: 30,),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Jobs")
                    .doc(widget.title)
                    .collection("Proposels")
                    .where("Email", isEqualTo: widget.email)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return MaterialButton(
                      minWidth: 400,
                      height: 50,
                      color: Colors.amber,
                      child: Text("Hire",style: TextStyle(color: lightColorScheme.primary,fontFamily: "Roboto-Bold",fontSize: 20),),
                      onPressed: () {
                      FirebaseFirestore.instance
                          .collection("Jobs")
                          .doc(snapshot.data.docs[0]["Title"])
                          .update({
                        "Sealed": true,
                        "SealedBy": snapshot.data.docs[0]["Name"].toString(),
                        "SealedByEmail":
                            snapshot.data.docs[0]["Email"].toString(),
                        "ProposedPrice":snapshot.data.docs[0]["Price"]
                      });
                      FirebaseFirestore.instance
                          .collection('Jobs')
                          .doc(snapshot.data.docs[0]["Title"])
                          .collection("Proposels")
                          .get()
                          .then((snapshot) {
                        for (DocumentSnapshot ds in snapshot.docs) {
                          ds.reference.delete();
                        }
                      });
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .collection("Listed")
                          .doc(snapshot.data.docs[0]["Title"])
                          .update({
                            "ProposedPrice":snapshot.data.docs[0]["Price"],
                        "Sealed": true,
                        "Hired": true,
                        "Status": true,
                        "SealedBy": snapshot.data.docs[0]["Name"],
                        "SealedByEmail":
                            snapshot.data.docs[0]["Email"].toString(),
                      });
                      FirebaseFirestore.instance
                          .collection("Jobs")
                          .doc(snapshot.data.docs[0]["Title"])
                          .collection("Hired")
                          .doc(snapshot.data.docs[0]["Email"])
                          .set({
                        "FreelancerName": snapshot.data.docs[0]["Name"],
                        "FreelancerEmail": snapshot.data.docs[0]["Email"],
                        "FreelancerPrice": snapshot.data.docs[0]
                            ["ProposedPrice"],
                        "TimeofHiring": TimeOfDay.now().toString(),
                        "Date": DateTime.now(),
                      });
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(snapshot.data.docs[0]["Email"].toString())
                          .collection("Proposels")
                          .doc(snapshot.data.docs[0]["Title"])
                          .update({"Hired": true, "Status": true,"SealedBy": snapshot.data.docs[0]["Name"],
                        "SealedByEmail":
                            snapshot.data.docs[0]["Email"].toString()});
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .collection("HiredByYou")
                          .doc(snapshot.data.docs[0]["Title"])
                          .set({
                        "Title": snapshot.data.docs[0]["Title"],
                        "ClientEmail": FirebaseAuth.instance.currentUser!.email,
                        "FreelancerName": snapshot.data.docs[0]["Name"],
                        "FreelancerEmail": snapshot.data.docs[0]["Email"],
                        "FreelancerPrice": snapshot.data.docs[0]
                            ["ProposedPrice"],
                        "TimeofHiring": TimeOfDay.now().toString(),
                        "Date": DateTime.now(),
                      });
                      FirebaseFirestore.instance
                          .collection("Chats")
                          .doc(
                              "${snapshot.data.docs[0]["Title"]} ${snapshot.data.docs[0]["Name"]} ${snapshot.data.docs[0]["ListedBy"]}")
                          .update({
                        "Title": snapshot.data.docs[0]["Title"],
                        "Client": snapshot.data.docs[0]["ListedBy"],
                        "Applier": snapshot.data.docs[0]["Name"],
                        "ApplierEmail": snapshot.data.docs[0]["Email"],
                        "ClientEmail": FirebaseAuth.instance.currentUser!.email
                      });
                      final String format =
                          DateFormat('hh:mm a').format(DateTime.now());
                          final String dateformat = DateFormat('dd-MM-y').format(DateTime.now());
                          DateFormat('').format(DateTime.now());
                      FirebaseFirestore.instance
                          .collection("Chats")
                          .doc(
                              "${snapshot.data.docs[0]["Title"]} ${snapshot.data.docs[0]["Name"]} ${snapshot.data.docs[0]["ListedBy"]}")
                          .collection("Chat")
                          .doc(
                              "Hired${FirebaseAuth.instance.currentUser!.email}")
                          .set({
                        "Message": "You are hired for this project!",
                        "SendBy": FirebaseAuth.instance.currentUser!.email,
                        "Time": DateTime.now().microsecondsSinceEpoch,
                        "Time1": format,
                        "Date": dateformat
                      });
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>AdminDashboard()));
                    });
                  } else {
                    return Text("");
                  }
                },
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
