import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class PaymentRequests extends StatefulWidget {
  PaymentRequests({Key? key}) : super(key: key);

  @override
  State<PaymentRequests> createState() => _PaymentRequestsState();
}

class _PaymentRequestsState extends State<PaymentRequests> {
  final user = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(),
      body: Container(
        height: 500,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Users").doc(user).collection("Listed").where("PaymentStatus",isEqualTo: "Requested").snapshots(),

          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              return ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10,),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: lightColorScheme.primary,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.data.docs[index]["Title"],style:TextStyle(color: Colors.white,fontFamily: "Roboto-Bold",fontSize: 20),),
                            Divider(color: Colors.white70,),
                            Text("Rs. ${snapshot.data.docs[index]["ProposedPrice"]}",style:TextStyle(color: Colors.white,)),
                            Text("Name: ${snapshot.data.docs[index]["SealedBy"]}",style:TextStyle(color: Colors.white)),
                            Text("Email: ${snapshot.data.docs[index]["SealedByEmail"]}",style:TextStyle(color: Colors.white)),
                            SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: MaterialButton(
                                color: Colors.amber,
                                height: 50,
                                minWidth: MediaQuery.of(context).size.width,
                                onPressed: (){},child: Text("Complete Payment"),),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            else{
              return Text("data");
            }
          },
        ),
      ),
    );
  }
}