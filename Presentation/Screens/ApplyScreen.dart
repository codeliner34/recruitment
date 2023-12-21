import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recuirmentapp/Presentation/Screens/HomeScreen.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class ApplyScreen extends StatefulWidget {
  final String title;
  final String budget;
  final String description;
  final String duration;
  final String experience;
  final String listedBy;
  final String country;
  final String time;
  final String date;
  // ignore: non_constant_identifier_names
  final String ListedEmail;
  const ApplyScreen(
      {Key? key,
      required this.title,
      required this.budget,
      required this.description,
      required this.duration,
      required this.experience,
      required this.listedBy,
      required this.country,
      required this.time,
      // ignore: non_constant_identifier_names
      required this.date, required this.ListedEmail})
      : super(key: key);

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  QuerySnapshot<Map<String, dynamic>>? userStream;
  final user = FirebaseAuth.instance.currentUser;
  String? name;
   getUser(){
    setState(() {
      FirebaseFirestore.instance.collection("Users").where("email",isEqualTo: user!.email).get().then((value) {
        userStream = value;
        
        name = userStream!.docs[0]["name"].toString();
    });
    });
  }
  @override
  void initState() {
    super.initState();
    getUser();
  }
  final key = GlobalKey<FormState>();
  TextEditingController coverController = TextEditingController();
  TextEditingController link1Controller = TextEditingController();
  TextEditingController link2Controller = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController link3Controller = TextEditingController();
  TextEditingController moreController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.background,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: lightColorScheme.primary,
        backgroundColor: lightColorScheme.background,
        title: const Text("Apply For This Job"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    color: lightColorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Row(
                children: [
                  const Text("Budget: "),
                  const Icon(
                    Icons.currency_rupee_sharp,
                    size: 15,
                  ),
                  Text(widget.budget),
                ],
              ),
              Text("Duration: ${widget.duration}"),
              const Divider(),
             
              Form(
                key: key,
                  child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                    "Cover Letter:",
                    style: TextStyle(
                        color: lightColorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  TextFormField(
                    controller: coverController,
                    // maxLength: 100,
                    maxLines: 5,
                    // controller: titleController,
                    validator: (value) {
                      if(value!.isEmpty){
                        return "Please type cover letter";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: lightColorScheme.primary))),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Proposed Price: ",
                          style: TextStyle(
                              color: lightColorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 10,),
                   TextFormField(
                    keyboardType: TextInputType.number,
                    controller: priceController,
                   validator: (value) {
                      if(value!.isEmpty){
                        return "Please Enter";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: lightColorScheme.primary))),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Text("Links: ",
                          style: TextStyle(
                              color: lightColorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  ),
                  TextFormField(controller: link1Controller,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: lightColorScheme.primary))),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: link2Controller,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: lightColorScheme.primary))),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: link3Controller,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: lightColorScheme.primary))),
                  ),
                  const SizedBox(height: 10,),
                  const Divider(),
                  // SizedBox(height: 5,),
                  Text(
                    "More About You:",
                    style: TextStyle(
                        color: lightColorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  TextFormField(
                    maxLength: 100,
                    maxLines: 3,
                    controller: moreController,
                    validator: (value) {
                      return null;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: lightColorScheme.primary))),
                  ),
                  const SizedBox(height: 30,),
                  const Text("")
                    ],
                  ),
                  MaterialButton(onPressed: (){
                    if(key.currentState!.validate()){
                  final String format = DateFormat('dd-MM-y')
                                    .format(DateTime.now());
                  FirebaseFirestore.instance.collection("Jobs").doc(widget.title).collection("Proposels").doc(user!.email).set({
                    "Name":name,
                    "Date":format,
                    "Time":TimeOfDay.now().toString(),
                    "CoverLetter":coverController.text,
                    "Link 1":link1Controller.text,
                    "Link 2":link2Controller.text,
                    "Link 3":link3Controller.text,
                    "More":moreController.text,
                    "Title":widget.title,
                    "Price":widget.budget,
                    "Duration":widget.duration,
                    "Status":false,
                    "Country":userStream!.docs[0]["country"],
                    "Email":userStream!.docs[0]["email"],
                    "Skill1":userStream!.docs[0]["skill1"],
                    "Skill2":userStream!.docs[0]["skill2"],
                    "Skill3":userStream!.docs[0]["skill3"],
                    "ListedBy":widget.listedBy,
                    "ProposedPrice":priceController.text,
                    "ListedEmail":widget.ListedEmail,
                    "PaymentStatus":"Request",
                  });
                  FirebaseFirestore.instance.collection("Users").doc(user!.email).collection("Proposels").doc(widget.title).set({
                    "Name":name,
                    "Date":format,
                    "Client":widget.listedBy,
                    "ClientCountry":widget.country,
                    "Time":TimeOfDay.now().toString(),
                    "CoverLetter":coverController.text,
                    "Link 1":link1Controller.text,
                    "Link 2":link2Controller.text,
                    "Link 3":link3Controller.text,
                    "More":moreController.text,
                    "Title":widget.title,
                    "Price":widget.budget,
                    "Duration":widget.duration,
                    "Status":false,
                    "ListedBy":widget.listedBy,
                    "ProposedPrice":priceController.text,
                    "ListedEmail":widget.ListedEmail,
                    "PaymentStatus":"Request",
                  });
                  Navigator.pushReplacement((context), MaterialPageRoute(builder: (_)=>HomeScreen()));
                    }
                  },
                    color: lightColorScheme.primary,
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    child: const Text("Apply",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
