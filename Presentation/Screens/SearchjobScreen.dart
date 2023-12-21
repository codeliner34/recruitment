import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recuirmentapp/Presentation/Screens/JobScreen.dart';

class JobSearchScreen extends StatefulWidget {
  JobSearchScreen({Key? key}) : super(key: key);

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String search = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
              
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                        alignment: Alignment.center,
                        // width: 200,
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search Here..."),
                          onChanged: (value) {
                            setState(() {
                              search = value;
                              print(search);
                            });
                          },
                        ))),
              ),
            ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child:Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("Jobs").where("Sealed",isEqualTo: false).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 10,),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    if(search.isEmpty){
                      return JobTile(
                          user: user, 
                          budget: snapshot.data.docs[index]["Price"],
                          country: snapshot.data.docs[index]["ClientCountry"], 
                          date: snapshot.data.docs[index]["ListedDate"],
                          time: snapshot.data.docs[index]["ListedTime"],
                          title: snapshot.data.docs[index]["Title"],
                          skill1: snapshot.data.docs[index]["Skill1"],
                          skill2: snapshot.data.docs[index]["Skill2"],
                          skill3: snapshot.data.docs[index]["Skill3"],
                          link1: snapshot.data.docs[index]["Link 1"],
                          link2: snapshot.data.docs[index]["Link 2"],
                          link3: snapshot.data.docs[index]["Link 3"],
                          listedBy: snapshot.data.docs[index]["ListedBy"],
                          email: snapshot.data.docs[index]["Email"],
                          experience: snapshot.data.docs[index]["Experience"],
                          description: snapshot.data.docs[index]["Description"],
                          duration: snapshot.data.docs[index]["Duration"],
                        );
                    }
                    if(
                      data['Title'].toString().toLowerCase().contains(search) || 
                      data['Skill1'].toString().toLowerCase().contains(search) || 
                      data['Skill2'].toString().toLowerCase().contains(search)||
                      data['Skill3'].toString().toLowerCase().contains(search)
                      ){
                      return JobTile(
                          user: user, 
                          budget: snapshot.data.docs[index]["Price"],
                          country: snapshot.data.docs[index]["ClientCountry"], 
                          date: snapshot.data.docs[index]["ListedDate"],
                          time: snapshot.data.docs[index]["ListedTime"],
                          title: snapshot.data.docs[index]["Title"],
                          skill1: snapshot.data.docs[index]["Skill1"],
                          skill2: snapshot.data.docs[index]["Skill2"],
                          skill3: snapshot.data.docs[index]["Skill3"],
                          link1: snapshot.data.docs[index]["Link 1"],
                          link2: snapshot.data.docs[index]["Link 2"],
                          link3: snapshot.data.docs[index]["Link 3"],
                          listedBy: snapshot.data.docs[index]["ListedBy"],
                          email: snapshot.data.docs[index]["Email"],
                          experience: snapshot.data.docs[index]["Experience"],
                          description: snapshot.data.docs[index]["Description"],
                          duration: snapshot.data.docs[index]["Duration"],
                        );
                    }
                    return Container(
                      // child: Image.asset("assets/saly-17.png"),
                    );
                  },
                );
              } else {
                return Text("Nothing To Show");
              }
            },
          ),
        ))
    );
  }
}
