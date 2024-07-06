import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Helper {
  static Future getRoomID() async {
    final currUserEmail = await getUserEmail() as String;
    final partnerEmail = await getPartnerEmail() as String;
    List<String> loverEmails = [currUserEmail, partnerEmail];
    loverEmails.sort();
    return loverEmails.join("_");
  }

  static Future getUserEmail() async {
    return FirebaseAuth.instance.currentUser?.email;
  }

  static Future getPartnerEmail() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(await getUserEmail())
        .get()
        .then((snapshot) => snapshot.get("partnerEmail"));
  }
}
