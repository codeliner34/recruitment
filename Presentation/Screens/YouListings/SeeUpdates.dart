import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

import '../AdminDashboard.dart';

class SeeUpdates extends StatefulWidget {
  final String freelancerEmail;
  final String title;
  final String proposedPrice;
  final String orignalPrice;
  final String freelancername;
  final String employeerName;
  final String listedDate;
  final String descrition;
  SeeUpdates(
      {Key? key,
      required this.freelancerEmail,
      required this.title,
      required this.proposedPrice,
      required this.orignalPrice,
      required this.freelancername,
      required this.employeerName,
      required this.listedDate,
      required this.descrition})
      : super(key: key);

  @override
  State<SeeUpdates> createState() => _SeeUpdatesState();
}

class _SeeUpdatesState extends State<SeeUpdates> {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    print(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "See Updates",
          style: TextStyle(
              color: lightColorScheme.primary, fontFamily: "Roboto-Bold"),
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(user.email)
              .collection("HiredByYou")
              .doc(widget.title)
              .collection("Updates")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 50),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data.docs[index]["Title"],
                                          style: TextStyle(
                                              color: lightColorScheme.primary,
                                              fontFamily: "Roboto-Bold",
                                              fontSize: 20)),
                                      Divider(),
                                      Text(
                                          snapshot.data.docs[index]
                                              ["Description"],
                                          style: TextStyle(
                                            color: lightColorScheme.primary,
                                            fontFamily: "Roboto-Regular",
                                          )),
                                      Spacer(),
                                      MaterialButton(
                                        color: lightColorScheme.primary,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Close",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Roboto-Bold",
                                                fontSize: 25)),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: lightColorScheme.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data.docs[index]["Title"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Roboto-Bold",
                                      fontSize: 20)),
                              Divider(),
                              Text(
                                snapshot.data.docs[index]["Description"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Roboto-Regular",
                                ),
                                maxLines: 8,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: lightColorScheme.primary,
        child: MaterialButton(
          color: lightColorScheme.primary,
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            final String dateformat =
                DateFormat('dd-MM-y').format(DateTime.now());
            final String format = DateFormat('hh:mm a').format(DateTime.now());
            FirebaseFirestore.instance
                .collection("Users")
                .doc(user.email)
                .collection("Listed")
                .doc(widget.title)
                .delete();
            FirebaseFirestore.instance
                .collection("Users")
                .doc(widget.freelancerEmail)
                .collection("Proposels")
                .doc(widget.title)
                .delete();
            FirebaseFirestore.instance
                .collection("Users")
                .doc(user.email)
                .collection("Completed")
                .doc(widget.title)
                .set({
              "Title": widget.title,
              "EmployeerEmail": user.email,
              "FreelancerEmail": widget.freelancerEmail,
              "FreelancerName": widget.freelancername,
              "ListedDate": widget.listedDate,
              "EmployeerName": widget.employeerName,
              "ProposedPrice": widget.proposedPrice,
              "Price": widget.orignalPrice,
              "Description": widget.descrition,
              "CompletionDate": dateformat,
              "PaymentStatus":"pending"
            });
            FirebaseFirestore.instance
                .collection("Users")
                .doc(widget.freelancerEmail)
                .collection("Completed")
                .doc(widget.title)
                .set({
              "Title": widget.title,
              "EmployeerEmail": user.email,
              "FreelancerEmail": widget.freelancerEmail,
              "FreelancerName": widget.freelancername,
              "ListedDate": widget.listedDate,
              "EmployeerName": widget.employeerName,
              "ProposedPrice": widget.proposedPrice,
              "Price": widget.orignalPrice,
              "Description": widget.descrition,
              "CompletionDate": dateformat,
              "PaymentStatus":"pending"
            });
            
            FirebaseFirestore.instance
                .collection("Users")
                .doc(widget.freelancerEmail)
                .collection("Notification")
                .doc("Chat ${widget.employeerName}")
                .set({
              "Message": "Project ${widget.title} has been completed ",
              "MarkAsRead": false,
              "Time": DateTime.now().microsecondsSinceEpoch,
              "Time1": format,
              "Type": "Completion",
              "Applier": widget.freelancername,
              "Client": widget.employeerName,
              "Title": widget.title,
              "ApplierEmail": widget.freelancerEmail,
              "ClientEmail": user.email,
            });
            FirebaseFirestore.instance
                .collection("Chats")
                .doc(
                    "${widget.title} ${widget.freelancername} ${widget.employeerName}")
                .collection("Chat")
                .doc("Completed ${user.email}")
                .set({
              "Message": "Project is completed...",
              "SendBy": user.email,
              "Time": DateTime.now().microsecondsSinceEpoch,
              "Time1": format,
              "Date": dateformat,
              
            });
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const AdminDashboard()));
          },
          child: Text(
            "Complete Project",
            style: TextStyle(
                fontFamily: "Roboto-Bold", color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }
}
