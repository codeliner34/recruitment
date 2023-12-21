import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recuirmentapp/Functions/UserChatFunctions.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class ChatScreen extends StatefulWidget {
  final String applieremail;
  final String clientemail;
  final String title;
  const ChatScreen(
      {Key? key,
      required this.applieremail,
      required this.clientemail,
      required this.title})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isLoading = true;
  final user = FirebaseAuth.instance.currentUser;
  // ignore: non_constant_identifier_names
  QuerySnapshot<Map<String, dynamic>>? ClientStream;
  // ignore: non_constant_identifier_names
  QuerySnapshot<Map<String, dynamic>>? ApplierStream;
  // ignore: non_constant_identifier_names
  String? Clientname;
  // ignore: non_constant_identifier_names
  String? ApplierName;
  final key = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  getClient() {
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: widget.clientemail)
          .get()
          .then((value) {
        ClientStream = value;

        Clientname = ClientStream!.docs[0]["name"].toString();
      });
    });
  }

  getApplier() {
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: widget.applieremail)
          .get()
          .then((value) {
        ApplierStream = value;

        ApplierName = ApplierStream!.docs[0]["name"].toString();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApplier();
    getClient();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: widget.clientemail == user!.email
              ? Text(ApplierName.toString())
              : Text(Clientname.toString()),
        ),
        body: isLoading ? Center(child: const CircularProgressIndicator()) : SingleChildScrollView(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height - 80,
                    // color: Colors.amber,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Chats")
                          .doc("${widget.title} $ApplierName $Clientname")
                          .collection("Chat")
                          .orderBy("Time")
                          .snapshots(),
                      builder:
                          (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                subtitle: Text(
                                    snapshot.data.docs[index]["Time1"]
                                        .toString(),
                                    style: const TextStyle(fontSize: 10)),
                                leading: CircleAvatar(
                                  child: user!.email ==
                                          snapshot.data.docs[index]["SendBy"]
                                      ? const Text("You")
                                      : const Text("No"),
                                ),
                                title: Text(snapshot
                                    .data.docs[index]["Message"]
                                    .toString()),
                              );
                            },
                          );
                        } else {
                          return const Text("Nothing");
                        }
                      },
                    )),
              ),
              Container(
                decoration: BoxDecoration(
                    color: lightColorScheme.primary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                height: 55,
                child: Form(
                  key: key,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            // ignore: body_might_complete_normally_nullable
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Can't be Empty";
                              }
                            },
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            controller: messageController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type Message Here...",
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            if (key.currentState!.validate()) {
                              final String dateFormat =
                                  DateFormat('dd-MM-y').format(DateTime.now());
                              final String format =
                                  DateFormat('hh:mm a').format(DateTime.now());
                                  FirebaseFirestore.instance.collection("Users").doc(widget.applieremail).collection("Notification").doc("Chat $Clientname").set({
                            "Message":"You have recived messeged from $Clientname",
                            "MarkAsRead":false,
                            "Time":DateTime.now().microsecondsSinceEpoch,
                            "Time1":format,
                            "Type":"Chat",
                            "Applier":ApplierName,
                            "Client":Clientname,
                            "Title":widget.title,
                            "ApplierEmail":widget.applieremail,
                            "ClientEmail":widget.clientemail
                          });
                              FirebaseFirestore.instance
                                  .collection("Chats")
                                  .doc(
                                      "${widget.title} $ApplierName $Clientname")
                                  .set({
                                "ClientEmail": widget.clientemail,
                                "ApplierEmail": widget.applieremail,
                                "Applier": ApplierName,
                                "Client": Clientname,
                                "Time1": format,
                                "Title": widget.title,
                                "Completed":false
                              }).then((value) {
                                FirebaseFirestore.instance
                                    .collection("Chats")
                                    .doc(
                                        "${widget.title} $ApplierName $Clientname")
                                    .collection("Chat")
                                    .doc(
                                        "${messageController.text}${user!.email}")
                                    .set({
                                  "Message": messageController.text,
                                  "SendBy": user!.email,
                                  "Time": DateTime.now().microsecondsSinceEpoch,
                                  "Time1": format,
                                  "Date":dateFormat
                                }).then((value) {
                                  setUserPushFalse(
                                      widget.title,
                                      ApplierName.toString(),
                                      Clientname.toString());
                                  setClientPushTrue(
                                      widget.title,
                                      ApplierName.toString(),
                                      Clientname.toString());

                                  setState(() {
                                    messageController.text = "";
                                  });
                                });
                              });
                            }
                          },
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
