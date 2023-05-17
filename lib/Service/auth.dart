import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Widget/CheckScreen.dart';
import 'package:etors/Widget/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void GoogleSignInMethode() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Check if user already exists in Firestore
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();
    if (documentSnapshot.exists) {
      // User already exists, do nothing
      return;
    }

    // User doesn't exist, add a new document
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'Username': userCredential.user!.displayName,
      'firstName': '',
      'lastName': '',
      'Email': userCredential.user!.email,
      'Type': "Acheteur",
      'image': userCredential.user!.photoURL,
      'uid': userCredential.user!.uid,
    });
  }

  void signout() async {
    FirebaseAuth.instance.signOut();
  }

  void OTP() {}
}
