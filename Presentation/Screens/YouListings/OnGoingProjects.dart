import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pay/pay.dart';
import 'package:recuirmentapp/Presentation/Screens/ClientChatScreen.dart';
import 'package:recuirmentapp/Presentation/Screens/YouListings/PaymentScreen.dart';

import '../../../Themes/Themes.dart';
import '../GenerateInvoice.dart';
import 'SeeUpdates.dart';

class OnGoingProjects extends StatefulWidget {
  const OnGoingProjects({Key? key}) : super(key: key);

  @override
  State<OnGoingProjects> createState() => _OnGoingProjectsState();
}

class _OnGoingProjectsState extends State<OnGoingProjects>
    with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  void payPressed() {}
  void onGooglePayResult(res) {}
  List<PaymentItem> paymentItems = [];
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Ongoing Projects",
            style: TextStyle(
                color: lightColorScheme.primary, fontFamily: "Roboto-Bold")),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.normal),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.black,
                isScrollable: true,
                indicatorColor: lightColorScheme.primary,
                labelColor: lightColorScheme.primary,
                controller: tabController,
                tabs: const [
                  Tab(
                    text: "Ongoing Projects",
                  ),
                  Tab(
                    text: "Completed Projects",
                  ),
                ]),
            Expanded(
              child: TabBarView(controller: tabController, children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(user!.email)
                      .collection("Listed")
                      .where("Sealed", isEqualTo: true)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                  SeeUpdates(
                                    listedDate: snapshot.data.docs[index]
                                        ["ListedDate"],
                                    freelancername: snapshot.data.docs[index]
                                        ["SealedBy"],
                                    employeerName: snapshot.data.docs[index]
                                        ["ListedBy"],
                                    proposedPrice: snapshot.data.docs[index]
                                        ["ProposedPrice"],
                                    orignalPrice: snapshot.data.docs[index]
                                        ["Price"],
                                    freelancerEmail: snapshot.data.docs[index]
                                        ["SealedByEmail"],
                                    title: snapshot.data.docs[index]["Title"],
                                    descrition: snapshot.data.docs[index]
                                        ["Description"],
                                  ),
                                  transition: Transition.downToUp,
                                  duration: const Duration(milliseconds: 500));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Container(
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
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Divider(
                                        color: Colors.white,
                                      ),
                                      // SizedBox(height: 10,),
                                      Text(
                                          "Rs: ${snapshot.data.docs[index]["Price"]}",
                                          style: const TextStyle(
                                              color: Colors.white54)),
                                      Text(
                                          "Duration: ${snapshot.data.docs[index]["Duration"]}",
                                          style: const TextStyle(
                                              color: Colors.white54)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          height: 80,
                                          width: 400,
                                          child: Expanded(
                                              child: Text(
                                            snapshot.data.docs[index]
                                                ["Description"],
                                            style: const TextStyle(
                                                color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4,
                                          ))),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (_) => ClientChatScreen(
                                                  title: snapshot.data
                                                      .docs[index]["Title"],
                                                  applieremail:
                                                      snapshot.data.docs[index]
                                                          ["SealedByEmail"],
                                                  clientemail: snapshot.data
                                                      .docs[index]["Email"],
                                                  ApplierName: snapshot.data
                                                      .docs[index]["SealedBy"],
                                                  Clientname:
                                                      snapshot.data.docs[index]
                                                          ["ListedBy"])));
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.amber),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.chat,
                                                color: lightColorScheme.primary,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  "Sealed By ${snapshot.data.docs[index]["SealedBy"]}",
                                                  style: TextStyle(
                                                      color: lightColorScheme
                                                          .primary,
                                                      fontSize: 20,
                                                      fontFamily:
                                                          "Roboto-Bold")),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text("");
                    }
                  },
                ),
                Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user!.email)
                        .collection("Completed")
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          itemCount: snapshot.data.docs.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: lightColorScheme.primary,
                                ),
                                // height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        snapshot.data.docs[index]["Title"],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: "Roboto-Bold"),
                                      ),
                                      const Divider(
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Price: Rs.${snapshot.data.docs[index]["ProposedPrice"]}",
                                        style: const TextStyle(
                                          color: Colors.white54,
                                        ),
                                      ),
                                      Text(
                                        "Listed Date: ${snapshot.data.docs[index]["ListedDate"]}",
                                        style: const TextStyle(
                                          color: Colors.white54,
                                        ),
                                      ),
                                      Text(
                                        "Completion Date: ${snapshot.data.docs[index]["CompletionDate"]}",
                                        style: const TextStyle(
                                          color: Colors.white54,
                                        ),
                                      ),
                                      Text(
                                        "Freelancer Name: ${snapshot.data.docs[index]["FreelancerName"]}",
                                        style: const TextStyle(
                                          color: Colors.white54,
                                        ),
                                      ),
                                      Text(
                                        "Freelancer Email: ${snapshot.data.docs[index]["FreelancerEmail"]}",
                                        style: const TextStyle(
                                          color: Colors.white54,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      MaterialButton(
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        color: Colors.white,
                                        onPressed: () {
                                          Get.to(
                                              GenerateInvoice(
                                                  employeerName:
                                                      snapshot.data.docs[index]
                                                          ["EmployeerName"],
                                                  employeerEmail:
                                                      snapshot.data.docs[index]
                                                          ["EmployeerEmail"],
                                                  freelancername:
                                                      snapshot.data.docs[index]
                                                          ["FreelancerName"],
                                                  CompletionDate:
                                                      snapshot.data.docs[index]
                                                          ["CompletionDate"],
                                                  listedDate:
                                                      snapshot.data.docs[index]
                                                          ["ListedDate"],
                                                  Price: snapshot.data.docs[index]
                                                      ["ProposedPrice"],
                                                  title: snapshot.data
                                                      .docs[index]["Title"]),
                                              transition: Transition.downToUp);
                                        },
                                        child: const Text(
                                          "See Invoice",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      snapshot.data.docs[index]
                                                  ["PaymentStatus"] ==
                                              "pending"
                                          ? MaterialButton(
                                              height: 50,
                                              color: Colors.black,
                                              minWidth: double.infinity,
                                              child: const Text(
                                                "Complete Payment",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          PaymentScreen(
                                                            employeerEmail: snapshot.data.docs[index]["EmployeerEmail"],
                                                            title: snapshot.data
                                                                    .docs[index]
                                                                ["Title"],
                                                            employeerName: snapshot.data.docs[index]["EmployeerName"],
                                                            freelancerEmail: snapshot.data.docs[index]["FreelancerEmail"],
                                                            freelancername: snapshot.data.docs[index]["FreelancerName"],
                                                            completionDate: snapshot.data.docs[index]["CompletionDate"],
                                                            proposedPrice: snapshot.data.docs[index]["ProposedPrice"],
                                                          )),
                                                );
                                              })
                                          : Container(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
