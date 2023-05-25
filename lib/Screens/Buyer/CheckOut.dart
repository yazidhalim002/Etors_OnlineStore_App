import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Classes/Product.dart';
import 'package:etors/Classes/Users.dart';
import 'package:etors/Screens/Buyer/OrderConfirmation.dart';
import 'package:etors/Service/CustomText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

String? _paymentMethod;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  void storeCommande() async {
    // Retrieve the address from the Users collection
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    // Extract the address from the user document
    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;
    if (userData != null) {
      Map<String, dynamic>? userAddress =
          userData['Address'] as Map<String, dynamic>?;

      // Store the address in the Commandes collection
      CollectionReference commandesCollection =
          FirebaseFirestore.instance.collection('Commandes');
      commandesCollection.doc().set({
        "Address": userAddress,
        "buyerID": FirebaseAuth.instance.currentUser!.uid
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              LineAwesomeIcons.angle_left,
              color: Colors.black,
            )),
        title: CustomText(
          text: "Payment Methode",
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Radio(
                value: "Cash on Delivery",
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value.toString();
                  });
                },
              ),
              Text('Cash on Delivery'),
            ],
          ),
          Row(
            children: [
              Radio(
                value: "Credit Card",
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value.toString();
                  });
                },
              ),
              Text('Credit Card'),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (_paymentMethod == 'Cash on Delivery') {
                storeCommande();
              } else if (_paymentMethod == 'Credit Card') {}
            },
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }
}
