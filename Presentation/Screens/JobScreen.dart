import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:recuirmentapp/Presentation/Screens/ChatsList.dart';
import 'package:recuirmentapp/Presentation/Screens/ClientChatList.dart';
import 'package:recuirmentapp/Presentation/Screens/DetailScreen.dart';
import 'package:recuirmentapp/Presentation/Screens/ListProject.dart';
import 'package:recuirmentapp/Presentation/Screens/Notifications.dart';
import 'package:recuirmentapp/Presentation/Screens/ProposelScreen.dart';
import 'package:recuirmentapp/Presentation/Screens/SearchjobScreen.dart';
import 'package:recuirmentapp/Providers/AuthProvider.dart';
import 'package:recuirmentapp/Themes/Themes.dart';
import 'package:recuirmentapp/main.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  QuerySnapshot<Map<String, dynamic>>? userStream;
  String? name;
  bool isLoading = true;
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
    getUser();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Jobs",
          style: TextStyle(
              color: lightColorScheme.primary, fontFamily: "Roboto-Bold"),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        actions: [
          // IconButton(
          //     onPressed: () {
          //         setState(() {
          //           isClient = true;
          //           print(isClient);
          //           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const Main()));
          //         });
          //     },
          //     icon: const Icon(Icons.change_circle)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
            child: GestureDetector(
              onTap: () {
                Get.to(Notifications(),transition: Transition.rightToLeftWithFade,duration: const Duration(milliseconds: 500));
              },
              child: Container(
                width: 50,
                child: Row(
                  children: [
                    const Icon(Icons.notifications,size: 20,color: Colors.red,),
                     StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(user!.email)
                    .collection("Notification")
                    .where("MarkAsRead", isEqualTo: false)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return  Text(snapshot.data.docs.length.toString(),style: const TextStyle(fontFamily: "Roboto-Bold",color: Colors.red),);
                  } else {
                    return const Text('0');
                  }
                },
              ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()) :
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: ()=>Get.to(JobSearchScreen(),transition: Transition.rightToLeft),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 10,),
                    const Text("Search Jobs...")
                  ]),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Jobs")
                    .where("Sealed", isEqualTo: false)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 5,
                      ),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return JobTile(
                          user: user, 
                          budget: snapshot.data.docs[index]["Price"],
                          country: snapshot.data.docs[index]["ClientCountry"], 
                          date: snapshot.data.docs[index]["ListedDate"],
                          time: snapshot.data.docs[index]["ListedTime"],
                          title: snapshot.data.docs[index]["Title"],
                          skill1: snapshot.data.docs[index]["Skill1"],
                          skill2: snapshot.data.docs[index]["Skill2"],
                          skill3: snapshot.data.docs[index]["Skill3"],
                          link1: snapshot.data.docs[index]["Link 1"],
                          link2: snapshot.data.docs[index]["Link 2"],
                          link3: snapshot.data.docs[index]["Link 3"],
                          listedBy: snapshot.data.docs[index]["ListedBy"],
                          email: snapshot.data.docs[index]["Email"],
                          experience: snapshot.data.docs[index]["Experience"],
                          description: snapshot.data.docs[index]["Description"],
                          duration: snapshot.data.docs[index]["Duration"],
                        );
                      },
                    );
                  } 
                  
                  
                  else {
                    return const Text("");
                  }
                },
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ListProjectScreen())),
      // ),
    );
  }
}

class JobTile extends StatelessWidget {
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
  const JobTile({
    super.key,
    required this.user, required this.title, required this.budget, required this.description, required this.duration, required this.experience, required this.listedBy, required this.country, required this.time, required this.date, required this.link1, required this.link2, required this.link3, required this.email, required this.skill1, required this.skill2, required this.skill3,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
          DetailScreen(
            email: email,
            link1: link1,
            link2: link2,
            link3: link3,
            date: date,
            time: time,
            country: country,
            title: title,
            budget: budget,
            description: description,
            duration: duration,
            experience: experience,
            listedBy: listedBy,
            skill1: skill1,
            skill2: skill2,
            skill3: skill3,
          ),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 600)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 0, horizontal: 8),
        child: Container(
          // height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // border: Border.all(color: Colors.white54),
              color: lightColorScheme.primary),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user!.email)
                              .collection("Saved")
                              .doc(title)
                              .set({
                            "Email": email,
                            "Link 1":link1,
                            "Link 2": link2,
                            "Link 3": link3,
                            "ListedDate": date,
                            "ListedTime": time,
                            "ClientCountry":country,
                            "Title":  title,
                            "Price": budget,
                            "Description": description,
                            "Duration": duration,
                            "Experience":experience,
                            "ListedBy": listedBy,
                            "Skill1": skill1,
                            "Skill2": skill2,
                            "Skill3": skill3,
                          }).then((value) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content: Text(
                                        "Project Saved...")));
                          });
                        },
                        child: const Icon(
                          Icons.bookmark_add_outlined,
                          color: Colors.white,
                        ))
                  ],
                ),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Roboto-Bold",
                      fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(
                  color: Colors.white24,
                ),
                // SizedBox(height: 10,),
                Text(
                    "Rs: ${budget}",
                    style: const TextStyle(color: Colors.white)),
                Text(
                    "Duration: ${duration}",
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    height: 80,
                    width: 400,
                    child: Expanded(
                        child: Text(
                      description,
                      style:
                          const TextStyle(color: Colors.white60),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
