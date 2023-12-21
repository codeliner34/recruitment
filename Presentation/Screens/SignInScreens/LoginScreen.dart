import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recuirmentapp/Presentation/Screens/SignInScreens/RegisterScreen.dart';
import 'package:recuirmentapp/Themes/Themes.dart';
import 'package:rive/rive.dart';
import '../../../Providers/AuthProvider.dart';
import '../../../main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    bool isRecruiter = false;
    final key = GlobalKey<FormState>();
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomLeft,
      children: [
        // RiveAnimation.asset("assets/RiveAssets/confetti.riv"),
        RiveAnimation.asset("assets/RiveAssets/shapes.riv"),
        Positioned.fill(
          child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),child: SizedBox(),)
        ),
        Center(
          child: Container(
            width: 350,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text("Welcome Back!",
                      style: TextStyle(
                        fontFamily: "Roboto-Bold",
                        color: Colors.black,
                        fontSize: 30,
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: Form(
                      key: key,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            cursorColor: lightColorScheme.secondary,
                            validator: (value) {
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!);
                              if (value.isEmpty) {
                                return "Enter Email";
                              } else if (!emailValid) {
                                return "Enter correct email";
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: "Email",
                                label: Text(
                                  "Email",
                                  style: TextStyle(
                                      color: lightColorScheme.primary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: lightColorScheme.primary)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: lightColorScheme.primary,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: passwordController,
                            cursorColor: lightColorScheme.secondary,
                            validator: (value) {
                              if (value!.length < 6 || value.length > 12) {
                                return "Enter minimum 4 and Maximum 12 characters";
                              } else if (value.isEmpty) {
                                return "Enter Password";
                              }
                            },
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                suffix: Icon(Icons.remove_red_eye_outlined),
                                hintText: "Password",
                                label: Text(
                                  "Password",
                                  style: TextStyle(
                                      color: lightColorScheme.primary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: lightColorScheme.primary)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: lightColorScheme.primary,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          
                          SizedBox(height: 25),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            height: 60,
                            minWidth: 350,
                            color: lightColorScheme.primary,
                            elevation: 0,
                            onPressed: () {
                              if (key.currentState!.validate()) {
                                final provider =
                                    Provider.of<Auth>(context, listen: false);
                                provider
                                    .loginUser(emailController.text,
                                        passwordController.text)
                                    .then((value) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Main()));
                                });
                              }
                            },
                            child: Text(
                              "LogIn",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          // RiveAnimation.asset("assets/RiveAssets/.riv"),
                          SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            height: 60,
                            minWidth: 350,
                            color: Color.fromARGB(255, 173, 192, 250),
                            elevation: 0,
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => RegisterScreen()));
                            },
                            child: Text(
                              "Don't Have An Account?",
                              style: TextStyle(
                                  color: lightColorScheme.primary,
                                  fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          // GestureDetector(
                          //   onTap: (){

                          //   },
                          //   child: Text("Login As Recruiter",style: TextStyle(color: lightColorScheme.primary,fontWeight: FontWeight.bold),))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
