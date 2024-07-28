import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:longing/auth/helper.dart';

class MessageCard extends StatefulWidget {
  final bool isSaved;

  const MessageCard({
    super.key,
    required this.isSaved,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final String? title = "Message from your boo";
  final String? shortDesc = "Your Perosnal Raven Sent by Cupid";
  final String? longDesc =
      "If you had an epiphany to send some love to your partner, maybe in the form of a poetry, or a cute phrase, or just felt like telling them that you love them to infinity and beyond, till eternity passes, and if they'd die, you'd start a zombie apocolype together, this is a safe space to express that love.";
  final userMessageController = TextEditingController();
  final partnerMessageController = TextEditingController();

  @override
  void initState() {
    getFireStoreData();
    super.initState();
  }

  @override
  void dispose() {
    userMessageController.dispose();
    partnerMessageController.dispose();
    super.dispose();
  }

  Future heartTapped() async {
    if (widget.isSaved) {
      await FirebaseFirestore.instance
          .collection("rooms")
          .doc(await Helper.getRoomID())
          .collection("cards")
          .doc("message")
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection("rooms")
          .doc(await Helper.getRoomID())
          .collection("cards")
          .doc("message")
          .set({
        "love_card": false,
        "card_type": "message",
      });
    }
  }

  Future checkPressed() async {
    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(await Helper.getRoomID())
        .collection("cards")
        .doc("message")
        .set({
      await Helper.getUserEmail() as String: userMessageController.text.trim(),
    }, SetOptions(merge: true));
  }

  Future getFireStoreData() async {
    String userEmail = await Helper.getUserEmail() as String;
    String partnerEmail = await Helper.getPartnerEmail() as String;
    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(await Helper.getRoomID())
        .collection("cards")
        .doc("message")
        .get()
        .then((snapshot) {
      Map<String, dynamic>? documentData = snapshot.data();
      setState(() {
        userMessageController.text = documentData![userEmail];
        partnerMessageController.text = documentData[partnerEmail];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Icon heart;
    if (widget.isSaved) {
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 25.0,
                                    right: 25.0,
                                    left: 25.0,
                                    bottom: 2.5),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 163, 217),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: TextField(
                                          readOnly: true,
                                          controller: partnerMessageController,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "Your Partner's Message")),
                                    )),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 2.5,
                                    right: 25.0,
                                    left: 25.0,
                                    bottom: 2.5),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 163, 217),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: TextField(
                                          controller: userMessageController,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Your Message")),
                                    )),
                              ),
                              const SizedBox(height: 10),
                              MaterialButton(
                                onPressed: checkPressed,
                                child: Icon(Icons.check),
                              )
                            ]),
                          );
                        },
                      );
                    },
                  ))
        ]));
  }
}
