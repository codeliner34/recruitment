import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recuirmentapp/Presentation/Screens/AdminDashboard.dart';
import 'package:recuirmentapp/Presentation/Screens/HomeScreen.dart';
import 'package:recuirmentapp/Presentation/Screens/JobScreen.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class ListProjectScreen extends StatefulWidget {
  const ListProjectScreen({Key? key}) : super(key: key);

  @override
  State<ListProjectScreen> createState() => _ListProjectScreenState();
}

class _ListProjectScreenState extends State<ListProjectScreen> {
  final user = FirebaseAuth.instance.currentUser;
  QuerySnapshot<Map<String, dynamic>>? userStream;
  String _value = 'Less Than 1 Month';
  String? selectedSkill1;
  String? selectedSkill2;
  String? selectedSkill3;
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
  final key = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linksController = TextEditingController();
  TextEditingController link1Controller = TextEditingController();
  TextEditingController link2Controller = TextEditingController();
  TextEditingController link3Controller = TextEditingController();
  getUser() {
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: user!.email)
          .get()
          .then((value) {
        userStream = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  String experienc = "Intermediate";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          title: const Text(
            "List Your Project",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: lightColorScheme.background,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title",
                      style: TextStyle(
                          color: lightColorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: titleController,
                      validator: (value) {
                        if (value!.contains("'") || value.contains("/")) {
                          return "This field can not contain ' and /";
                        } else if (value.isEmpty) {
                          return "Enter Title";
                        } else if (value.length < 4) {
                          return "Enter minimum 4 characters";
                        }
                      },
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: lightColorScheme.primary))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Price",
                      style: TextStyle(
                          color: lightColorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: priceController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Price";
                        } else if (value.contains(RegExp(r'[A-Z][a-z]'))) {
                          return "This field can't contain alphabets";
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.currency_rupee,
                            size: 20,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: lightColorScheme.primary))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Duration",
                      style: TextStyle(
                          color: lightColorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Radio(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.white;
                                    }
                                    return lightColorScheme.primary;
                                  }),
                                  value: "Less Than 1 Month",
                                  groupValue: _value,
                                  onChanged: (val) {
                                    setState(() {
                                      _value = val as String;
                                    });
                                  }),
                              const Text(
                                "Less Than 1 Month",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.white;
                                    }
                                    return lightColorScheme.primary;
                                  }),
                                  value: "1 to 3 Months",
                                  groupValue: _value,
                                  onChanged: (val) {
                                    setState(() {
                                      _value = val as String;
                                    });
                                  }),
                              const Text(
                                "1 to 3 Months",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.white;
                                    }
                                    return lightColorScheme.primary;
                                  }),
                                  value: "More Than 3 Months",
                                  groupValue: _value,
                                  onChanged: (val) {
                                    setState(() {
                                      _value = val as String;
                                    });
                                  }),
                              const Text(
                                "More Than 3 Months",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          "Experience ",
                          style: TextStyle(
                              color: lightColorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        MaterialButton(
                            minWidth: 100,
                            color: experienc == "Expert"
                                ? lightColorScheme.primary
                                : Colors.white,
                            onPressed: () {
                              setState(() {
                                experienc = "Expert";
                              });
                            },
                            child: Text(
                              "Expert",
                              style: TextStyle(
                                  color: experienc == "Expert"
                                      ? Colors.white
                                      : lightColorScheme.primary),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        MaterialButton(
                            minWidth: 100,
                            color: experienc == "Intermediate"
                                ? lightColorScheme.primary
                                : Colors.white,
                            onPressed: () {
                              setState(() {
                                experienc = "Intermediate";
                              });
                            },
                            child: Text(
                              "Intermediate",
                              style: TextStyle(
                                  color: experienc == "Intermediate"
                                      ? Colors.white
                                      : lightColorScheme.primary),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        MaterialButton(
                            minWidth: 100,
                            color: experienc == "Entry Level"
                                ? lightColorScheme.primary
                                : Colors.white,
                            onPressed: () {
                              setState(() {
                                experienc = "Entry Level";
                              });
                            },
                            child: Text(
                              "Entry Level",
                              style: TextStyle(
                                  color: experienc == "Entry Level"
                                      ? Colors.white
                                      : lightColorScheme.primary),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                          color: lightColorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Description";
                        }
                      },
                      maxLines: 8,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: lightColorScheme.primary))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Links",
                      style: TextStyle(
                          color: lightColorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: link1Controller,
                      decoration: InputDecoration(
                          hintText: "Link 1",
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: lightColorScheme.primary))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: link2Controller,
                      decoration: InputDecoration(
                          hintText: "Link 2",
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: lightColorScheme.primary))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: link3Controller,
                      decoration: InputDecoration(
                          hintText: "Link 3",
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: lightColorScheme.primary))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Required Skills",
                      style: TextStyle(
                          color: lightColorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
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
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
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
                              buttonPadding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              buttonDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),

                                // color: lightColorScheme.primary,
                              ),
                              // buttonElevation: 2,
                              itemHeight: 40,
                              itemPadding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              // dropdownMaxHeight: 200,
                              // dropdownWidth: MediaQuery.of(context).size.width -10,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: lightColorScheme.primary,
                              ),
                              dropdownElevation: 8,
                              scrollbarRadius: const Radius.circular(40),
                              scrollbarThickness: 6,
                              scrollbarAlwaysShow: true,
                              offset: const Offset(0, -10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
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
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
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
                              buttonPadding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              buttonDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),

                                // color: lightColorScheme.primary,
                              ),
                              // buttonElevation: 2,
                              itemHeight: 40,
                              itemPadding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              // dropdownMaxHeight: 200,
                              // dropdownWidth: MediaQuery.of(context).size.width -10,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: lightColorScheme.primary,
                              ),
                              dropdownElevation: 8,
                              scrollbarRadius: const Radius.circular(40),
                              scrollbarThickness: 6,
                              scrollbarAlwaysShow: true,
                              offset: const Offset(0, -10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
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
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
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
                              buttonPadding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              buttonDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),

                                // color: lightColorScheme.primary,
                              ),
                              // buttonElevation: 2,
                              itemHeight: 40,
                              itemPadding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              // dropdownMaxHeight: 200,
                              // dropdownWidth: MediaQuery.of(context).size.width -10,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: lightColorScheme.primary,
                              ),
                              dropdownElevation: 8,
                              scrollbarRadius: const Radius.circular(40),
                              scrollbarThickness: 6,
                              scrollbarAlwaysShow: true,
                              offset: const Offset(0, -10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            child: MaterialButton(
              onPressed: () {
                final String format =
                    DateFormat('dd-MM-y').format(DateTime.now());
                if (key.currentState!.validate()) {
                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(user!.email)
                      .collection("Listed")
                      .doc(titleController.text)
                      .set({
                    "Title": titleController.text,
                    "Description": descriptionController.text,
                    "Link 1": link1Controller.text,
                    "Link 2": link2Controller.text,
                    "Link 3": link3Controller.text,
                    "Price": priceController.text,
                    "Duration": _value.toString(),
                    "ListedBy": userStream!.docs[0]["name"],
                    "Email": userStream!.docs[0]["email"],
                    "Experience": experienc,
                    "ListedTime": TimeOfDay.now().toString(),
                    "ListedDate": format,
                    "Sealed": false,
                    "ClientCountry":userStream!.docs[0]["country"],
                    "Skill1":selectedSkill1.toString(),
                    "Skill2":selectedSkill2.toString(),"Skill3":selectedSkill3.toString(),
                    "PaymentStatus":"Request"
                  });
                  FirebaseFirestore.instance
                      .collection("Jobs")
                      .doc(titleController.text)
                      .set({
                    "Title": titleController.text,
                    "Description": descriptionController.text,
                    "Link 1": link1Controller.text,
                    "Link 2": link2Controller.text,
                    "Link 3": link3Controller.text,
                    "Price": priceController.text,
                    "Duration": _value.toString(),
                    "ListedBy": userStream!.docs[0]["name"],
                    "Email": userStream!.docs[0]["email"],
                    "Experience": experienc,
                    "ListedTime": TimeOfDay.now().toString(),
                    "ListedDate": format,
                    "Sealed":false,
                    "ClientCountry":userStream!.docs[0]["country"],
                    "Skill1":selectedSkill1.toString(),
                    "Skill2":selectedSkill2.toString(),"Skill3":selectedSkill3.toString(),
                  });
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AdminDashboard()));
                }
              },
              height: 60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minWidth: MediaQuery.of(context).size.width,
              color: lightColorScheme.primary,
              child: const Text(
                "List Project",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
