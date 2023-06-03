import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  final String buyerID; // Assuming you have the buyer ID

  AddressScreen({required this.buyerID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Commandes')
            .where('buyerID', isEqualTo: buyerID)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('Order not found');
          }

          final orderData =
              snapshot.data!.docs[0].data() as Map<String, dynamic>;
          final addressData = orderData['Address'] as Map<String, dynamic>;

          // Extract address fields
          final street = addressData['street'] as String;
          final city = addressData['city'] as String;
          final postalCode = addressData['postalCode'] as String;

          return ListTile(
            title: Text('Address Details'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Street: $street'),
                Text('City: $city'),
                Text('Postal Code: $postalCode'),
              ],
            ),
          );
        },
      ),
    );
  }
}
