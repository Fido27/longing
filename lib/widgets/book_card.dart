import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:longing/auth/helper.dart';

class BookCard extends StatefulWidget {
  final bool isSaved;
  final String? bookTitle;

  const BookCard({
    super.key,
    required this.isSaved,
    this.bookTitle,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  final String? title = "Read a Book Together";
  final String? shortDesc = "Its like a book club if you're into it";
  final String? longDesc =
      "This one is for the bibliophiles out there. Read the same book during your week and discuss it during your next virtual date.";
  final bookTitleController = TextEditingController();
  final userPageNumController = TextEditingController();
  int userPageNum = 0;
  int partnerPageNum = 0;

  @override
  void initState() {
    bookTitleController.text = widget.bookTitle!;
    getFireStoreData();
    super.initState();
  }

  @override
  void dispose() {
    bookTitleController.dispose();
    userPageNumController.dispose();
    super.dispose();
  }

  Future heartTapped() async {
    if (widget.isSaved) {
      await FirebaseFirestore.instance
          .collection("rooms")
          .doc(await Helper.getRoomID())
          .collection("cards")
          .doc("book")
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection("rooms")
          .doc(await Helper.getRoomID())
          .collection("cards")
          .doc("book")
          .set({
        "love_card": false,
        "card_type": "book",
        "book_title": "Sample Book Title - November 9"
      });
    }
  }

  Future checkPressed() async {
    userPageNum = int.parse(userPageNumController.text.trim());
    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(await Helper.getRoomID())
        .collection("cards")
        .doc("book")
        .set({
      "book_title": bookTitleController.text.trim(),
      await Helper.getUserEmail() as String: userPageNum,
    }, SetOptions(merge: true));
  }

  Future getFireStoreData() async {
    String userEmail = await Helper.getUserEmail() as String;
    String partnerEmail = await Helper.getPartnerEmail() as String;
    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(await Helper.getRoomID())
        .collection("cards")
        .doc("book")
        .get()
        .then((snapshot) {
      Map<String, dynamic>? documentData = snapshot.data();
      setState(() {
        userPageNum = documentData![userEmail];
        partnerPageNum = documentData[partnerEmail];
        userPageNumController.text = userPageNum.toString();
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
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  longDesc!,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 0, 211, 109),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
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
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: TextField(
                                          controller: bookTitleController,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Book Title")),
                                    )),
                              ),
                              Text("Your partner is on page $partnerPageNum"),
                              Row(
                                children: [
                                  const Text("You are on Page: "),
                                  SizedBox(
                                    height: 50,
                                    width: 50,
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
                                            keyboardType: TextInputType.number,
                                            controller: userPageNumController,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "-1")),
                                      ),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () => setState(() {
                                      userPageNum += 1;
                                      userPageNumController.text =
                                          userPageNum.toString();
                                    }),
                                    onLongPress: () => setState(() {
                                      userPageNum -= 1;
                                      userPageNumController.text =
                                          userPageNum.toString();
                                    }),
                                    child: const Icon(Icons.add),
                                  )
                                ],
                              ),
                              MaterialButton(
                                onPressed: checkPressed,
                                child: const Icon(Icons.check),
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
