import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recuirmentapp/Functions/UserChatFunctions.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class UserChatScreen extends StatefulWidget {
  final String title;
  final String applieremail;
  final String clientemail;
  final String ApplierName;
  final String Clientname;
  UserChatScreen({Key? key, required this.title, required this.applieremail, required this.clientemail, required this.ApplierName, required this.Clientname}) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final user = FirebaseAuth.instance.currentUser;
  
  final key = GlobalKey<FormState>(); 
  TextEditingController messageController = TextEditingController();
  @override
 
  final Key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.Clientname),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
         children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Chats")
                  .doc("${widget.title} ${widget.ApplierName} ${widget.Clientname}")
                  .collection("Chat").orderBy("Time")
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        subtitle: Text("${snapshot.data.docs[index]["Time1"]} / ${snapshot.data.docs[index]["Date"]}".toString(),style: TextStyle(fontSize: 10),),
                        leading: CircleAvatar(
                          child: snapshot.data.docs[index]["SendBy"] == FirebaseAuth.instance.currentUser!.email ? Text("You") : Text(snapshot.data.docs[index]["SendBy"].toString().substring(0,1).toUpperCase()),
                        ),
                        title:
                            SelectableText(snapshot.data.docs[index]["Message"].toString()),
                      );
                    },
                  );
                } else {
                  return Text("Nothing");
                }
              },
            ),
                  ),
          ),
        Container(
            decoration: BoxDecoration(
              color: lightColorScheme.primary,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
            ),
            height: 55,
            child: Form(
              key: key,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      width: 300,
                      child: TextFormField(
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Can't be Empty";
                          }
                        },
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        controller: messageController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          hintText: "Type Message Here...",
                        ),
                      ),
                    ),
                    
                  ),
                  GestureDetector(
                    onTap: () {
                      final String Dateformat =
                    DateFormat('dd-MM-y').format(DateTime.now());
                      final String format = DateFormat('hh:mm a').format(DateTime.now());
                      if(key.currentState!.validate()){
                        sendMessage(Dateformat, widget.title, widget.ApplierName, widget.Clientname, widget.clientemail, widget.applieremail, messageController.text, user!.email.toString(), format).then((value) {
                          setState(() {
                            messageController.text = "";
                          });
                        });
                        setUserPushTrue(widget.title, widget.ApplierName, widget.Clientname);
                        setClientPushFalse(widget.title, widget.ApplierName, widget.Clientname);
                        // FirebaseFirestore.instance.collection("Chats").doc("${widget.title} ${widget.ApplierName} ${widget.Clientname}").collection("Chat").doc("${messageController.text}${user!.email}").set({
                        //   "Message": messageController.text,
                        //   "SendBy": user!.email,
                        //   "Time": DateTime.now().microsecondsSinceEpoch,
                        //   "Time1":format
                        // }).then((value) {
                        //   setState(() {
                        //     messageController.text = "";
                        //   });
                        // });
                      }
                      // if(key.currentState!.validate()){
                      //   FirebaseFirestore.instance.collection("Users").doc(user!.email).collection("Chat").doc(widget.title).collection("Chats").doc(messageController.text).set({
                      //     "Message": messageController.text,
                      //     "SendBy": user!.email,
                      //     "Time": DateTime.now().microsecondsSinceEpoch
                      //   }).then((value) {
                      //     setState(() {
                      //       messageController.text = "";
                      //     });
                      //   });
                      // }
                      // if(key.currentState!.validate()){
                      //   FirebaseFirestore.instance.collection("Users").doc().collection("Chat").doc(widget.title).collection("Chats").doc(messageController.text).set({
                      //     "Message": messageController.text,
                      //     "SendBy": user!.email,
                      //     "Time": DateTime.now().microsecondsSinceEpoch
                      //   }).then((value) {
                      //     setState(() {
                      //       messageController.text = "";
                      //     });
                      //   });
                      // }
                    },
                    child: Icon(Icons.send,color: Colors.white,)),
                  SizedBox(width: 10,)
                ],
              ),
            ),
          )
         ], 
      ),

    );
  }
}
