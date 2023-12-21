import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:recuirmentapp/Themes/Themes.dart';

class PaymentScreen extends StatefulWidget {
  final String title;
  final String employeerName;
  final String freelancerEmail;
  final String freelancername;
  final String proposedPrice;
  final String completionDate;
  final String employeerEmail;
  const PaymentScreen(
      {Key? key,
      required this.title,
      required this.employeerName,
      required this.freelancerEmail,
      required this.freelancername,
      required this.proposedPrice,
      required this.completionDate,
      required this.employeerEmail})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<PaymentItem> paymentItems = [];
  bool isCompleted = false;
  void onGooglePayResult(res) {
    setState(() {
      isCompleted = true;
    });
    final String dateformat = DateFormat('dd-MM-y').format(DateTime.now());
    final String format = DateFormat('hh:mm a').format(DateTime.now());
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.freelancerEmail)
        .collection("Completed")
        .doc(widget.title)
        .update({"PaymentStatus": "Completed"});
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.employeerEmail)
        .collection("Completed")
        .doc(widget.title)
        .update({"PaymentStatus": "Completed"});
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.freelancerEmail)
        .collection("Notification")
        .doc("Chat ${widget.employeerEmail}")
        .set({
      "Message":
          "You have be paid by ${widget.employeerName},Amount: Rs.${widget.proposedPrice}",
      "MarkAsRead": false,
      "Time": DateTime.now().microsecondsSinceEpoch,
      "Time1": format,
      "Type": "Chat",
      "Applier": widget.freelancername,
      "Client": widget.employeerName,
      "Title": widget.title,
      "ApplierEmail": widget.employeerEmail,
      "ClientEmail": widget.freelancerEmail
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title",
              style: TextStyle(
                  color: lightColorScheme.primary, fontWeight: FontWeight.bold),
            ),
            Text(widget.title),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Freelancer",
              style: TextStyle(
                  color: lightColorScheme.primary, fontWeight: FontWeight.bold),
            ),
            Text(widget.freelancername),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Email",
              style: TextStyle(
                  color: lightColorScheme.primary, fontWeight: FontWeight.bold),
            ),
            Text(widget.freelancerEmail),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Employeer",
              style: TextStyle(
                  color: lightColorScheme.primary, fontWeight: FontWeight.bold),
            ),
            Text(widget.employeerName),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Completion Date",
              style: TextStyle(
                  color: lightColorScheme.primary, fontWeight: FontWeight.bold),
            ),
            Text(widget.completionDate),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Price",
              style: TextStyle(
                  color: lightColorScheme.primary, fontWeight: FontWeight.bold),
            ),
            Text(widget.proposedPrice),
            const SizedBox(
              height: 40,
            ),
            isCompleted
                ? MaterialButton(
                    height: 50,
                    minWidth: double.infinity,
                    color: Colors.black,
                    onPressed: () {},
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : GooglePayButton(
                    paymentConfigurationAsset: "gpay.json",
                    onPressed: () {},
                    width: double.infinity,
                    height: 50,
                    onPaymentResult: onGooglePayResult,
                    paymentItems: paymentItems)
          ],
        ),
      )),
    );
  }
}
