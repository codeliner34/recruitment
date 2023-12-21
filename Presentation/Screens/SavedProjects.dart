import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recuirmentapp/Presentation/Screens/DetailScreen.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class SavedProjects extends StatefulWidget {
  SavedProjects({Key? key}) : super(key: key);

  @override
  State<SavedProjects> createState() => _SavedProjectsState();
}

class _SavedProjectsState extends State<SavedProjects> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Saved Projects",style: TextStyle(color: lightColorScheme.primary,fontFamily: "Roboto-Bold"),),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Users").doc(user!.email).collection("Saved").snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              return  ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () => Get.to(
                              DetailScreen(
                                  email: snapshot.data.docs[index]["Email"],
                                      link1: snapshot.data.docs[index]["Link 1"],
                                      link2: snapshot.data.docs[index]["Link 2"],
                                      link3: snapshot.data.docs[index]["Link 3"],
                                      date: snapshot.data.docs[index]["ListedDate"],
                                      time: snapshot.data.docs[index]["ListedTime"],
                                      country: snapshot.data.docs[index]["ClientCountry"],
                                      title: snapshot.data.docs[index]["Title"],
                                      budget: snapshot.data.docs[index]["Price"],
                                      description: snapshot.data.docs[index]
                                          ["Description"],
                                      duration: snapshot.data.docs[index]["Duration"],
                                      experience: snapshot.data.docs[index]
                                          ["Experience"],
                                      listedBy: snapshot.data.docs[index]["ListedBy"],
                                      skill1: snapshot.data.docs[index]["Skill1"],
                                      skill2: snapshot.data.docs[index]["Skill2"],
                                      skill3: snapshot.data.docs[index]["Skill3"],
                                    ),transition: Transition.downToUp,duration: const Duration(milliseconds: 600)),
                                    
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                              child: Container(
                                // height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // border: Border.all(color: Colors.white54),
                                    color: lightColorScheme.primary
                                    ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              FirebaseFirestore.instance.collection("Users").doc(user!.email).collection("Saved").doc(snapshot.data.docs[index]["Title"]).delete().then((value) {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Project Removed...")));
                                              });
                                            },
                                            child: Icon(Icons.bookmark_remove_outlined,color: Colors.white,))
                                        ],
                                      ),
                                      Text(
                                        snapshot.data.docs[index]["Title"],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Roboto-Bold",
                                            fontSize: 20),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Divider(color: Colors.white24,),
                                      // SizedBox(height: 10,),
                                      Text("Rs: ${snapshot.data.docs[index]["Price"]}",
                                          style: TextStyle(color: Colors.white)),
                                      Text(
                                          "Duration: ${snapshot.data.docs[index]["Duration"]}",
                                          style: TextStyle(color: Colors.white)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          height: 80,
                                          width: 400,
                                          child: Expanded(
                                              child: Text(
                                            snapshot.data.docs[index]["Description"],
                                            style: TextStyle(color: Colors.white60),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4,
                                          )))
                                    ],
                                  ),
                                ),
                          
                          ),
                            ),
                        );
                      },
                    );
            }
            else{
              return Text('');
            }
          },
        ),
      ),
    );
  }
}