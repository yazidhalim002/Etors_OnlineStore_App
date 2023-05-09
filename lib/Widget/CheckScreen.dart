import 'package:etors/Service/BottomNavigationBar.dart';
import 'package:etors/Widget/onBoarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckScreen extends StatelessWidget {
  const CheckScreen({Key? key});

  Future<String?> getType(String email) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    return doc.get('Type');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User? user = snapshot.data;
            if (user != null) {
              String? gendre;
              String? email = user.email;
              if (email != null) {
                getType(email).then((value) {
                  gendre = value;
                  print(gendre);
                });
              }
              return BottomNavigationBarScreen(
                  gendre: gendre == "Buyer" ? Type.Acheteur : Type.Vendeur);
            } else {
              return OnBoardingScreen();
            }
          } else {
            return OnBoardingScreen();
          }
        },
      ),
    );
  }
}
