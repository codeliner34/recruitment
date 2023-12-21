import 'package:cloud_firestore/cloud_firestore.dart';
//For setting ClientPush False
Future<void> setClientPushFalse(
    String title, String ApplierName, String Clientname) async {
  FirebaseFirestore.instance
      .collection("Chats")
      .doc("$title $ApplierName $Clientname")
      .update({"ClientPush": false});
}

//For Setting Client Push True
Future<void> setClientPushTrue(
    // ignore: non_constant_identifier_names
    String title, String ApplierName, String Clientname) async {
  FirebaseFirestore.instance
      .collection("Chats")
      .doc("$title $ApplierName $Clientname")
      .update({"ClientPush": true});
}

Future<void> setUserPushFalse(
    // ignore: non_constant_identifier_names
    String title, String ApplierName, String Clientname) async {
  FirebaseFirestore.instance
      .collection("Chats")
      .doc("$title $ApplierName $Clientname")
      .update({"UserPush": false});
}

//For Setting Client Push True
Future<void> setUserPushTrue(
    // ignore: non_constant_identifier_names
    String title, String ApplierName, String Clientname) async {
  FirebaseFirestore.instance
      .collection("Chats")
      .doc("$title $ApplierName $Clientname")
      .update({"UserPush": true});
}

//For Set ChatRoom Info
Future<void> setChatroomInfo(
    String title,
    // ignore: non_constant_identifier_names
    String ApplierName,
    // ignore: non_constant_identifier_names
    String Clientname,
    String clientemail,
    String applieremail,
    String format) async {
  FirebaseFirestore.instance
      .collection("Chats")
      .doc("$title $ApplierName $Clientname")
      .set({
    "ClientEmail": clientemail,
    "ApplierEmail": applieremail,
    "Applier": ApplierName,
    "Client": Clientname,
    "Time1": format,
    "Title":title
  });
}

//For Send Message
Future<void> sendMessage(
    String dateFormat,
    String title,
    // ignore: non_constant_identifier_names
    String ApplierName,
    // ignore: non_constant_identifier_names
    String Clientname,
    String clientemail,
    String applieremail,
    String message,
    String userEmail,
    String format) async {
  FirebaseFirestore.instance
      .collection("Chats")
      .doc("$title $ApplierName $Clientname")
      .collection("Chat")
      .doc("$message$userEmail")
      .set({
    "Message": message,
    "SendBy": userEmail,
    "Time": DateTime.now().microsecondsSinceEpoch,
    "Time1": format,
    "Date":dateFormat
  });
}
