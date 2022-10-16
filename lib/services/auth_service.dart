import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_st/pages/signin_page.dart';
import 'package:firebase_st/services/preference_service.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  static final auth = FirebaseAuth.instance;

  static Future<User?> signUp(
      BuildContext context, String name, String email, String password) async {
    try {
      var authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = authResult.user;
      log("User data: ${user.toString()}");
      return user;
    } catch (e) {
      log("Error: ${e.toString()}");
    }
    return null;
  }

  static Future<User?> signIn(
      BuildContext context, String email, String password) async {
    try {
      auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = await auth.currentUser;
      log("User Data: ${user.toString()}");
      return user;
    } catch (e) {
      log("Error: ${e.toString()}");
    }
    return null;
  }

  static void signOut(BuildContext context) {
    auth.signOut();
    Preference.deleteUserId().then((value) => {
          Navigator.pushReplacementNamed(context, SignInPage.id),
        });
  }
}
