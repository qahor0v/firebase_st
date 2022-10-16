import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_st/pages/home_page.dart';
import 'package:firebase_st/pages/signin_page.dart';
import 'package:firebase_st/services/auth_service.dart';
import 'package:firebase_st/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'sign_up_page';

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var isLoading = false;
  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  signUp() {
    String name = fullnameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    setState(() {
      isLoading = true;
    });

    AuthService.signUp(context, name, email, password).then((firebaseUser) => {
          getFirebaseUser(firebaseUser!),
        });
  }

  getFirebaseUser(User firebaseUser) async {
    // ignore: unnecessary_null_comparison
    if (firebaseUser != null) {
      setState(() {
        isLoading = false;
      });
      await Preference.saveUserId(firebaseUser.uid);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Fluttertoast.showToast(msg: "Xatolik!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: fullnameController,
                  decoration: const InputDecoration(
                    hintText: 'Full name',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                  //obscureText: true,
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
                      signUp();
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     const Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, SignInPage.id);
                        },
                        child:const Text(
                          "Sign in",
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
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
