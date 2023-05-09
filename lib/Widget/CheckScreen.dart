import 'package:etors/Service/BottomNavigationBar.dart';
import 'package:etors/Widget/onBoarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckScreen extends StatelessWidget {
  const CheckScreen({Key? key});

  Future<String?> getType(String uid) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
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
              String? uid = user.uid;

              return FutureBuilder<String?>(
                future: getType(uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String? gendre = snapshot.data;
                    return BottomNavigationBarScreen(
                        type: gendre == "Acheteur" ? "Acheteur" : "Vendeur");
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
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
