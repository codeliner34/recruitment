import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recuirmentapp/Presentation/Screens/ApplyScreen.dart';

import 'package:recuirmentapp/Themes/Themes.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final String budget;
  final String description;
  final String duration;
  final String experience;
  final String listedBy;
  final String country;
  final String time;
  final String date;
  final String link1;
  final String link2;
  final String link3;
  final String email;
  final String skill1;
  final String skill2;
  final String skill3;
  const DetailScreen({
    Key? key,
    required this.title,
    required this.budget,
    required this.description,
    required this.duration,
    required this.experience,
    required this.listedBy,
    required this.country,
    required this.time,
    required this.date,
    required this.link1,
    required this.link2,
    required this.link3,
    required this.email, required this.skill1, required this.skill2, required this.skill3,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  QuerySnapshot<Map<String, dynamic>>? userStream;
  final user = FirebaseAuth.instance.currentUser;
  bool isApplied = false;
  bool isYou = false;
  String? name;
  getUser() {
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: user!.email)
          .get()
          .then((value) {
        userStream = value;

        name = userStream!.docs[0]["name"].toString();
        print(name);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUser();
    // FirebaseFirestore.instance.collection("Users")
    FirebaseFirestore.instance
        .collection("Jobs")
        .doc(widget.title)
        .collection("Proposels")
        .doc(user!.email)
        .get()
        .then(
      (docSnapshot) {
        if (docSnapshot.exists) {
          setState(() {
            isApplied = true;
          });
        } else {
          setState(() {
            isApplied = false;
          });
        }
      },
    );
    if (widget.email == user!.email) {
      setState(() {
        isYou = true;
      });
    } else {
      setState(() {
        isYou = false;
      });
    }
    print(isYou);
    print(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.background,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: lightColorScheme.background,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.tags,
                          size: 20,
                          color: lightColorScheme.primary,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.currency_rupee_sharp,
                                  size: 18,
                                ),
                                Text(widget.budget,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20)),
                              ],
                            ),
                            const Text(
                              "Price",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          color: lightColorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.duration,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15)),
                            const Text(
                              "Duration",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 20,
                          color: lightColorScheme.primary,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.experience,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15)),
                            const Text(
                              "Experience",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 20,
                          color: lightColorScheme.primary,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(widget.duration,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15))
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 0,
              ),
              Text("Description:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: lightColorScheme.primary)),
              const Text(
                "(You can select and copy links from description)",
                style: TextStyle(color: Colors.black45, fontSize: 11),
              ),
              const SizedBox(
                height: 10,
              ),
              SelectableText(
                widget.description,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Links: ",
                    style: TextStyle(
                        color: lightColorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              GestureDetector(
                        onTap: () {
                          launch(widget.link1);
                        }, child: Text(widget.link1)),
               GestureDetector(
                        onTap: () {
                          launch(widget.link2);
                        }, child: Text(widget.link2)),
               GestureDetector(
                        onTap: () {
                          launch(widget.link3);
                        }, child: Text(widget.link3)),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Text(
                    "Required Skills: ",
                    style: TextStyle(
                        color: lightColorScheme.primary,
                        fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                    alignment: Alignment.center,
                    height: 45,
                    // width: 100,
                    decoration: BoxDecoration(
                      color: lightColorScheme.primary,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.skill1,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    alignment: Alignment.center,
                    height: 45,
                    // width: 100,
                    decoration: BoxDecoration(
                      color: lightColorScheme.primary,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.skill2,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    alignment: Alignment.center,
                    height: 45,
                    // width: 100,
                    decoration: BoxDecoration(
                      color: lightColorScheme.primary,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.skill3,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Divider(),
              Text(
                "About Client:",
                style: TextStyle(
                    color: lightColorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("Name: ${widget.listedBy}"),
              Text("Country: ${widget.country}"),
              Text("Date: ${widget.date}(${widget.time.substring(10, 15)})")
            ],
          ),
        ),
      ),
      bottomNavigationBar: isYou
          ? Container(
            alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(color: lightColorScheme.primary),
              child: Column(
                children: [
                  const Text(
                    "You Can't Apply",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text("This Job is posted by you.",style: TextStyle(color: Colors.white54,fontSize: 8),)
                ],
              ),
            )
          : BottomAppBar(
              child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(color: lightColorScheme.primary),
                  child: isApplied
                      ? Container(
                          child: const Text(
                            "Applied!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : MaterialButton(
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ApplyScreen(
                                  ListedEmail: widget.email,
                                      time: widget.time,
                                      date: widget.date,
                                      title: widget.title,
                                      description: widget.description,
                                      budget: widget.budget,
                                      experience: widget.experience,
                                      duration: widget.duration,
                                      country: widget.country,
                                      listedBy: widget.listedBy,
                                    )));
                          },
                          child: const Text(
                            "Apply",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
            ),
    );
  }
}
