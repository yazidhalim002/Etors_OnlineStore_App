import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cart {
  final Map<String, int> products;
  final String totalAmount;

  Cart({required this.products, required this.totalAmount});

  factory Cart.fromFirestore(DocumentSnapshot doc) {
    Map<dynamic, dynamic> data = doc.data() as Map<dynamic, dynamic>;
    Map<String, int> products = {};

    if (data['products'] != null) {
      data['products'].forEach((key, value) {
        products[key] = value;
      });
    }

    String totalAmount = data['totalAmount'] ?? '0';

    return Cart(products: products, totalAmount: totalAmount);
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> data = {};

    data['products'] = products;
    data['totalAmount'] = totalAmount;

    return data;
  }

  Future<void> saveToFirestore(String userId) async {
    try {
      final cartCollection = FirebaseFirestore.instance.collection('carts');
      final cartDocument = cartCollection.doc(userId);

      await cartDocument.set(toFirestore());
    } catch (e) {
      // Handle error
      print('Error saving cart to Firestore: $e');
    }
  }
}
