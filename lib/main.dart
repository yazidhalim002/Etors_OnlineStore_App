import 'package:etors/Classes/Users.dart';
import 'package:etors/Screens/Buyer/Explore.dart';
import 'package:etors/Widget/CheckScreen.dart';
import 'package:etors/Widget/Login.dart';
import 'package:etors/Widget/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Users? me =
      await Users.getUserFromFirestore(FirebaseAuth.instance.currentUser!.uid);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const CheckScreen(),
      'Login': (context) => const Login(),
      'Signup': (context) => const SignUp(),
      'Home': (context) => const ExploreScreen(),
    },
  ));
}
