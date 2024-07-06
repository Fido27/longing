import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignupPage({super.key, required this.showLoginPage});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _partnerEmailController = TextEditingController();
  final _partnerPrefNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _partnerEmailController.dispose();
    _partnerPrefNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future signupButtonFunct() async {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.email)
          .set({
        'email': FirebaseAuth.instance.currentUser?.email,
        'partnerEmail': _partnerEmailController.text.trim(),
        'partnerName': _partnerPrefNameController.text.trim()
      });
    }
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
                    fontSize: 35,
                    fontFamily: "Pacifico"),
              ),

              // ****************************************
              // *********** Middle Padding *************
              // ****************************************
              const SizedBox(
                height: 40,
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
                          controller: _emailController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: "Email")),
                    )),
              ),

              // ****************************************
              // ********* Password Text Field **********
              // ****************************************
              Padding(
                padding: const EdgeInsets.only(
                    top: 7.5, right: 25.0, left: 25.0, bottom: 7.5),
                child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 163, 217),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: "Password")),
                    )),
              ),

              // ****************************************
              // ****** Confirm Password Text Field *****
              // ****************************************
              Padding(
                padding: const EdgeInsets.only(
                    top: 7.5, right: 25.0, left: 25.0, bottom: 7.5),
                child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 163, 217),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Confirm Password")),
                    )),
              ),

              // ****************************************
              // *********** Partner's Email ************
              // ****************************************
              Padding(
                padding: const EdgeInsets.only(
                    top: 7.5, right: 25.0, left: 25.0, bottom: 7.5),
                child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 163, 217),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                          controller: _partnerEmailController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Your Partner's Email")),
                    )),
              ),

              // ****************************************
              // ******* Partner's Preffered Name *******
              // ****************************************
              Padding(
                padding:
                    const EdgeInsets.only(top: 7.5, right: 25.0, left: 25.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 163, 217),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                          controller: _partnerPrefNameController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  "Partner's Nickname / What You Like To Call Your Partner")),
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
                  onTap: signupButtonFunct,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9.5),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(224, 145, 213, 63),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Center(
                      child: Text(
                        "Sign Up",
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
                height: 15,
              ),

              // ****************************************
              // ************ Register Link *************
              // ****************************************
              GestureDetector(
                onTap: widget.showLoginPage,
                child: const Text(
                  "Returning Lovebird? Sign In Here",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 58, 113),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 18),
                ),
              ),

              // ****************************************
              // *************** Padding ****************
              // ****************************************
              const SizedBox(
                height: 10,
              ),

              // ****************************************
              // ********* Quick Login Buttons **********
              // ****************************************
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Spacer(flex: 3),
              //     Icon(
              //       Icons.apple,
              //       size: 100,
              //     ),
              //     Spacer(flex: 1),
              //     Icon(
              //       Icons.fingerprint,
              //       size: 100,
              //     ),
              //     Spacer(flex: 3),
              //   ],
              // ),
            ]),
          ),
        ),
      ),
    );
  }
}
