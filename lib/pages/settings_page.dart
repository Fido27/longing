import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// FirebaseAuth.instance.signOut()

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // ****************************************
      // *************** Padding ****************
      // ****************************************
      const SizedBox(
        height: 500,
      ),

      // ****************************************
      // ************ Login Button **************
      // ****************************************
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: GestureDetector(
          onTap: () => FirebaseAuth.instance.signOut(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 9.5),
            decoration: BoxDecoration(
                color: const Color.fromARGB(224, 145, 213, 63),
                borderRadius: BorderRadius.circular(12)),
            child: const Center(
              child: Text(
                "Sign Out",
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
        height: 10,
      ),
    ]);
  }
}
