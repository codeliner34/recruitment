// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recuirmentapp/Presentation/Screens/ClientChatList.dart';
import 'package:recuirmentapp/Presentation/Screens/EmployerProfile.dart';
import 'package:recuirmentapp/Presentation/Screens/ListProject.dart';
import 'package:recuirmentapp/Presentation/Screens/YouListings/OnGoingProjects.dart';
import 'package:recuirmentapp/Themes/Themes.dart';
import 'YouListings/YourListings.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final user = FirebaseAuth.instance.currentUser;
  QuerySnapshot<Map<String, dynamic>>? userStream;
  String? name;
  String? email;
  String? country;
  String? gender;
  String? phone;
  String? birthdate;
  String? imageUrl;
  getUser() {
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: user!.email)
          .get()
          .then((value) {
        userStream = value;
        name = userStream!.docs[0]["name"].toString();
        email = userStream!.docs[0]["email"].toString();
        imageUrl = userStream!.docs[0]["ProfileImage"].toString();
        country = userStream!.docs[0]["country"].toString();
        phone = userStream!.docs[0]["phone"].toString();
        gender = userStream!.docs[0]["gender"].toString();
        birthdate = userStream!.docs[0]["birthdate"].toString();
      });
    });
  }

  @override
  void initState() {
    
    super.initState();
    getUser();
  }
   int index = 0;
  final PageController _myPage = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: lightColorScheme.background,
        elevation: 00,
        // shape: CircularNotchedRectangle(),
        child: SizedBox(
          // color: lightColorScheme.primary,
          height: 65,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                
               GestureDetector(
                
                  child: Icon(Icons.home,size: 35,color: index == 0 ? lightColorScheme.primary: lightColorScheme.onBackground,),
                  onTap: () {
                    setState(() {
                       _myPage.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut
                      );
                      index = 0;
                    });
                  },
                ),
                GestureDetector(
                
                  child: Icon(Icons.change_circle_outlined,size: 35,color: index == 1 ? lightColorScheme.primary: lightColorScheme.onBackground),
                  onTap: () {
                    setState(() {
                       _myPage.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut
                      );
                      index = 1;
                    });
                  },
                ),
                const SizedBox(width: 25,),
                GestureDetector(
                
                  child: Icon(Icons.chat,size: 35,color: index == 2 ? lightColorScheme.primary: lightColorScheme.onBackground),
                  onTap: () {
                    setState(() {
                       _myPage.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut
                      );
                      index = 2;
                    });
                  },
                ),
                GestureDetector(
                
                  child: Icon(Icons.settings,size: 35,color: index == 3 ? lightColorScheme.primary: lightColorScheme.onBackground),
                  onTap: () {
                    setState(() {
                      _myPage.animateToPage(
                        3,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut
                      );
                      index = 3;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _myPage,
        onPageChanged: (int) {
        },
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          YourLisings(email: FirebaseAuth.instance.currentUser!.email.toString()),
          const OnGoingProjects(),
          ClientChatList(),
          EmployerProfile(
            gender: gender.toString(),
            birthdate: birthdate.toString(),
            country: country.toString(),
            phone: phone.toString(),
          )
        ], // Comment this if you need to use Swipe.
      ),
      floatingActionButton: SizedBox(
        height: 65.0,
        width: 65.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: lightColorScheme.primary,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const ListProjectScreen()));
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            // elevation: 5.0,
          ),
        ),
      ),
    );
  }
}