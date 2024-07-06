import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:longing/widgets/book_card.dart';
import 'package:longing/widgets/love_card.dart';
import 'package:longing/widgets/message_card.dart';

class IdeasPage extends StatefulWidget {
  const IdeasPage({super.key});

  @override
  State<IdeasPage> createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {
  final _titleController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _longDescController = TextEditingController();
  final bool _isLoveCard = true;

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

  Future addIdeasFireStore() async {
    await FirebaseFirestore.instance
        .collection("ideas")
        .doc(_titleController.text.trim())
        .set({
      "love_card": _isLoveCard,
      "shortDesc": _shortDescController.text.trim(),
      "longDesc": _longDescController.text.trim()
    }).then((value) {
      _titleController.clear();
      _shortDescController.clear();
      _longDescController.clear();
    });
  }

  Future getIdeasList() async {
    await FirebaseFirestore.instance
        .collection("ideas")
        .orderBy("love_card", descending: false)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              Map<String, dynamic> documentData = document.data();
              if (documentData["love_card"] == false) {
                switch (documentData["card_type"]) {
                  case "book":
                    itemBuilderList.add(BookCard(
                      isSaved: false,
                      bookTitle: documentData["book_title"],
                    ));
                    break;
                  case "message":
                    itemBuilderList.add(const MessageCard(isSaved: false));
                    break;
                  default:
                }
              } else {
                itemBuilderList.add(LoveCard(
                  isSaved: false,
                  title: document.reference.id,
                  shortDesc: documentData["shortDesc"],
                  longDesc: documentData["longDesc"].replaceAll("\\n", "\n"),
                ));
              }
            }));
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
    return FutureBuilder(
        future: getIdeasList(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: itemBuilderList.length,
              itemBuilder: (context, index) {
                return itemBuilderList[index];
              });
        });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: FutureBuilder(
  //           future: getIdeasList(),
  //           builder: (context, snapshot) {
  //             return ListView.builder(
  //                 itemCount: itemBuilderList.length,
  //                 itemBuilder: (context, index) {
  //                   return itemBuilderList[index];
  //                 });
  //           }),
  //       floatingActionButton: FloatingActionButton(
  //           child: Icon(Icons.add),
  //           onPressed: () => showModalBottomSheet(
  //                 context: context,
  //                 isScrollControlled: true,
  //                 builder: (_) {
  //                   return DraggableScrollableSheet(
  //                     maxChildSize: 0.8,
  //                     expand: false,
  //                     builder: (_, controller) {
  //                       return SingleChildScrollView(
  //                         controller: controller,
  //                         child: Column(children: [
  //                           Padding(
  //                             padding: const EdgeInsets.only(
  //                                 top: 25.0,
  //                                 right: 25.0,
  //                                 left: 25.0,
  //                                 bottom: 7.5),
  //                             child: Container(
  //                                 decoration: BoxDecoration(
  //                                     color: const Color.fromARGB(
  //                                         255, 255, 163, 217),
  //                                     borderRadius: BorderRadius.circular(12)),
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.only(left: 20.0),
  //                                   child: TextField(
  //                                       controller: _titleController,
  //                                       decoration: const InputDecoration(
  //                                           border: InputBorder.none,
  //                                           hintText: "Title")),
  //                                 )),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(
  //                                 top: 25.0,
  //                                 right: 25.0,
  //                                 left: 25.0,
  //                                 bottom: 7.5),
  //                             child: Container(
  //                                 decoration: BoxDecoration(
  //                                     color: const Color.fromARGB(
  //                                         255, 255, 163, 217),
  //                                     borderRadius: BorderRadius.circular(12)),
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.only(left: 20.0),
  //                                   child: TextField(
  //                                       controller: _shortDescController,
  //                                       decoration: const InputDecoration(
  //                                           border: InputBorder.none,
  //                                           hintText: "Short Description")),
  //                                 )),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(
  //                                 top: 25.0,
  //                                 right: 25.0,
  //                                 left: 25.0,
  //                                 bottom: 7.5),
  //                             child: Container(
  //                                 decoration: BoxDecoration(
  //                                     color: const Color.fromARGB(
  //                                         255, 255, 163, 217),
  //                                     borderRadius: BorderRadius.circular(12)),
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.only(left: 20.0),
  //                                   child: TextField(
  //                                       controller: _longDescController,
  //                                       decoration: const InputDecoration(
  //                                           border: InputBorder.none,
  //                                           hintText: "Long Description")),
  //                                 )),
  //                           ),
  //                           MaterialButton(
  //                             child: const Icon(Icons.check),
  //                             onPressed: addIdeasFireStore,
  //                           ),
  //                         ]),
  //                       );
  //                     },
  //                   );
  //                 },
  //               )));
  // }
}
