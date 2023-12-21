import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:recuirmentapp/Providers/AuthProvider.dart';
import 'package:recuirmentapp/firebase_options.dart';

import 'Presentation/Screens/SignInScreens/LoginScreen.dart';
import 'Presentation/Screens/SignInScreens/Switcher.dart';

bool isClient = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue
        ),
        home: const Main()
      ),
    );
  }
}



class Main extends StatefulWidget {
  
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  
final user = FirebaseAuth.instance.currentUser;
  QuerySnapshot<Map<String, dynamic>>? userStream;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
          child: CircularProgressIndicator(),
        );
        }
        else if(snapshot.hasData){
          return SwitcherScreen();
        }
        else if(snapshot.hasError){
          return const Center(child: Text("Something Went Wrong"),);
        }
        else{
          return const LoginScreen();
        }
        
      }
    );
  }
}