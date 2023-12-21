// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:recuirmentapp/Presentation/Screens/AdminDashboard.dart';
// import 'package:recuirmentapp/Presentation/Screens/HomeScreen.dart';
// import 'package:recuirmentapp/Themes/Themes.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SwitcherScreen extends StatefulWidget {
//   SwitcherScreen({Key? key}) : super(key: key);

//   @override
//   State<SwitcherScreen> createState() => _SwitcherScreenState();
// }

// class _SwitcherScreenState extends State<SwitcherScreen> {
  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             child: LottieBuilder.asset("assets/jobsearch.json"),
//           ),
//           MaterialButton(
//             color: lightColorScheme.primary,
//             minWidth: 350,
//             height: 50,
//             child: Text("Freelancer",style: TextStyle(color: Colors.white,fontFamily: "Roboto-Bold",fontSize: 18),),
//             onPressed: (){
//               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
//             }),
//             SizedBox(height: 10,),
//           MaterialButton(
//             color: lightColorScheme.primary,
//             minWidth: 350,
//             height: 50,
//             child: Text("Admin",style: TextStyle(color: Colors.white,fontFamily: "Roboto-Bold",fontSize: 18),),
//             onPressed: (){
//               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AdminDashboard()));
//             })
//         ],
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recuirmentapp/Presentation/Screens/AdminDashboard.dart';
import 'package:recuirmentapp/Presentation/Screens/HomeScreen.dart';

class SwitcherScreen extends StatefulWidget {
  SwitcherScreen({Key? key}) : super(key: key);

  @override
  State<SwitcherScreen> createState() => _SwitcherScreenState();
}

class _SwitcherScreenState extends State<SwitcherScreen> {
  final user = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Users").where("email",isEqualTo: user).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          if(snapshot.data.docs[0]["primaryRole"] == "Freelancer"){
            return HomeScreen();
          }
          else{
            return AdminDashboard();
          }
        }
        else{
          return Text("");
        }
      },
    );
  }
}