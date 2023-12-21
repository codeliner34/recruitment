// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recuirmentapp/Functions/UserChatFunctions.dart';
import 'package:recuirmentapp/Presentation/Screens/UserChatScreen.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class ChatList extends StatefulWidget {

  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    
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
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Your Chats",style: TextStyle(color: lightColorScheme.primary,fontFamily: "Roboto-Bold"),),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator(),) :
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Chats").where("ApplierEmail",isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
         if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                subtitle: Text(snapshot.data.docs[index]["Client"]),
                onTap: () {
                  FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.email).collection("Notification").doc("Chat ${snapshot.data.docs[index]["Client"]}").update({
                    "MarkAsRead":true
                  });
                  setClientPushFalse(snapshot.data.docs[index]["Title"], snapshot.data.docs[index]["Applier"], snapshot.data.docs[index]["Client"]);
                  Get.to(UserChatScreen(title: snapshot.data.docs[index]["Title"],
                        applieremail: snapshot.data.docs[index]
                            ["ApplierEmail"],
                        clientemail: snapshot.data.docs[index]["ClientEmail"],
                        ApplierName: snapshot.data.docs[index]["Applier"],
                        Clientname: snapshot.data.docs[index]["Client"],),transition: Transition.downToUp,duration: const Duration(milliseconds: 600));
                },
                title: Text("${snapshot.data.docs[index]["Title"]}",
                    style: snapshot.data.docs[index]["ClientPush"] ? const TextStyle(fontFamily: "Roboto-Black") :const TextStyle(fontFamily: "Roboto-Regular"),
                ),);
            },
          );
         }
         else{
          return const Text("");
         }
        },
      ),
    );
  }
}