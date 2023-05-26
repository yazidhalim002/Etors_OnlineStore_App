import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Classes/Cart.dart';
import 'package:etors/Classes/Product.dart';
import 'package:etors/Screens/Buyer/CartScreen.dart';
import 'package:etors/Screens/Buyer/CheckOut.dart';
import 'package:etors/Screens/Profile/DeliveryAdresse/DeliveryAdress.dart';
import 'package:etors/Service/CustomText.dart';
import 'package:etors/Service/Details_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

Cart? cart;
List<String> prodId = [];

class OrderConfirmation extends StatefulWidget {
  const OrderConfirmation({super.key});

  @override
  State<OrderConfirmation> createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  bool isChoosen = false;
  String Total_Amount = '0';
  String? paymentMethod;

  @override
  void initState() {
    super.initState();
    loadCartFromFirestore(FirebaseAuth
        .instance.currentUser!.uid); // Replace user.uid with the actual user ID
  }

  Future<void> loadCartFromFirestore(String userId) async {
    try {
      final cartCollection = FirebaseFirestore.instance.collection('Cart');
      final cartDocument = cartCollection.doc(userId);

      final cartSnapshot = await cartDocument.get();

      if (cartSnapshot.exists) {
        cart = Cart.fromFirestore(cartSnapshot);
      } else {
        cart = Cart(
          products: {},
          totalAmount: '',
        );
      }

      setState(() {}); // Trigger a rebuild to show the loaded cart
    } catch (e) {
      // Handle error
      print('Error loading cart from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
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
          text: "Order Confirmation",
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final addressData =
              snapshot.data!.get('Address') as Map<String, dynamic>?;

          if (addressData == null) {
            return const Center(
              child: Text('No address available.'),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(bottom: 70, right: 20, left: 10),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomText(
                            text: addressData['ContactName'] + "\n",
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomText(
                            text: addressData['PhoneNumber'] + "\n",
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomText(
                            text: addressData['Street'] + "\n",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomText(
                            text: addressData['City'] +
                                "," +
                                addressData['Province'] +
                                "," +
                                addressData['ZipCode'],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DeliveryAdresse()));
                              },
                              child: Text(
                                "Edit",
                                style: GoogleFonts.inconsolata(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 19),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    final productId = cart!.products.keys.toList()[index];

                    var productQuantity = cart!.products[productId];
                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Products')
                            .where('id', isEqualTo: int.parse(productId))
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Text('Product not found');
                          }

                          final productData = snapshot.data!.docs[0].data()
                              as Map<String, dynamic>;

                          final product =
                              Product.fromFirestore(snapshot.data!.docs[0]);
                          if (prodId.contains(productId)) {
                          } else {
                            prodId.add(productId);
                          }

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  height: 130,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        product.image,
                                        fit: BoxFit.contain,
                                        height: 100,
                                        width: 100,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 20),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: product.name,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    text: product.size == ""
                                                        ? "${product.color}"
                                                        : "${product.color},${product.size}",
                                                    color: Colors.grey.shade600,
                                                  ),
                                                  Text(
                                                    " x$productQuantity",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              CustomText(
                                                text: "US \$${product.price}",
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ]),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: cart!.products.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CustomText(
                          text: "TOTAL",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          text: "\$ $totalAmount",
                          color: const Color.fromRGBO(0, 197, 105, 1),
                          fontSize: 20,
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: 180,
                      height: 90,
                      child: CustomButton(
                        onPress: () {
                          print(prodId);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckoutScreen(
                                        prodIds: prodId,
                                      )));
                        },
                        text: "Checkout",
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
