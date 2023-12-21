import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:recuirmentapp/Presentation/Screens/GenerateInvoice.dart';
import 'package:recuirmentapp/Presentation/Screens/PostUpdate.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class ProposalScreen extends StatefulWidget {
  const ProposalScreen({Key? key}) : super(key: key);

  @override
  State<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen>
    with TickerProviderStateMixin {
      bool isLoading = true;
      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value){
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    PageController pageController = PageController();
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Your Proposals",
          style: TextStyle(
              fontFamily: "Roboto-Bold", color: lightColorScheme.primary),
        ),
      ),
      body: Column(
        children: [
          TabBar(
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.black,
              isScrollable: true,
              indicatorColor: lightColorScheme.primary,
              labelColor: lightColorScheme.primary,
              controller: tabController,
              tabs: [
                Tab(
                  text: "Pending Proposals",
                ),
                Tab(
                  text: "Ongoing Projects",
                ),
                Tab(
                  text: "Completed Projects",
                ),
              ]),
          Expanded(
            child: Container(
              child: TabBarView(
                controller: tabController,
                children: [
                  Container(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .doc(FirebaseAuth.instance.currentUser!.email
                              .toString())
                          .collection("Proposels")
                          .where("Status", isEqualTo: false)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 5,
                            ),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: lightColorScheme.primary),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data.docs[index]["Title"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // SizedBox(height: 10,),
                                        Text(
                                            "Rs: ${snapshot.data.docs[index]["Price"]}",
                                            style: TextStyle(
                                                color: Colors.white54)),
                                        Text(
                                            "Duration: ${snapshot.data.docs[index]["Duration"]}",
                                            style: TextStyle(
                                                color: Colors.white54)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            height: 80,
                                            width: 400,
                                            child: Expanded(
                                                child: Text(
                                              snapshot.data.docs[index]
                                                  ["CoverLetter"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                            )))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(child: Text("No Pending Projects Yet..."));
                        }
                      },
                    ),
                  ),
                  Container(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .doc(FirebaseAuth.instance.currentUser!.email
                              .toString())
                          .collection("Proposels")
                          .where("Hired", isEqualTo: true)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: Container(
                                  // height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: lightColorScheme.primary),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data.docs[index]["Title"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // SizedBox(height: 10,),
                                        Text(
                                            "Rs: ${snapshot.data.docs[index]["ProposedPrice"]}",
                                            style: TextStyle(
                                                color: Colors.white54)),
                                        Text(
                                            "Duration: ${snapshot.data.docs[index]["Duration"]}",
                                            style: TextStyle(
                                                color: Colors.white54)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            height: 80,
                                            width: 400,
                                            child: Expanded(
                                                child: Text(
                                              snapshot.data.docs[index]
                                                  ["CoverLetter"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                            ))),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: MaterialButton(
                                            onPressed: () {
                                              Get.to(
                                                  PostUpdate(
                                                    employeerEmail: snapshot
                                                            .data.docs[index]
                                                        ["ListedEmail"],
                                                    title: snapshot.data
                                                        .docs[index]["Title"],
                                                  ),
                                                  transition:
                                                      Transition.downToUp,
                                                  duration: Duration(
                                                      milliseconds: 500));
                                            },
                                            color: Colors.amber,
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            child: Text(
                                              "Post Update",
                                              style: TextStyle(
                                                  color:
                                                      lightColorScheme.primary,
                                                  fontFamily: "Roboto-Black",
                                                  fontSize: 20),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Text("No Ongoing Projects Yet...");
                        }
                      },
                    ),
                  ),
                  Container(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .doc(FirebaseAuth.instance.currentUser!.email
                              .toString())
                          .collection("Completed")
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: Container(
                                  // height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: lightColorScheme.primary),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data.docs[index]["Title"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // SizedBox(height: 10,),
                                        Text(
                                            "Date : ${snapshot.data.docs[index]["ListedDate"]}",
                                            style: TextStyle(
                                                color: Colors.white54)),
                                        Text(
                                            "ProposedPrice : Rs.${snapshot.data.docs[index]["ProposedPrice"]}",
                                            style: TextStyle(
                                                color: Colors.white54)),
                                        Text(
                                            "Name : ${snapshot.data.docs[index]["EmployeerName"]}",
                                            style: TextStyle(
                                                color: Colors.white54)),
                                        Text(
                                            "Payment Status : ${snapshot.data.docs[index]["PaymentStatus"]}",
                                            style: TextStyle(
                                                color: Colors.white54)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            height: 80,
                                            width: 400,
                                            child: Expanded(
                                                child: Text(
                                              snapshot.data.docs[index]
                                                  ["Description"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                            ))),
                                        SizedBox(height: 10,),
                                        MaterialButton(
                                          minWidth: MediaQuery.of(context).size.width,
                                          height: 50,
                                          color: Colors.white,
                                          onPressed: (){
                                          Get.to(
                                            GenerateInvoice(
                                              employeerName: snapshot.data.docs[index]["EmployeerName"], employeerEmail: snapshot.data.docs[index]["EmployeerEmail"], freelancername:snapshot.data.docs[index]["FreelancerName"], CompletionDate: snapshot.data.docs[index]["CompletionDate"], listedDate: snapshot.data.docs[index]["ListedDate"], Price: snapshot.data.docs[index]["ProposedPrice"], title: snapshot.data.docs[index]["Title"])
                                              ,transition: Transition.downToUp
                                          );
                                        },
                                        child: Text("Generate Invoice",style: TextStyle(fontSize: 20),),)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Text("");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
