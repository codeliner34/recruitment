import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:recuirmentapp/Presentation/Screens/ViewPdf.dart';
import 'package:recuirmentapp/Presentation/Screens/SignInScreens/LoginScreen.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class SkillsGather extends StatefulWidget {
  final String email;
  final String name;
  SkillsGather({Key? key, required this.email, required this.name})
      : super(key: key);

  @override
  State<SkillsGather> createState() => _SkillsGatherState();
}

class _SkillsGatherState extends State<SkillsGather> {
  final user = FirebaseAuth.instance.currentUser!;

  bool isResumeUploaded = false;
  String filepath = "";
  String status = "Not Started";
  String resumeLink = "";
  String imageUrl = '';
  String _gender = "Male";
  XFile _image = XFile("");
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.email);
    print(user.displayName);
  }

  final List<String> items = [
    'Python',
    'Flutter',
    'Web Development',
    'Android Development',
    'Ios Development',
    'Data Science',
    'Machine Learning',
    'Artificial Intelligence',
  ];

  String? selectedSkill1;
  String? selectedSkill2;
  String? selectedSkill3;
  String? selectedCountry;
  TextEditingController BirthDateController = TextEditingController();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: key,
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text(user.displayName.toString()),
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Personal Information",
                            style: TextStyle(
                                fontFamily: "Roboto-Regular", fontSize: 20),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          filepath == ""
                              ? Text("Please Upload Image")
                              : CircleAvatar(
                                  radius: 100,
                                  backgroundImage: FileImage(File(filepath)),
                                ),
                          SizedBox(
                            height: 10,
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
                                  XFile? file = await imagePicker.pickImage(
                                      source: ImageSource.gallery);
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
                            height: 10,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: isResumeUploaded
                                  ? Container(
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: lightColorScheme.primary)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewPdf(
                                                            url: resumeLink,
                                                          )));
                                            },
                                            child: Text(
                                              resumeLink,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ),
                                    )
                                  : MaterialButton(
                                      elevation: 0,
                                      height: 50,
                                      // minWidth: 100,
                                      color: lightColorScheme.primary,
                                      onPressed: () async {
                                        setState(() {
                                          status = "Started";
                                        });
                                        FilePickerResult? result =
                                            await FilePicker.platform
                                                .pickFiles();
                                        if (result != null) {
                                          File pick = File(result
                                              .files.single.path
                                              .toString());
                                          var file = pick.readAsBytesSync();
                                          var pdfFile = FirebaseStorage.instance
                                              .ref()
                                              .child("Resume")
                                              .child("Resume ${user.email}");
                                          UploadTask task =
                                              pdfFile.putData(file);
                                          TaskSnapshot snapshot = await task;
                                          String url = await snapshot.ref
                                              .getDownloadURL();
                                          await FirebaseFirestore.instance
                                              .collection("Users")
                                              .doc(user.email)
                                              .update({"ResumeLink": url}).then(
                                                  (value) {
                                            setState(() {
                                              resumeLink = url.toString();
                                              print(resumeLink);
                                              isResumeUploaded = true;
                                              status = "Done";
                                            });
                                          });
                                        } else {
                                          setState(() {
                                            status = "Canceled";
                                          });
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.file_open,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Upload Resume",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ))),
                          SizedBox(
                            height: 20,
                          ),
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
                                        prefixIcon:
                                            Icon(Icons.calendar_month_outlined),
                                        hintText: 'Birth Date',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
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
                                            DateFormat('dd-MM-yyyy')
                                                .format(pickedDate);
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
                                  width: 360,
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
                                          fillColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.disabled)) {
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
                                          fillColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.disabled)) {
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
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
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
                                            borderSide: BorderSide(
                                                color:
                                                    lightColorScheme.primary),
                                          ))),
                                  context: context,
                                  onSelect: (Country country) {
                                    setState(() {
                                      selectedCountry =
                                          country.displayName.toString();
                                    });
                                    print(
                                        'Select country: ${country.displayName}');
                                  },
                                );
                              },
                              child: selectedCountry == null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Select Country",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          Icon(
                                            Icons
                                                .arrow_drop_down_circle_outlined,
                                            color: Colors.white,
                                            size: 30,
                                          )
                                        ],
                                      ),
                                    )
                                  : Text(selectedCountry.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Please select your skills (up to 3)",
                            style: TextStyle(
                                fontFamily: "Roboto-Regular", fontSize: 20),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: lightColorScheme.primary),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 200,
                                  // decoration: BoxDecoration(
                                  //   color:lightColorScheme.primary
                                  // ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Row(
                                        children: const [
                                          Icon(
                                            Icons.list,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Select Skill',
                                              style: TextStyle(
                                                fontSize: 20,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: items
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedSkill1,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedSkill1 = value as String;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                      ),
                                      iconSize: 30,
                                      iconEnabledColor: Colors.white,
                                      iconDisabledColor: Colors.grey,
                                      buttonHeight: 50,
                                      buttonWidth: 350,
                                      buttonPadding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      buttonDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),

                                        // color: lightColorScheme.primary,
                                      ),
                                      // buttonElevation: 2,
                                      itemHeight: 40,
                                      itemPadding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      // dropdownMaxHeight: 200,
                                      // dropdownWidth: MediaQuery.of(context).size.width -10,
                                      dropdownPadding: null,
                                      dropdownDecoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(15),
                                        color: lightColorScheme.primary,
                                      ),
                                      dropdownElevation: 8,
                                      scrollbarRadius:
                                          const Radius.circular(40),
                                      scrollbarThickness: 6,
                                      scrollbarAlwaysShow: true,
                                      offset: const Offset(0, -10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: lightColorScheme.primary),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 200,
                                  // decoration: BoxDecoration(
                                  //   color:lightColorScheme.primary
                                  // ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Row(
                                        children: const [
                                          Icon(
                                            Icons.list,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Select Skill',
                                              style: TextStyle(
                                                fontSize: 20,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: items
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedSkill2,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedSkill2 = value as String;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                      ),
                                      iconSize: 30,
                                      iconEnabledColor: Colors.white,
                                      iconDisabledColor: Colors.grey,
                                      buttonHeight: 50,
                                      buttonWidth: 350,
                                      buttonPadding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      buttonDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),

                                        // color: lightColorScheme.primary,
                                      ),
                                      // buttonElevation: 2,
                                      itemHeight: 40,
                                      itemPadding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      // dropdownMaxHeight: 200,
                                      // dropdownWidth: MediaQuery.of(context).size.width -10,
                                      dropdownPadding: null,
                                      dropdownDecoration: BoxDecoration(
                                        color: lightColorScheme.primary,
                                      ),
                                      dropdownElevation: 8,
                                      scrollbarRadius:
                                          const Radius.circular(40),
                                      scrollbarThickness: 6,
                                      scrollbarAlwaysShow: true,
                                      offset: const Offset(0, -10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: lightColorScheme.primary),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 200,
                                  // decoration: BoxDecoration(
                                  //   color:lightColorScheme.primary
                                  // ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Row(
                                        children: const [
                                          Icon(
                                            Icons.list,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Select Skill',
                                              style: TextStyle(
                                                fontSize: 20,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: items
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedSkill3,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedSkill3 = value as String;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                      ),
                                      iconSize: 30,
                                      iconEnabledColor: Colors.white,
                                      iconDisabledColor: Colors.grey,
                                      buttonHeight: 50,
                                      buttonWidth: 350,
                                      buttonPadding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      buttonDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: lightColorScheme.primary,
                                      ),
                                      // buttonElevation: 2,
                                      itemHeight: 40,
                                      itemPadding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      // dropdownMaxHeight: 200,
                                      // dropdownWidth: MediaQuery.of(context).size.width -10,
                                      dropdownPadding: null,
                                      dropdownDecoration: BoxDecoration(
                                        color: lightColorScheme.primary,
                                      ),
                                      dropdownElevation: 8,
                                      scrollbarRadius:
                                          const Radius.circular(40),
                                      scrollbarThickness: 6,
                                      scrollbarAlwaysShow: true,
                                      offset: const Offset(0, -10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                child: GestureDetector(
                  onTap: () async {
                    if (resumeLink == "") {
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
                                      Icons.file_copy,
                                      size: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Please Upload Resume",
                                      style: TextStyle(
                                          color: lightColorScheme.primary,
                                          fontFamily: "Roboto-Bold"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else if (filepath == "") {
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
                    } else {
                      if (key.currentState!.validate()) {
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(widget.email)
                            .update({
                          "email": widget.email,
                          "name": widget.name,
                          "birthdate": BirthDateController.text,
                          "country": selectedCountry.toString(),
                          "gender": _gender,
                          "skill1": selectedSkill1,
                          "skill2": selectedSkill2,
                          "skill3": selectedSkill3
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
                    }
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    color: lightColorScheme.primary,
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            status == "Started"
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black45,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        height: 250,
                        width: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: LinearProgressIndicator(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Uploading Resume...",
                              style: TextStyle(
                                  color: lightColorScheme.primary,
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ));
  }
}
