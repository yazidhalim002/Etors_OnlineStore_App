import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Classes/Product.dart';
import 'package:etors/Classes/Users.dart';
import 'package:etors/Models/card_alert_dialog.dart';
import 'package:etors/Screens/Buyer/Explore.dart';
import 'package:etors/Screens/Buyer/OrderConfirmation.dart';
import 'package:etors/Screens/Buyer/AddCard.dart';
import 'package:etors/Screens/Seller/FillProduct.dart';
import 'package:etors/Service/BottomNavigationBar.dart';
import 'package:etors/Service/CustomText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

String? _paymentMethod;
int id = 1;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.prodIds,
  });

  final List<String> prodIds;
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Future<void> saveCartToFirestore(String userId) async {
    try {
      final cartCollection = FirebaseFirestore.instance.collection('Cart');
      final cartDocument = cartCollection.doc(userId);

      await cartDocument.set(cart!.toFirestore());
    } catch (e) {
      // Handle error
      print('Error saving cart to Firestore: $e');
    }
  }

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
      commandesCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
        'idCommande': id,
        "Address": userAddress,
        "buyerID": FirebaseAuth.instance.currentUser!.uid,
        "products": widget.prodIds,
        "Delivered": false,
      });
      id++;
    }
  }

  void clearCart() {
    if (cart != null) {
      cart!.products.clear();
      saveCartToFirestore(FirebaseAuth.instance.currentUser!.uid);
      setState(() {}); // Trigger a rebuild to reflect the changes
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
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => const CardAlertDialog());
                clearCart();
              } else if (_paymentMethod == 'Credit Card') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddCard()));
              }
            },
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }
}
