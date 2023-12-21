
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recuirmentapp/Presentation/Screens/UserChatScreen.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
   final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Notifications",style: TextStyle(color: lightColorScheme.primary,fontFamily: "Roboto-Bold"),),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(user!.email)
                    .collection("Notification").where("MarkAsRead",isEqualTo: false)
                    .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: (){
                        if(snapshot.data.docs[index]["Type"]=="Chat"){
                          FirebaseFirestore.instance.collection("Users").doc(user!.email).collection("Notification").doc("Chat ${snapshot.data.docs[index]["Client"]}").update({
                            "MarkAsRead":true
                          });
                          Get.to(
                            UserChatScreen(title: snapshot.data.docs[index]["Title"], applieremail: snapshot.data.docs[index]["ApplierEmail"], clientemail: snapshot.data.docs[index]["ClientEmail"], ApplierName: snapshot.data.docs[index]["Applier"], Clientname: snapshot.data.docs[index]["Client"]),
                            duration: Duration(milliseconds: 500),transition: Transition.rightToLeft
                            );
                        }
                      },
                      trailing:  GestureDetector(
                        onTap: () {
                          FirebaseFirestore.instance.collection("Users").doc(user!.email).collection("Notification").doc("Chat ${snapshot.data.docs[index]["Client"]}").update({
                            "MarkAsRead":true
                          });
                        },
                        child: Icon(Icons.done)),
                      subtitle: Text(snapshot.data.docs[index]["Time1"]),
                      title: Text(snapshot.data.docs[index]["Message"]),
                    );
                  },
                );
              }
              else{
                return Text("");
              }
          },
        ),
      ),
    );
  }
}