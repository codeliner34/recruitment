import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:recuirmentapp/Presentation/Screens/SignInScreens/LoginScreen.dart';

import '../../../Themes/Themes.dart';

class GetEmployeerDetail extends StatefulWidget {
  final String email;
  final String name;
  String? selectedCountry;
  GetEmployeerDetail({Key? key, required this.email, required this.name})
      : super(key: key);

  @override
  State<GetEmployeerDetail> createState() => _GetEmployeerDetailState();
}

class _GetEmployeerDetailState extends State<GetEmployeerDetail> {
  final user = FirebaseAuth.instance.currentUser!;
  String? selectedCountry;
  TextEditingController BirthDateController = TextEditingController();
  bool isResumeUploaded = false;
  String filepath = "";
  String status = "Not Started";
  String resumeLink = "";
  String imageUrl = '';
  String _gender = "Male";
  final key = GlobalKey<FormState>();
  XFile _image = XFile("");
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            children: [
             
              filepath == ""
                  ? Text("Please Upload Image")
                  : CircleAvatar(
                      radius: 100,
                      backgroundImage: FileImage(File(filepath)),
                    ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: MaterialButton(
                    elevation: 0,
                    height: 50,
                    // minWidth: 100,
                    color: lightColorScheme.primary,
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file =
                          await imagePicker.pickImage(source: ImageSource.gallery);
                      if (file == null) {
                        return;
                      }
                      setState(() {
                        filepath = file.path;
                        print(filepath);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Pick Profile Image",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MaterialButton(
                  elevation: 0,
                  height: 60,
                  minWidth: 350,
                  shape: RoundedRectangleBorder(),
                  color: lightColorScheme.primary,
                  onPressed: () {
                    showCountryPicker(
                      showPhoneCode: false,
                      countryListTheme: CountryListThemeData(
                          inputDecoration: InputDecoration(
                              hintText: "Search here",
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: lightColorScheme.primary),
                              ))),
                      context: context,
                      onSelect: (Country country) {
                        setState(() {
                          selectedCountry = country.displayName.toString();
                        });
                        print('Select country: ${country.displayName}');
                      },
                    );
                  },
                  child: selectedCountry == null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Select Country",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              Icon(
                                Icons.arrow_drop_down_circle_outlined,
                                color: Colors.white,
                                size: 30,
                              )
                            ],
                          ),
                        )
                      : Text(selectedCountry.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
              SizedBox(height:20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter BirthDate";
                          }
                        },
                        controller: BirthDateController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_month_outlined),
                            hintText: 'Birth Date',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(05))),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2100));
        
                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            setState(() {
                              BirthDateController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: lightColorScheme.primary,
                        // borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Gender :",
                            style: TextStyle(
                                fontFamily: "Roboto-Regular",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Radio(
                              fillColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.white;
                                }
                                return Colors.white;
                              }),
                              value: "Male",
                              groupValue: _gender,
                              onChanged: (val) {
                                setState(() {
                                  _gender = val as String;
                                  print(_gender);
                                });
                              }),
                          Text(
                            "Male",
                            style: TextStyle(color: Colors.white),
                          ),
                          Radio(
                              fillColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.white;
                                }
                                return Colors.white;
                              }),
                              value: "Female",
                              groupValue: _gender,
                              onChanged: (val) {
                                setState(() {
                                  _gender = val as String;
                                  print(_gender);
                                });
                              }),
                          Text(
                            "Female",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50,),
                    MaterialButton(
                    onPressed: ()async{
                      if (filepath == "") {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  height: 200,
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 50,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Please upload photo",
                                        style: TextStyle(
                                            color: lightColorScheme.primary,
                                            fontFamily: "Roboto-Bold"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else if (selectedCountry == null) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  height: 200,
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.flag,
                                        size: 50,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Please Select Country",
                                        style: TextStyle(
                                            color: lightColorScheme.primary,
                                            fontFamily: "Roboto-Bold"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }else{
                       if(key.currentState!.validate()){}
                        FirebaseFirestore.instance
                              .collection("Users")
                              .doc(widget.email)
                              .update({
                            "email": widget.email,
                            "name": widget.name,
                            "birthdate": BirthDateController.text,
                            "country": selectedCountry.toString(),
                            "gender": _gender,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Uploading Information Please Wait...")));
                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference referenceDirImages =
                              referenceRoot.child("ProfileImages");
                          Reference referenceImageToUpload = referenceDirImages
                              .child("ProfileImage ${widget.name}");
                          await referenceImageToUpload.putFile(File(filepath));
                          imageUrl =
                              await referenceImageToUpload.getDownloadURL();
                          print("Hii ${imageUrl}");
                          user.updatePhotoURL(imageUrl);
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(widget.email)
                              .update({"ProfileImage": imageUrl});
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => LoginScreen()));
                        
                      }
                    },
                    height: 60,
                    minWidth: MediaQuery.of(context).size.width,
                    color: Colors.amber,
                    elevation: 0,
                    child: Text("Continue",style: TextStyle(color: lightColorScheme.primary,fontFamily: "Roboto-Bold",fontSize: 20),),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
