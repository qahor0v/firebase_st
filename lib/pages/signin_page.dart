import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_st/pages/home_page.dart';
import 'package:firebase_st/services/auth_service.dart';
import 'package:firebase_st/services/preference_service.dart';
import 'package:flutter/material.dart';

import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  static const String id = "sign_in_page";

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  signIn() async {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      await AuthService.signIn(context, email, password)
          .then((firebaseUser) => {
                _getFirebaseUser(firebaseUser!),
              });
    }
  }

  _getFirebaseUser(User firebaseUser) async {
    if (firebaseUser != null) {
      await Preference.saveUserId(firebaseUser.uid);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, HomePage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.redAccent.shade400,
              height: 45,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  signIn();
                },
                child: const Text(
                  "Sign in",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, SignUpPage.id);
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
