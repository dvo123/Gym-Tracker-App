import 'package:flutter/material.dart';
import 'package:my_first_flutter_project/pages/register_page.dart';
import 'login_page.dart';

class LoginOrResigerPage extends StatefulWidget {
  const LoginOrResigerPage({super.key});

  @override
  State<LoginOrResigerPage> createState() => _LoginOrResigerPageState();
}

class _LoginOrResigerPageState extends State<LoginOrResigerPage> {
  // initially show login page
  bool showLoginPage = true;

  // toggle between Login and Register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}