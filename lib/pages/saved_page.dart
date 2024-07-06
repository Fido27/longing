import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:longing/auth/helper.dart';
import 'package:longing/widgets/book_card.dart';
import 'package:longing/widgets/love_card.dart';
import 'package:longing/widgets/message_card.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final _titleController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _longDescController = TextEditingController();

  List<Widget> itemBuilderList = [
    const Padding(
      padding: EdgeInsets.only(bottom: 30.0),
      child: Text(
        "Lnging",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 80,
          fontFamily: "Aroha",
        ),
      ),
    ),
  ];

  Future getSavedIdeasList() async {
    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(await Helper.getRoomID())
        .collection("cards")
        .orderBy("love_card", descending: false)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              Map<String, dynamic> documentData = document.data();
              if (documentData["love_card"] == false) {
                switch (documentData["card_type"]) {
                  case "book":
                    itemBuilderList.add(BookCard(
                      isSaved: true,
                      bookTitle: documentData["book_title"],
                    ));
                    break;
                  case "message":
                    itemBuilderList.add(MessageCard(isSaved: true));
                    break;
                  default:
                }
              } else {
                itemBuilderList.add(LoveCard(
                  isSaved: true,
                  title: document.reference.id,
                  shortDesc: documentData["shortDesc"],
                  longDesc: documentData["longDesc"].replaceAll("\\n", "\n"),
                ));
              }
            }));
  }

  Future addSavedIdeasFireStore() async {
    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(await Helper.getRoomID())
        .collection("cards")
        .doc(_titleController.text.trim())
        .set({
      "love_card": true,
      "shortDesc": _shortDescController.text.trim(),
      "longDesc": _longDescController.text.trim()
    }).then((value) {
      _titleController.clear();
      _shortDescController.clear();
      _longDescController.clear();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _shortDescController.dispose();
    _longDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 232, 67, 122),
        body: FutureBuilder(
            future: getSavedIdeasList(),
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: itemBuilderList.length,
                  itemBuilder: (context, index) {
                    return itemBuilderList[index];
                  });
            }),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => showModalBottomSheet(
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 25.0,
                                  right: 25.0,
                                  left: 25.0,
                                  bottom: 7.5),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 163, 217),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: TextField(
                                        controller: _titleController,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Title")),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 25.0,
                                  right: 25.0,
                                  left: 25.0,
                                  bottom: 7.5),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 163, 217),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: TextField(
                                        controller: _shortDescController,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Short Description")),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 25.0,
                                  right: 25.0,
                                  left: 25.0,
                                  bottom: 7.5),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 163, 217),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: TextField(
                                        controller: _longDescController,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Long Description")),
                                  )),
                            ),
                            MaterialButton(
                              child: const Icon(Icons.check),
                              onPressed: addSavedIdeasFireStore,
                            ),
                          ]),
                        );
                      },
                    );
                  },
                )));
  }
}
