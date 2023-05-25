import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Classes/Product.dart';
import 'package:etors/Models/Colors.dart';
import 'package:etors/Service/CustomText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

double Total_Amount = 0;

class DetailsScreen extends StatefulWidget {
  final int id;
  const DetailsScreen({super.key, required this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  User user = FirebaseAuth.instance.currentUser!;

  Future<void> addToCart(Product product) async {
    try {
      final cartCollection = FirebaseFirestore.instance.collection('Cart');
      final cartDocument = cartCollection
          .doc(user.uid); // Replace 'your_user_id' with the actual user ID

      final cartSnapshot = await cartDocument.get();

      if (cartSnapshot.exists) {
        // Cart exists, update the product quantity
        cartDocument.update({
          'products.${product.id}': FieldValue.increment(1),
          'totalAmount': Total_Amount.toString(),
        });
      } else {
        // Cart does not exist, create a new cart
        cartDocument.set({
          'products': {
            product.id.toString(): 1,
          },
          'totalAmount': Total_Amount.toString(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added to cart.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding product to cart.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Products')
            .where('id', isEqualTo: widget.id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Text('No products found with widget ID: ${widget.id}');
          }

          return Stack(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final productData = document.data() as Map<String, dynamic>;
              Color selectedColor =
                  colorMap[productData['color'].toLowerCase()] ?? Colors.black;
              return Container(
                  child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 270,
                    child: Image.network(
                      productData['image'],
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Divider(
                    thickness: 5,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            CustomText(
                              text: productData['name'],
                              fontSize: 26,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            productData['category'] != "Device" &&
                                    productData['category'] != "Gamming"
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            CustomText(
                                              text: 'Size :',
                                            ),
                                            CustomText(
                                              text: productData['size'],
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            CustomText(
                                              text: 'Color :',
                                            ),
                                            Container(
                                              height: 30,
                                              width: 30,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: selectedColor),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            CustomText(
                                              text: 'Color :',
                                            ),
                                            Container(
                                              height: 30,
                                              width: 30,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: selectedColor),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                productData['sold'] != 0
                                    ? Container(
                                        child: Row(
                                          children: [
                                            CustomText(
                                              text:
                                                  'Limited quantity available / ',
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            CustomText(
                                              text:
                                                  '${productData['sold']} Sold',
                                              color: Colors.red,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        child: CustomText(
                                          text: "Out of Stock",
                                          color: Colors.red,
                                        ),
                                      )
                              ],
                            ),
                            SizedBox(height: 20),
                            CustomText(
                              text: 'Details',
                              fontSize: 20,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            CustomText(
                              text: productData['description'],
                              height: 2.5,
                              maxLine: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            CustomText(
                              text: "PRICE",
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              text: '\$ ' + productData['price'],
                              color: Color.fromRGBO(0, 197, 105, 1),
                              fontSize: 18,
                            )
                          ],
                        ),
                        Container(
                            width: 180,
                            height: 50,
                            child: CustomButton(
                                text: "Add to Cart",
                                onPress: () {
                                  if (snapshot.hasData &&
                                      snapshot.data!.docs.isNotEmpty) {
                                    final productData =
                                        snapshot.data!.docs.first.data()
                                            as Map<String, dynamic>;
                                    final product = Product.fromFirestore(
                                        snapshot.data!.docs.first);
                                    addToCart(product);
                                    Total_Amount = Total_Amount +
                                        double.parse(product.price);

                                    print(Total_Amount);
                                  }
                                }))
                      ],
                    ),
                  )
                ],
              ));
            }).toList(),
          );
        },
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;

  final Color color;

  final Function() onPress;

  CustomButton({
    required this.onPress,
    this.text = '',
    this.color = const Color.fromRGBO(0, 197, 105, 1),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          backgroundColor: color),
      child: CustomText(
        alignment: Alignment.center,
        text: text,
        color: Colors.white,
        fontSize: 17,
      ),
    );
  }
}
