import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future forgotPasswordFunct() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _usernameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 232, 67, 122),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              // ****************************************
              // ************** Top Text ****************
              // ****************************************
              const Text(
                "Hellow! ♡",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                    fontFamily: "Aroha"),
              ),
              const Text(
                "Someone's Longing You",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    fontFamily: "Pacifico"),
              ),

              // ****************************************
              // *********** Middle Padding *************
              // ****************************************
              const SizedBox(
                height: 60,
              ),

              // ****************************************
              // ********* Username Text Field **********
              // ****************************************
              Padding(
                padding: const EdgeInsets.only(
                    top: 25.0, right: 25.0, left: 25.0, bottom: 7.5),
                child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 163, 217),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: "Email")),
                    )),
              ),

              // ****************************************
              // *************** Padding ****************
              // ****************************************
              const SizedBox(
                height: 15,
              ),

              // ****************************************
              // ************ Login Button **************
              // ****************************************
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: forgotPasswordFunct,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9.5),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(224, 145, 213, 63),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Center(
                      child: Text(
                        "Send Password Reset Link",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            fontFamily: "Pacifico"),
                      ),
                    ),
                  ),
                ),
              ),

              // ****************************************
              // *************** Padding ****************
              // ****************************************
              const SizedBox(
                height: 150,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
