import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoveCard extends StatelessWidget {
  final bool isSaved;
  final String? title;
  final String? shortDesc;
  final String? longDesc;

  const LoveCard(
      {super.key,
      required this.isSaved,
      required this.title,
      this.shortDesc,
      this.longDesc});

  Future getRoomID() async {
    String? currUserEmail = FirebaseAuth.instance.currentUser?.email;
    String partnerEmail = await FirebaseFirestore.instance
        .collection("users")
        .doc(currUserEmail)
        .get()
        .then((snapshot) => snapshot.get("partnerEmail"));

    List<String?> loverEmails = [currUserEmail, partnerEmail];
    loverEmails.sort();
    return loverEmails.join("_");
  }

  Future heartTapped() async {
    if (isSaved) {
      await FirebaseFirestore.instance
          .collection("rooms")
          .doc(await getRoomID())
          .collection("cards")
          .doc(title)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection("rooms")
          .doc(await getRoomID())
          .collection("cards")
          .doc(title)
          .set({
        "love_card": true,
        "shortDesc": shortDesc,
        "longDesc": longDesc
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Icon heart;
    if (isSaved) {
      heart = const Icon(
        Icons.favorite,
        color: Colors.red,
        size: 35,
      );
    } else {
      heart = const Icon(
        Icons.favorite_border,
        color: Colors.red,
        size: 35,
      );
    }

    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
              leading: GestureDetector(
                onTap: heartTapped,
                child: heart,
              ),
              title: Text(title!),
              subtitle: Text(shortDesc!),
              onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) {
                      return DraggableScrollableSheet(
                        maxChildSize: 0.8,
                        expand: false,
                        builder: (_, controller) {
                          return SingleChildScrollView(
                            controller: controller,
                            child: Column(children: [
                              const SizedBox(height: 30),
                              Text(
                                title!,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 35,
                                  color: Color.fromARGB(255, 6, 91, 49),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text("---------------------------"),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  longDesc!,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 0, 211, 109),
                                  ),
                                ),
                              ),
                            ]),
                          );
                        },
                      );
                    },
                  ))
        ]));
  }
}
