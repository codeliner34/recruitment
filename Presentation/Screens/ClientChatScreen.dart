import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:recuirmentapp/Presentation/Screens/YouListings/FreelancerDetails.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class ClientChatScreen extends StatefulWidget {
  final String title;
   final String applieremail;
  final String clientemail;
  final String ApplierName;
  final String Clientname;
  ClientChatScreen({Key? key, required this.title, required this.applieremail, required this.clientemail, required this.ApplierName, required this.Clientname}) : super(key: key);

  @override
  State<ClientChatScreen> createState() => _ClientChatScreenState();
}

class _ClientChatScreenState extends State<ClientChatScreen> {
  final user = FirebaseAuth.instance.currentUser;
  // QuerySnapshot<Map<String, dynamic>>? ClientStream;
  // QuerySnapshot<Map<String, dynamic>>? ApplierStream;
  // String? Clientname;
  // String? ApplierName;
  final key = GlobalKey<FormState>(); 
  TextEditingController messageController = TextEditingController();
  // getClient() {
  //   setState(() {
  //     FirebaseFirestore.instance
  //         .collection("Users")
  //         .where("email", isEqualTo: widget.clientemail)
  //         .get()
  //         .then((value) {
  //      ClientStream = value;

  //       Clientname = ClientStream!.docs[0]["name"].toString();
  //       print(Clientname);
  //     });
  //   });
  // }
  // getApplier() {
  //   setState(() {
  //     FirebaseFirestore.instance
  //         .collection("Users")
  //         .where("email", isEqualTo: widget.applieremail)
  //         .get()
  //         .then((value) {
  //      ApplierStream = value;

  //       ApplierName = ApplierStream!.docs[0]["name"].toString();
  //       print(ApplierName);
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getApplier();
  //   getClient();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.ApplierName.toString()),
        centerTitle: true,
        
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
                        subtitle: Text("${snapshot.data.docs[index]["Time1"]} / ${snapshot.data.docs[index]["Date"]}",style: TextStyle(fontSize: 10)),
                        leading: CircleAvatar(
                          child: snapshot.data.docs[index]["SendBy"] == FirebaseAuth.instance.currentUser!.email ? Text("You") : Text(snapshot.data.docs[index]["SendBy"].toString().substring(0,1).toUpperCase()),
                        ),
                        title:
                            Text(snapshot.data.docs[index]["Message"].toString()),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 250,
                        child: TextFormField(
                          validator: (value) {
                          if(value!.isEmpty){
                            return "Can't be Empty";
                          }
                        },
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          controller: messageController,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            hintText: "Type Message Here..."
                          ),
                        ),
                      ),
                      
                    
                    GestureDetector(
                      onTap: () {
                        if(key.currentState!.validate()){
                          final String dateformat = DateFormat('dd-MM-y').format(DateTime.now());
                           final String format = DateFormat('hh:mm a').format(DateTime.now());
                          FirebaseFirestore.instance.collection("Chats").doc("${widget.title} ${widget.ApplierName} ${widget.Clientname}").set({
                            "Applier":widget.ApplierName,
                            "Title":widget.title,
                            "Client":widget.Clientname,
                            "ClientEmail":widget.clientemail,
                            "ApplierEmail":widget.applieremail,
                            
                          });
                          FirebaseFirestore.instance.collection("Chats").doc("${widget.title} ${widget.ApplierName} ${widget.Clientname}").collection("Chat").doc("${messageController.text}${user!.email}").set({
                            "Message": messageController.text,
                            "SendBy": user!.email,
                            "Time": DateTime.now().microsecondsSinceEpoch,
                            "Time1":format,
                            "Date": dateformat
                          }).then((value) {
                            setState(() {
                              messageController.text = "";
                            });
                          });
                          FirebaseFirestore.instance.collection("Users").doc(widget.applieremail).collection("Notification").doc("Chat ${widget.Clientname}").set({
                            "Message":"You have recived messeged from ${widget.Clientname}",
                            "MarkAsRead":false,
                            "Time":DateTime.now().microsecondsSinceEpoch,
                            "Time1":format,
                            "Type":"Chat",
                            "Applier":widget.ApplierName,
                            "Client":widget.Clientname,
                            "Title":widget.title,
                            "ApplierEmail":widget.applieremail,
                            "ClientEmail":widget.clientemail
                          });
                          FirebaseFirestore.instance.collection("Chats").doc("${widget.title} ${widget.ApplierName} ${widget.Clientname}").update({
                            "ClientPush":true
                          });
                          FirebaseFirestore.instance.collection("Chats").doc("${widget.title} ${widget.ApplierName} ${widget.Clientname}").update({
                            "UserPush":false
                          });
                        }
                       
                      },
                      child: const Icon(Icons.send,color: Colors.white,)),
                      InkWell(
                        onTap: () {
                          Get.to(FreelancerDetails(email: widget.applieremail, title: widget.title),transition: Transition.fadeIn,duration: Duration(milliseconds: 500));
                        },
                        child: const Text("Hire",style: TextStyle(color: Colors.white,fontFamily: "Roboto-Bold"),))
                  ],
                ),
              ),
            ),
          )
         ], 
      ),

    );
  }

}