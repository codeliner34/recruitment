import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recuirmentapp/Presentation/Screens/ChatScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Themes/Themes.dart';

class ProposalDetails extends StatefulWidget {
  final String Name;
  final String Country;
  final String More;
  final String CoverLetter;
  final String Link1;
  final String Link2;
  final String Link3;
  final String Date;
  final String Time;
  final String Email;
  final String Title;
  final String skill1;
  final String skill2;
  final String skill3;
  ProposalDetails(
      {Key? key,
      required this.Name,
      required this.Country,
      required this.More,
      required this.CoverLetter,
      required this.Link1,
      required this.Link2,
      required this.Link3,
      required this.Date,
      required this.Time,
      required this.Email,
      required this.Title, required this.skill1, required this.skill2, required this.skill3})
      : super(key: key);

  @override
  State<ProposalDetails> createState() => _ProposalDetailsState();
}

class _ProposalDetailsState extends State<ProposalDetails> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.Name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.Name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("CoverLetter:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: lightColorScheme.primary)),
              Text(
                "(You can select and copy links from coverletter)",
                style: TextStyle(color: Colors.black45, fontSize: 11),
              ),
              SizedBox(
                height: 10,
              ),
              SelectableText(
                widget.CoverLetter,
                style: TextStyle(fontSize: 15),
              ),
               Divider(
                  thickness: 1,
                ),
                Row(
                  children: [
                    Text("Link 1:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: lightColorScheme.primary)),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          launch(widget.Link1);
                        }, child: Text(widget.Link1))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text("Link 2:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: lightColorScheme.primary)),
                    SizedBox(
                      width: 5,
                    ),
                    SelectableText(widget.Link2)
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text("Link 3:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: lightColorScheme.primary)),
                    SizedBox(
                      width: 5,
                    ),
                    SelectableText(widget.Link3)
                  ],
                ),
                
                Divider(
                  thickness: 1,
                ),
                Text("About:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: lightColorScheme.primary)),
                SizedBox(
                  height: 10,
                ),
                SelectableText(
                  widget.More,
                  style: TextStyle(fontSize: 15),
                ),
                Divider(),
                Text("Skills:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: lightColorScheme.primary)),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                    alignment: Alignment.center,
                    height: 45,
                    // width: 100,
                    decoration: BoxDecoration(
                      color: lightColorScheme.primary,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.skill1,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Container(
                    alignment: Alignment.center,
                    height: 45,
                    // width: 100,
                    decoration: BoxDecoration(
                      color: lightColorScheme.primary,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.skill2,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Container(
                    alignment: Alignment.center,
                    height: 45,
                    // width: 100,
                    decoration: BoxDecoration(
                      color: lightColorScheme.primary,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.skill3,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  ),
                  ],
                ),
              ),
                Divider(),

                Row(
                  children: [
                    Text("Name: "),
                    SizedBox(width: 10,),
                    Text(widget.Name)
                  ],
                ),Row(
                  children: [
                    Text("Country: "),
                    Text(widget.Country),
                  ],
                ),
                Row(
                  children: [
                    Text("Date: "),
                    SizedBox(width: 20,),
                    Text(widget.Date)
                  ],
                )
                
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () => Get.to(ChatScreen(applieremail: widget.Email,clientemail: user!.email.toString(), title: widget.Title,),
                            transition: Transition.rightToLeftWithFade,
                            duration: Duration(milliseconds: 500)),
        child: BottomAppBar(
          child: Container(
            color: lightColorScheme.primary,
            height: 50,
            alignment: Alignment.center,
            child: Text("Start Chat",style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),)),
        ),)
    );
  }
}

