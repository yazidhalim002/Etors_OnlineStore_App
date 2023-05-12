import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Screens/Buyer/Explore.dart';
import 'package:etors/Screens/Seller/FillProduct.dart';
import 'package:etors/Service/CustomText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatefulWidget {
  final String uid;

  const ProductScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('Products')
              .where('uid', isEqualTo: widget.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              final products = snapshot.data!.docs;
              return Stack(children: [
                SafeArea(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(350, 0, 0, 0),
                          ),
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.plus,
                              size: 25,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FillProduct()));
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomText(
                          text: "Your Products",
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      ListProduct(
                        products: products,
                      )
                    ],
                  ),
                ),
              ]);
            }
          },
        ),
      ),
    );
  }
}

class ListProduct extends StatelessWidget {
  const ListProduct({
    super.key,
    required this.products,
  });

  final List<QueryDocumentSnapshot> products;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, Index) {
            final product = products[Index].data() as Map<String, dynamic>;
            return Padding(
              padding: EdgeInsets.all(8),
              child: InkWell(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width * .4,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey.shade200),
                        child: Column(
                          children: [
                            Container(
                              height: 220,
                              width: MediaQuery.of(context).size.width * .4,
                              child: Image.network(
                                product['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomText(
                        text: product['name'],
                        alignment: Alignment.bottomLeft,
                      ),
                      SizedBox(height: 10),
                      CustomText(
                        text: product['description'],
                        alignment: Alignment.bottomLeft,
                        color: Colors.grey,
                        maxLine: 1,
                      ),
                      SizedBox(height: 10),
                      CustomText(
                        text: '${product['price']} \$',
                        alignment: Alignment.bottomLeft,
                        color: Color.fromARGB(255, 100, 136, 238),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                width: 25,
              )),
    );
  }
}
