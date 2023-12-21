import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';

import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:recuirmentapp/Themes/Themes.dart';

class GenerateInvoice extends StatefulWidget {
  final String employeerName;
  final String employeerEmail;
  final String freelancername;
  final String CompletionDate;
  final String listedDate;
  final String Price;
  final String title;
  GenerateInvoice(
      {Key? key,
      required this.employeerName,
      required this.employeerEmail,
      required this.freelancername,
      required this.CompletionDate,
      required this.listedDate,
      required this.Price,
      required this.title})
      : super(key: key);

  @override
  State<GenerateInvoice> createState() => _GenerateInvoiceState();
}

class _GenerateInvoiceState extends State<GenerateInvoice> {
  bool isLoading = true;
  final user = FirebaseAuth.instance.currentUser;
  QuerySnapshot<Map<String, dynamic>>? userStream;
  String? name;
  String? email;
  String? country;
  String? gender;
  String? phone;
  String? birthdate;
  String? imageUrl;
  String? clientname;
  String? clientemail;
  String? clientcountry;
  String? clientgender;
  String? clientphone;
  String? clientbirthdate;
  String? clientimageUrl;
 Future<void> getUser()async {
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

  Future<void> getclient()async {
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: widget.employeerEmail)
          .get()
          .then((value) {
        userStream = value;

        clientname = userStream!.docs[0]["name"].toString();
        clientemail = userStream!.docs[0]["email"].toString();
        clientimageUrl = userStream!.docs[0]["ProfileImage"].toString();
        clientcountry = userStream!.docs[0]["country"].toString();
        clientphone = userStream!.docs[0]["phone"].toString();
        clientgender = userStream!.docs[0]["gender"].toString();
        clientbirthdate = userStream!.docs[0]["birthdate"].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getclient();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  final String dateformat = DateFormat('dd-MM-y').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Invoice",style: TextStyle(color: lightColorScheme.primary,fontFamily: "Roboto-Bold"),),
      ),
      // bottomNavigationBar: BottomAppBar(height: 30,elevation: 0,),
      body: isLoading ? Center(child: LottieBuilder.asset("assets/invoice.json")) :Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    color: lightColorScheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Freelancer Invoice",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Roboto-Bold",
                                    fontSize: 25),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Freelancer Details",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Roboto-Regular",
                                      fontSize: 18)),
                              Text("Name: ${widget.freelancername}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Roboto-Light",
                                      fontSize: 15)),
                              Text("Email: $email",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Roboto-Light",
                                      fontSize: 15)),
                              Text("Country: $country",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Roboto-Light",
                                      fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    color: Colors.blue[200],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Client Details",
                            style: TextStyle(
                                color: lightColorScheme.primary,
                                fontFamily: "Roboto-bold",
                                fontSize: 18)),
                        Text("Invoice Details",
                            style: TextStyle(
                                color: lightColorScheme.primary,
                                fontFamily: "Roboto-bold",
                                fontSize: 18))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          height: 5,
                          color: Colors.blue[200],
                        ),
                        Container(
                          width: 150,
                          height: 5,
                          color: Colors.blue[200],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name",
                                style: GoogleFonts.tinos(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(widget.employeerName,
                                style: GoogleFonts.tinos()),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Email",
                                style: GoogleFonts.tinos(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(widget.employeerEmail,
                                style: GoogleFonts.tinos()),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Phone Number",
                                style: GoogleFonts.tinos(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(clientphone.toString(),
                                style: GoogleFonts.tinos()),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Country",
                                style: GoogleFonts.tinos(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(clientcountry.toString(),
                                style: GoogleFonts.tinos()),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Invoice Number",
                                style: GoogleFonts.tinos(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("1", style: GoogleFonts.tinos()),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Invoice Date",
                                style: GoogleFonts.tinos(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(dateformat, style: GoogleFonts.tinos()),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Listed Date",
                                style: GoogleFonts.tinos(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(widget.listedDate, style: GoogleFonts.tinos()),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Completion Date",
                                style: GoogleFonts.tinos(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(widget.CompletionDate,
                                style: GoogleFonts.tinos()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Container(
                      height: 5,
                      color: Colors.blue[200],
                    ),
                  ),
                  Text("Services Details",
                      style: TextStyle(
                          color: lightColorScheme.primary,
                          fontFamily: "Roboto-bold",
                          fontSize: 18)),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blue[200],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Description",
                                  style: GoogleFonts.tinos(
                                      fontWeight: FontWeight.bold)),
                            Text("Amount",
                                  style: GoogleFonts.tinos(
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.title,
                                  style: GoogleFonts.tinos(
                                      fontWeight: FontWeight.bold)),
                            Text(widget.Price,
                                  style: GoogleFonts.tinos(
                                      fontWeight: FontWeight.bold)),
                          ],
                        
                      ),
                    ),
                  const SizedBox(height: 50,),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total:",
                                  style: GoogleFonts.tinos(
                                      fontWeight: FontWeight.bold)),
                            Text("Rs.${widget.Price}",
                                  style: GoogleFonts.tinos(
                                      fontWeight: FontWeight.bold)),
                          ],
                        
                      ),
                    ),
                    const SizedBox(height: 25,),
                    Text("This is dummy invoice generated by 'JOB SEEKER APP' for education purpose only...",style: GoogleFonts.tinos(fontSize: 9),)
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: isLoading ? Container() :FloatingActionButton(
        backgroundColor: lightColorScheme.primary,
        onPressed: () async {
        final tionsregular = await PdfGoogleFonts.tinosRegular();
        final tionsbold = await PdfGoogleFonts.tinosBold();

        final doc = pw.Document();
        doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Container(
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black)),
                child: pw.Column(children: [
                  pw.Container(
                      alignment: pw.Alignment.center,
                      height: 130,
                      color: PdfColors.indigo,
                      child: pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                          child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(height: 10),
                                pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    children: [
                                      pw.Text("Freelance Invoice",
                                          style: pw.TextStyle(
                                              color: PdfColors.white,
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 25)),
                                    ]),
                                pw.SizedBox(height: 15),
                                pw.Text("Freelancer Details",
                                    style: pw.TextStyle(
                                        font: tionsbold,
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 15)),
                                pw.Text("Name: ${widget.freelancername}",
                                    style: pw.TextStyle(
                                        font: tionsregular,
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 15)),
                                pw.Text("Email: $email",
                                    style: pw.TextStyle(
                                        font: tionsregular,
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 15)),
                                pw.Text("Counrty: $country",
                                    style: pw.TextStyle(
                                        font: tionsregular,
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 15)),
                              ]))),
                  pw.Container(height: 20, color: PdfColors.blue200),
                  pw.SizedBox(height: 10),
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                      child: pw.Column(children: [
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("Client Information",
                                        style: pw.TextStyle(
                                            color: PdfColors.indigo,
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 18)),
                                    pw.SizedBox(height: 5),
                                    pw.Container(
                                        height: 5,
                                        width: 200,
                                        color: PdfColors.blue200)
                                  ]),
                              pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("Invoice Details",
                                        style: pw.TextStyle(
                                            color: PdfColors.indigo,
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 18)),
                                    pw.SizedBox(height: 5),
                                    pw.Container(
                                        width: 200,
                                        height: 5,
                                        color: PdfColors.blue200)
                                  ]),
                            ]),
                        pw.SizedBox(height: 10),
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("Name",
                                        style: pw.TextStyle(
                                            font: tionsbold,
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 15)),
                                    pw.SizedBox(height: 2),
                                    pw.Text(widget.employeerName,
                                        style: pw.TextStyle(
                                            color: PdfColors.black,
                                            font: tionsregular,
                                            fontSize: 15)),
                                    pw.SizedBox(height: 10),
                                    pw.Text("Email",
                                        style: pw.TextStyle(
                                            font: tionsbold,
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 15)),
                                    pw.SizedBox(height: 2),
                                    pw.Text(widget.employeerEmail,
                                        style: pw.TextStyle(
                                            color: PdfColors.black,
                                            font: tionsregular,
                                            fontSize: 15)),
                                    pw.SizedBox(height: 10),
                                    pw.Text("Phone Number",
                                        style: pw.TextStyle(
                                            font: tionsbold,
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 15)),
                                    pw.SizedBox(height: 2),
                                    pw.Text(clientphone.toString(),
                                        style: pw.TextStyle(
                                            color: PdfColors.black,
                                            font: tionsregular,
                                            fontSize: 15)),
                                    pw.SizedBox(height: 10),
                                    pw.Text("Country",
                                        style: pw.TextStyle(
                                            font: tionsbold,
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 15)),
                                    pw.SizedBox(height: 2),
                                    pw.Text(clientcountry.toString(),
                                        style: pw.TextStyle(
                                            color: PdfColors.black,
                                            font: tionsregular,
                                            fontSize: 15)),
                                  ]),
                              pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("Invoice Number",
                                        style: pw.TextStyle(
                                            font: tionsbold,
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 15)),
                                    pw.SizedBox(height: 2),
                                    pw.Text("1",
                                        style: pw.TextStyle(
                                            color: PdfColors.black,
                                            font: tionsregular,
                                            fontSize: 15)),
                                    pw.SizedBox(height: 10),
                                    pw.Text("Invoice Date",
                                        style: pw.TextStyle(
                                            font: tionsbold,
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 15)),
                                    pw.Text(dateformat.toString(),
                                        style: pw.TextStyle(
                                            color: PdfColors.black,
                                            font: tionsregular,
                                            fontSize: 15)),
                                    pw.SizedBox(height: 10),
                                    pw.Text("Listed Date",
                                        style: pw.TextStyle(
                                            font: tionsbold,
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 15)),
                                    pw.Text(widget.listedDate,
                                        style: pw.TextStyle(
                                            color: PdfColors.black,
                                            font: tionsregular,
                                            fontSize: 15)),
                                    pw.SizedBox(height: 10),
                                    pw.Text("Completion Date",
                                        style: pw.TextStyle(
                                            font: tionsbold,
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 15)),
                                    pw.Text(widget.CompletionDate,
                                        style: pw.TextStyle(
                                            color: PdfColors.black,
                                            font: tionsregular,
                                            fontSize: 15)),
                                  ])
                            ]),
                        pw.SizedBox(height: 10),
                        pw.Container(height: 5, color: PdfColors.blue200),
                        pw.SizedBox(height: 10),
                        pw.Row(children: [
                          pw.Text("Services Details",
                              style: pw.TextStyle(
                                  color: PdfColors.indigo,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 18)),
                        ]),
                        pw.SizedBox(height: 5),
                        pw.Container(
                            height: 40,
                            color: PdfColors.blue200,
                            child: pw.Padding(
                                padding:
                                    const pw.EdgeInsets.symmetric(horizontal: 10),
                                child: pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                     pw.Container(
                                      width: 150,
                                      child:  pw.Text("Description",
                                          style: pw.TextStyle(
                                              font: tionsbold,
                                              color: PdfColors.black,
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 15)),
                                     ),
                                      pw.Text("Amount",
                                          style: pw.TextStyle(
                                              font: tionsbold,
                                              color: PdfColors.black,
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 15))
                                    ]))),
                        pw.SizedBox(height: 10),
                        pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                            child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text(widget.title,
                                      style: pw.TextStyle(
                                          font: tionsbold,
                                          color: PdfColors.black,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 15)),
                                  pw.Text(widget.Price,
                                      style: pw.TextStyle(
                                          font: tionsbold,
                                          color: PdfColors.black,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 15))
                                ])),
                        pw.SizedBox(height: 50),
                        pw.Divider(thickness: 0.5),
                        pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                            child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text("Total: ",
                                      style: pw.TextStyle(
                                          font: tionsbold,
                                          color: PdfColors.black,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 15)),
                                  pw.Text("Rs.${widget.Price}",
                                      style: pw.TextStyle(
                                          font: tionsbold,
                                          color: PdfColors.black,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 15))
                                ])),
                        pw.SizedBox(height: 100),
                        pw.Text(
                            "This is dummy invoice generated by 'JOB SEEKER APP' for education purpose only...",
                            style: pw.TextStyle(
                                color: PdfColors.black,
                                font: tionsregular,
                                fontSize: 10)),
                      ]))
                ]));
          },
        ));
        await Printing.layoutPdf(
            usePrinterSettings: true,
            name: "Freelance Invoice".toString(),
            onLayout: (PdfPageFormat format) async {
              return doc.save();
            });
      },
        child: const Icon(Icons.download,color: Colors.white,)),
    );
  }
}
