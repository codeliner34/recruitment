import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recuirmentapp/Presentation/Screens/YouListings/FreelancerDetails.dart';
import 'package:recuirmentapp/Presentation/Screens/YouListings/ProposalsDetails.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class RecivedProposals extends StatefulWidget {
  final String Title;
  RecivedProposals({
    Key? key,
    required this.Title,
  }) : super(key: key);

  @override
  State<RecivedProposals> createState() => _RecivedProposalsState();
}

class _RecivedProposalsState extends State<RecivedProposals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: lightColorScheme.background,
        title: Text(widget.Title),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Jobs")
                .doc(widget.Title)
                .collection("Proposels")
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 5,
                  ),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                            ProposalDetails(
                              Name: snapshot.data.docs[index]["Name"],
                              Country: snapshot.data.docs[index]["Country"],
                              More: snapshot.data.docs[index]["More"],
                              CoverLetter: snapshot.data.docs[index]
                                  ["CoverLetter"],
                              Link1: snapshot.data.docs[index]["Link 1"],
                              Link2: snapshot.data.docs[index]["Link 2"],
                              Link3: snapshot.data.docs[index]["Link 3"],
                              Date: snapshot.data.docs[index]["Date"],
                              Time: snapshot.data.docs[index]["Time"],
                              Email: snapshot.data.docs[index]["Email"],
                              Title: snapshot.data.docs[index]["Title"],
                              skill1: snapshot.data.docs[index]["Skill1"],
                              skill2: snapshot.data.docs[index]["Skill2"],
                              skill3: snapshot.data.docs[index]["Skill3"],
                            ),
                            transition: Transition.downToUp,
                            duration: Duration(milliseconds: 600));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: lightColorScheme.primary),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.docs[index]["Name"],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // SizedBox(height: 10,),
                                Text(
                                    "Date: ${snapshot.data.docs[index]["Date"]}",
                                    style: const TextStyle(color: Colors.white54)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: 80,
                                    width: 400,
                                    child: Expanded(
                                        child: Text(
                                      snapshot.data.docs[index]
                                          ["CoverLetter"],
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                    ))),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MaterialButton(
                                      minWidth: 350,
                                      height: 50,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      color: Colors.white,
                                      onPressed: () {
                                        Get.to(
                                            ProposalDetails(
                                              Name: snapshot.data.docs[index]
                                                  ["Name"],
                                              Country: snapshot.data
                                                  .docs[index]["Country"],
                                              More: snapshot.data.docs[index]
                                                  ["More"],
                                              CoverLetter: snapshot.data
                                                  .docs[index]["CoverLetter"],
                                              Link1: snapshot.data.docs[index]
                                                  ["Link 1"],
                                              Link2: snapshot.data.docs[index]
                                                  ["Link 2"],
                                              Link3: snapshot.data.docs[index]
                                                  ["Link 3"],
                                              Date: snapshot.data.docs[index]
                                                  ["Date"],
                                              Time: snapshot.data.docs[index]
                                                  ["Time"],
                                              Email: snapshot.data.docs[index]
                                                  ["Email"],
                                              Title: snapshot.data.docs[index]
                                                  ["Title"],
                                              skill1: snapshot
                                                  .data.docs[index]["Skill1"],
                                              skill2: snapshot
                                                  .data.docs[index]["Skill2"],
                                              skill3: snapshot
                                                  .data.docs[index]["Skill3"],
                                            ),
                                            duration:
                                                Duration(milliseconds: 600),
                                            transition: Transition.downToUp);
                                      },
                                      child: Text(
                                        "See Details",
                                        style: TextStyle(
                                            color: lightColorScheme.primary,
                                            fontFamily: "Roboto-Bold",
                                            fontSize: 18),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MaterialButton(
                                      minWidth: 350,
                                      height: 50,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      color: Colors.amber,
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>FreelancerDetails(
                                          email: snapshot.data.docs[index]["Email"],
                                          title: snapshot.data.docs[index]["Title"],
                                          )));
                                        
                                      },
                                      child: Text(
                                        "Hire",
                                        style: TextStyle(
                                            color: lightColorScheme.primary,
                                            fontFamily: "Roboto-Bold",
                                            fontSize: 18),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Text("");
              }
            },
          ),
        ),
      ),
    );
  }
}
