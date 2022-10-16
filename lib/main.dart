import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_st/pages/add_post_page.dart';
import 'package:firebase_st/pages/home_page.dart';
import 'package:firebase_st/pages/signin_page.dart';
import 'package:firebase_st/pages/signup_page.dart';
import 'package:firebase_st/services/preference_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget startPage() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Preference.saveUserId(snapshot.data!.uid);
          return const HomePage();
        } else {
          return const SignInPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: startPage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        SignUpPage.id: (context) => const SignUpPage(),
        SignInPage.id: (context) => const SignInPage(),
        AddPostPage.id: (context) => const AddPostPage(),
      },
    );
  }
}
