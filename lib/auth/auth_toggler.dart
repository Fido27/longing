import 'package:flutter/material.dart';
import 'package:longing/auth/login.dart';
import 'package:longing/auth/signup.dart';

class AuthToggle extends StatefulWidget {
  const AuthToggle({super.key});

  @override
  State<AuthToggle> createState() => _AuthToggleState();
}

class _AuthToggleState extends State<AuthToggle> {
  bool showLoginPage = true;

  void toggleAuthScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showSignupPage: toggleAuthScreens);
    } else {
      return SignupPage(showLoginPage: toggleAuthScreens);
    }
  }
}
