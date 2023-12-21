import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:recuirmentapp/Presentation/Screens/SignInScreens/SkillsGather.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class VerifyEmailUser extends StatefulWidget {
  VerifyEmailUser({Key? key}) : super(key: key);

  @override
  State<VerifyEmailUser> createState() => _VerifyEmailUserState();
}

class _VerifyEmailUserState extends State<VerifyEmailUser> {
  final user = FirebaseAuth.instance.currentUser!;
  Timer? timer;
  bool isEmailVerified = false;
  Future sendVerificationEmail()async{
    try {
      await user.sendEmailVerification();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  Future checkVerified()async{
    await user.reload();
    setState(() {
      isEmailVerified = user.emailVerified;
    });
    if(isEmailVerified) timer!.cancel();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = user.emailVerified;
    if(!isEmailVerified){
      sendVerificationEmail();
      timer = Timer.periodic(
        Duration(seconds: 1), (timer) {
        checkVerified();
       });
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return
    isEmailVerified ? SkillsGather(email: user.email.toString(), name: user.displayName.toString()) :
    Scaffold(
      appBar: AppBar(
        title: Text("Verify Email"),
        actions: [
          IconButton(onPressed: ()async{
            user.reload();
            print(user.emailVerified);
          }, icon: Icon(Icons.refresh))
        ],
      ),
      body: Container(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("A verification email has been sent...",style: TextStyle(color: lightColorScheme.primary,fontSize: 18,fontFamily: "Roboto-Bold"),)
              ],
            ),
          )
        ),
      ),
    );
  }
}
