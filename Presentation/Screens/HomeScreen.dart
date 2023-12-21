// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recuirmentapp/Presentation/Screens/ChatsList.dart';
import 'package:recuirmentapp/Presentation/Screens/JobScreen.dart';
import 'package:recuirmentapp/Presentation/Screens/ProfilePage.dart';
import 'package:recuirmentapp/Presentation/Screens/ProposelScreen.dart';
import 'package:recuirmentapp/Presentation/Screens/SavedProjects.dart';
import 'package:recuirmentapp/Themes/Themes.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    // TODO: implement initState
    super.initState();
    getUser();
  }
  void showAlert(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Container(
                  height: 100,
                  child: Column(
                    children:  const [
                     Text("You are in applier mode, You can swich mode by just taping switch icon topright corner"),
                    ],
                  ),
                ),
              ));
    }

  int index = 0;
  PageController _myPage = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero,() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You can swich mode by taping icon at topRight corner."))));
    return Scaffold(
      // appBar:AppBar(
      //   elevation: 0,
      //   title: Text("Jobs"),
      //   centerTitle: true,
      //   foregroundColor: Colors.black,
      //   // backgroundColor: lightColorScheme.background,
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           final provider = Provider.of<Auth>(context, listen: false);
      //           provider.signOut();
      //         },
      //         icon: Icon(Icons.logout_outlined)),
      //         IconButton(
      //         onPressed: () {
      //             setState(() {
      //               isClient = true;
      //               print(isClient);
      //               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Main()));
      //             });
      //         },
      //         icon: Icon(Icons.change_circle))
      //   ],
      // ),
      
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                
               GestureDetector(            
                  child: Icon(
                    
                    Icons.home,
                    size: 35,color: index == 0 ? lightColorScheme.primary: lightColorScheme.onBackground,),
                  onTap: () {
                    setState(() {
                      _myPage.jumpToPage(0);
                      index = 0;
                    });
                  },
                ),
                
                GestureDetector(
                
                  child: Icon(Icons.chat_bubble,size: 35,color: index == 1 ? lightColorScheme.primary: lightColorScheme.onBackground),
                  onTap: () {
                    setState(() {
                      _myPage.jumpToPage(1);
                      index = 1;
                    });
                  },
                ),
                // SizedBox(width: 25,),
                GestureDetector(
                
                  child: Icon(FontAwesomeIcons.fileContract,size: 30,color: index == 2 ? lightColorScheme.primary: lightColorScheme.onBackground),
                  onTap: () {
                    setState(() {
                     _myPage.jumpToPage(2);
                      index = 2;
                    });
                  },
                ),
                GestureDetector(
                
                  child: Icon( Icons.bookmark,size: 35,color: index == 3 ? lightColorScheme.primary: lightColorScheme.onBackground),
                  onTap: () {
                    setState(() {
                      _myPage.jumpToPage(3);
                      index = 3;
                    });
                  },
                ),
                GestureDetector(            
                  child: Icon(
                  Icons.person,size: 35,color: index == 4 ? lightColorScheme.primary: lightColorScheme.onBackground,),
                  onTap: () {
                    setState(() {
                      _myPage.jumpToPage(4);
                      index = 4;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _myPage,
        onPageChanged: (int) {
          print('Page Changes to index $int');
        },
        children: <Widget>[
          const JobsScreen(),
          const ChatList(),
          const ProposalScreen(),
          SavedProjects(),
          ProfilePage(name: name.toString(), email: email.toString(), country: country.toString(), gender: gender.toString(), phone: phone.toString(), birthdate: birthdate.toString(),imageUrl: imageUrl.toString(),)
        ],
        physics: const NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
      ),
      
        
    );
  }
}