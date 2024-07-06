import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:longing/auth/forgot_password.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showSignupPage;
  const LoginPage({super.key, required this.showSignupPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future loginButtonFunct() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim());
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
                          controller: _usernameController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: "Email")),
                    )),
              ),

              // ****************************************
              // ********* Password Text Field **********
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
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: "Password")),
                    )),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 28.0 , top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const ForgotPasswordPage();
                        }));
                      },
                      child: const Text(
                        "Goldfish Memory? Reset Password",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 58, 113),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
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
                  onTap: loginButtonFunct,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9.5),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(224, 145, 213, 63),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Center(
                      child: Text(
                        "Sign In",
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
              // *********** Register Button ************
              // ****************************************
              GestureDetector(
                onTap: widget.showSignupPage,
                child: const Text(
                  "New Lovers Register Here",
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
                height: 100,
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
