import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Livreur extends StatefulWidget {
  const Livreur({super.key});

  @override
  State<Livreur> createState() => _LivreurState();
}

class _LivreurState extends State<Livreur> {
  int idCommande = 0;
  var productID;
  @override
  void initState() {
    fetchidCommande();
  }

  fetchidCommande() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data()!;
      idCommande = userData['idCommande'];
      productID = userData['productID'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('Products')
          .where('id', isEqualTo: productID)
          .snapshots(),
      builder: (context, productSnapshot) {
        if (productSnapshot.hasError) {
          return Text('Error: ${productSnapshot.error}');
        }

        if (productSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (productSnapshot.hasData) {
          final productDocuments = productSnapshot.data!.docs;
          if (productDocuments.isNotEmpty) {
            final productData = productDocuments[0].data();
          }
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Commandes')
                  .where('idCommande', isEqualTo: idCommande)
                  .snapshots(),
              builder: (context, commandesnapshot) {
                if (commandesnapshot.hasError) {
                  return Text('Error: ${commandesnapshot.error}');
                }

                if (commandesnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (commandesnapshot.hasData) {
                  final commandeDocuments = commandesnapshot.data!.docs;
                  if (commandeDocuments.isNotEmpty) {
                    final commandeDta = commandeDocuments[0].data();
                  }
                  return Container();
                }
                return SizedBox();
              });
        }
        return SizedBox();
      },
    ));
  }
}
