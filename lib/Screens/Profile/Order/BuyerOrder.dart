import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderedProductsScreen extends StatefulWidget {
  OrderedProductsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderedProductsScreen> createState() => _OrderedProductsScreenState();
}

class _OrderedProductsScreenState extends State<OrderedProductsScreen> {
  String userUID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ordered Products'),
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Commandes')
            .doc(userUID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data?.data();
          final products = data?['products'] as List<dynamic>?;

          if (products == null || products.isEmpty) {
            return Center(
              child: Text('No ordered products found.'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final productID = products[index];
              print(productID);
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Products')
                    .where('id', isEqualTo: int.parse(productID))
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final productDocs = snapshot.data?.docs;

                  if (productDocs == null || productDocs.isEmpty) {
                    return Text('Product not found.');
                  }

                  final productData = productDocs[0].data();

                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(0, 5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 130,
                            width: 140,
                            child: Image.network(
                              productData['image'],
                              fit: BoxFit.contain,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    productData['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    productData['color'],
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                      ),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            shape: const StadiumBorder(),
                                            backgroundColor:
                                                Colors.red.shade400,
                                          ),
                                          child: SizedBox(
                                            height: 40,
                                            width: 70,
                                            child: Center(
                                              child: Text(
                                                "Track",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
