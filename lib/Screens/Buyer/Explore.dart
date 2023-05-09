import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Classes/Product.dart';
import 'package:etors/Widget/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../Service/CustomText.dart';

Stream<QuerySnapshot> getProductsStream() {
  return FirebaseFirestore.instance.collection('Products').snapshots();
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<String> names = <String>[
    'Men',
    'Women',
    'Watch',
    'Device',
    'Gamming'
  ];
  final List<String> image = <String>[
    'assets/Categories/Men.png',
    'assets/Categories/Women.png',
    'assets/Categories/Watch.png',
    'assets/Categories/smartphone.png',
    'assets/Categories/console.png'
  ];

  final Color color = Color.fromARGB(255, 100, 136, 238);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('Products').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              final products = snapshot.data!.docs;
              return Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 80, right: 20, left: 20),
                    child: Column(
                      children: [
                        const SearchBar(),
                        const SizedBox(height: 20),
                        CustomText(
                          text: "Categories",
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        const SizedBox(height: 20),
                        _ListCategories(
                          names: names,
                          image: image,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Best Selling",
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            InkWell(
                              onTap: () {},
                              child: CustomText(
                                text: "See All",
                                fontSize: 16,
                                textDecoration: TextDecoration.underline,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListBestSellingProduct(
                          products: products,
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    ));
  }
}

class ListBestSellingProduct extends StatelessWidget {
  const ListBestSellingProduct({
    super.key,
    required this.products,
  });

  final List<QueryDocumentSnapshot> products;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, Index) {
            final product = products[Index].data() as Map<String, dynamic>;
            return Container(
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
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                width: 25,
              )),
    );
  }
}

class _ListCategories extends StatelessWidget {
  const _ListCategories({
    super.key,
    required this.names,
    required this.image,
  });

  final List<String> names;
  final List<String> image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: names.length,
          itemBuilder: (context, Index) {
            return Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey.shade200),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      image[Index],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomText(
                  text: names[Index],
                )
              ],
            );
          },
          separatorBuilder: (context, index) => SizedBox(
                width: 25,
              )),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey.shade200),
      child: TextFormField(
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            FontAwesomeIcons.search,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getProductsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        List<Product> products = [];

        snapshot.data!.docs.forEach((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

          String name = data['name'];
          String description = data['description'];
          String image = data['image'];
          String price = data['price'];
          String color = data['color'];
          String size = data['size'];

          Product product = Product(
            name: name,
            description: description,
            image: image,
            price: price,
            color: color,
            size: size,
          );

          products.add(product);
        });
        return Container();
      },
    );
  }
}
