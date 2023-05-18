import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Service/CustomText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Classes/Cart.dart';
import '../../Classes/Product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, int> productCounters = {};
  double Total_Amount = 0, initialPrice = 0;
  int counter = 1;
  Cart? cart;
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
        });
      } else {
        // Cart does not exist, create a new cart
        cartDocument.set({
          'products': {
            product.id.toString(): 1,
          },
        });
      }
      loadCartFromFirestore(user.uid);
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFromCart(Product product) async {
    try {
      final cartCollection = FirebaseFirestore.instance.collection('Cart');
      final cartDocument = cartCollection
          .doc(user.uid); // Replace 'your_user_id' with the actual user ID

      final cartSnapshot = await cartDocument.get();

      if (cartSnapshot.exists) {
        // Cart exists, update the product quantity
        cartDocument.update({
          'products.${product.id}': FieldValue.increment(-1),
        });
      } else {
        // Cart does not exist, create a new cart
        cartDocument.set({
          'products': {
            product.id.toString(): 1,
          },
        });
      }

      loadCartFromFirestore(user.uid);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadCartFromFirestore(user.uid); // Replace user.uid with the actual user ID
  }

  Future<void> loadCartFromFirestore(String userId) async {
    try {
      final cartCollection = FirebaseFirestore.instance.collection('Cart');
      final cartDocument = cartCollection.doc(userId);

      final cartSnapshot = await cartDocument.get();

      if (cartSnapshot.exists) {
        cart = Cart.fromFirestore(cartSnapshot);

        if (cart != null) {
          for (var productId in cart!.products.keys) {
            final productQuantity = cart!.products[productId] ?? 0;
            productCounters[productId] = productQuantity;
          }
        }
      } else {
        // Cart does not exist, create a new cart
        cart = Cart(products: {});
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
              onPressed: clearCart,
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
              ))
        ],
      ),
      body: SafeArea(
        child: cart != null && cart!.products.isNotEmpty
            ? ListView.separated(
                itemCount: cart!.products.length,
                itemBuilder: (context, index) {
                  final productId = cart!.products.keys.toList()[index];
                  var productQuantity = cart!.products[productId];

                  // Fetch the product details from Firestore
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

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('Product not found');
                      }

                      final productData =
                          snapshot.data!.docs[0].data() as Map<String, dynamic>;

                      final product =
                          Product.fromFirestore(snapshot.data!.docs[0]);

                      return Container(
                        height: 140,
                        child: Row(children: [
                          Container(
                            width: 140,
                            child: Image.network(product.image),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  fontSize: 20,
                                  text: product.name,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                CustomText(
                                  color: Color.fromRGBO(0, 197, 105, 1),
                                  text: "\$ " + product.price,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: Colors.grey.shade200,
                                  child: Row(children: [
                                    IconButton(
                                        onPressed: () {
                                          addToCart(product);
                                          setState(() {
                                            initialPrice =
                                                double.parse(product.price) *
                                                    productQuantity!;
                                          });
                                        },
                                        icon: const Icon(Icons.add)),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    CustomText(
                                      text: "${productQuantity}",
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          if (productQuantity! > 1) {
                                            removeFromCart(product);
                                            setState(() {
                                              initialPrice =
                                                  double.parse(product.price) *
                                                      productQuantity;
                                            });
                                          }
                                        },
                                        icon:
                                            const Icon(LineAwesomeIcons.minus)),
                                  ]),
                                )
                              ],
                            ),
                          )
                        ]),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 30,
                  );
                },
              )
            : const Center(
                child: Text('Your cart is empty.'),
              ),
      ),
    );
  }

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

  void clearCart() {
    if (cart != null) {
      cart!.products.clear();
      saveCartToFirestore(user.uid);
      setState(() {}); // Trigger a rebuild to reflect the changes
    }
  }
}
