import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class PostUpdate extends StatefulWidget {
  final String employeerEmail;
  final String title;
  PostUpdate({Key? key, required this.employeerEmail, required this.title})
      : super(key: key);

  @override
  State<PostUpdate> createState() => _PostUpdateState();
}

class _PostUpdateState extends State<PostUpdate> {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Post Update",
          style: TextStyle(
              color: lightColorScheme.primary, fontFamily: "Roboto-Bold"),
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(user.email)
              .collection("Proposels")
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
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      FirebaseFirestore.instance.collection("Users").doc(widget.employeerEmail).collection("HiredByYou").doc(widget.title).collection("Updates").doc(snapshot.data.docs[index]["Title"]).delete();
                                      FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Proposels").doc(widget.title).collection("Updates").doc(snapshot.data.docs[index]["Title"]).delete();
                                    },
                                    child: Icon(Icons.delete,color: Colors.white,)),
                                ],
                              ),
                              SizedBox(height: 10,),
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
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Column(
                    children: [
                      Container(
                        width: 500,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 25),
                          child: Column(
                            children: [
                              Text("Post an update",
                                  style: TextStyle(
                                      color: lightColorScheme.primary,
                                      fontFamily: "Roboto-Bold",
                                      fontSize: 25)),
                              SizedBox(
                                height: 25,
                              ),
                              TextFormField(
                                controller: titleController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Enter Title",
                                    label: Text("Title")),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: descriptionController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Enter Description",
                                    label: Text("Description")),
                                maxLines: 15,
                                minLines: 1,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              MaterialButton(
                                color: lightColorScheme.primary,
                                minWidth: MediaQuery.of(context).size.width,
                                height: 50,
                                onPressed: () {
                                  final firestore = FirebaseFirestore.instance;
                                  final String dateformat =
                                      DateFormat('dd-MM-y')
                                          .format(DateTime.now());
                                  final String format = DateFormat('hh:mm a')
                                      .format(DateTime.now());
                                  firestore
                                      .collection("Users")
                                      .doc(widget.employeerEmail)
                                      .collection("HiredByYou")
                                      .doc(widget.title)
                                      .collection("Updates")
                                      .doc(titleController.text)
                                      .set({
                                    "Title": titleController.text,
                                    "Description": descriptionController.text,
                                    "Time": format,
                                    "Date": dateformat
                                  });
                                  firestore
                                      .collection("Users")
                                      .doc(user.email)
                                      .collection("Proposels")
                                      .doc(widget.title)
                                      .collection("Updates")
                                      .doc(titleController.text)
                                      .set({
                                    "Title": titleController.text,
                                    "Description": descriptionController.text,
                                    "Time": format,
                                    "Date": dateformat
                                  });
                                  setState(() {
                                    titleController.text = "";
                                    descriptionController.text = "";
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text("Post",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Roboto-Bold",
                                        fontSize: 25)),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                });
          },
          child: Text(
            "Post an update",
            style: TextStyle(
                fontFamily: "Roboto-Bold", color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }
}
