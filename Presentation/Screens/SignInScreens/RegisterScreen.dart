import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:recuirmentapp/Presentation/Screens/AdminDashboard.dart';
import 'package:recuirmentapp/Presentation/Screens/SignInScreens/GetEmployeerDetails.dart';
import 'package:recuirmentapp/Presentation/Screens/SignInScreens/LoginScreen.dart';
import 'package:recuirmentapp/Presentation/Screens/SignInScreens/SkillsGather.dart';
import 'package:recuirmentapp/Providers/AuthProvider.dart';
import 'package:recuirmentapp/Themes/Themes.dart';
import 'package:rive/rive.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;
  String? role;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(role);
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomLeft,
      children: [
        RiveAnimation.asset("assets/RiveAssets/shapes.riv"),
        Positioned.fill(
          child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),child: SizedBox(),)
        ),
        
        Center(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text("Create New Account",
                      style: TextStyle(
                        fontFamily: "Roboto-Bold",
                        color: Colors.black,
                        fontSize: 30,
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                role = "Freelancer";
                                print(role);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 70,
                              width: 200,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: role == "Freelancer"
                                          ? lightColorScheme.primary
                                          : Colors.white),
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              child: Text(
                                "Freelancer",
                                style: TextStyle(
                                    color: role == "Freelancer"
                                        ? lightColorScheme.primary
                                        : Colors.black,
                                    fontFamily: "Roboto-Bold"),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                role = "Employeer";
                                print(role);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 200,
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: role == "Employeer"
                                        ? lightColorScheme.primary
                                        : Colors.white,
                                  ),
                                  color: Colors.white),
                              child: Text(
                                "Employeer",
                                style: TextStyle(
                                    color: role == "Employeer"
                                        ? lightColorScheme.primary
                                        : Colors.black,
                                    fontFamily: "Roboto-Bold"),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Form(
                      key: key,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            cursorColor: lightColorScheme.secondary,
                            validator: (value) {
                              if (value!.contains("!") ||
                                  value.contains("*") ||
                                  value.contains("@") ||
                                  value.contains("\$") ||
                                  value.contains("^") ||
                                  value.contains("&")) {
                                return "This field can not contain special characters";
                              } else if (value.isEmpty) {
                                return "Enter Full name";
                              } else if (value.length < 4) {
                                return "Enter minimum 4 characters";
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Name",
                                label: Text(
                                  "Name",
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
                                  Icons.person_outline,
                                  color: lightColorScheme.primary,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                            controller: mobileController,
                            cursorColor: lightColorScheme.secondary,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Phone";
                              } else if (value.length < 10 ||
                                  value.length > 10) {
                                return "Enter 10 characters mobile number";
                              }
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                hintText: "Mobile",
                                label: Text(
                                  "Mobile",
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
                                  Icons.phone_outlined,
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
                            obscureText: isVisible,
                            decoration: InputDecoration(
                              suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isVisible = false;
                                    });
                                  },
                                  child: Icon(Icons.remove_red_eye_outlined)),
                              hintText: "Password",
                              label: Text(
                                "Password",
                                style:
                                    TextStyle(color: lightColorScheme.primary),
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
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(height: 30),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            height: 60,
                            minWidth: 350,
                            color: lightColorScheme.primary,
                            elevation: 0,
                            onPressed: () async {
                              if (role == null) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      print("Not selected");
                                      return AlertDialog(
                                        content: Container(
                                          alignment: Alignment.center,
                                          height: 100,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Please Select Role",
                                                style: TextStyle(
                                                    color: lightColorScheme
                                                        .primary,
                                                    fontFamily: "Roboto-Bold",
                                                    fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Ok"))
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                if (key.currentState!.validate()) {
                                  final provider =
                                      Provider.of<Auth>(context, listen: false);
                                  provider
                                      .createUser(emailController.text,
                                          passwordController.text)
                                      .then((value) {
                                    FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(emailController.text)
                                        .set({
                                      'name': nameController.text,
                                      'email': emailController.text,
                                      'password': passwordController.text,
                                      'phone': mobileController.text,
                                      'primaryRole': role
                                    }).then((value) async {
                                      await FirebaseAuth.instance.currentUser!
                                          .updateDisplayName(
                                              nameController.text);
                                      // await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                                    }).then((value) {
                                      if (role == "Freelancer") {
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                                builder: (_) => SkillsGather(
                                                      email:
                                                          emailController.text,
                                                      name: nameController.text,
                                                    )));
                                      } else if (role == "Employeer") {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    GetEmployeerDetail(
                                                      email:
                                                          emailController.text,
                                                      name: nameController.text,
                                                    )));
                                      }
                                    });
                                  });
                                }
                              }
                            },
                            child: Text(
                              "Register",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
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
                                      builder: (_) => LoginScreen()));
                            },
                            child: Text(
                              "Already Have An Account?",
                              style: TextStyle(
                                  color: lightColorScheme.primary,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
