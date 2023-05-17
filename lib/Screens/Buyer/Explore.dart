import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Classes/Product.dart';
import 'package:etors/Screens/Buyer/Categories.dart';
import 'package:etors/Service/Details_product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Service/CustomText.dart';

List<Product> allProducts = [];

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
              allProducts = Product.fromQuerySnapshot(products);
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
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListBestSellingProduct(),
                        SizedBox(
                          height: 500,
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: allProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, Index) {
            final product = allProducts[Index];
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsScreen(id: product.id)));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .4,
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            height: 220,
                            width: MediaQuery.of(context).size.width * .4,
                            child: Image.network(
                              product.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      text: product.name,
                      alignment: Alignment.bottomLeft,
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      text: product.description,
                      alignment: Alignment.bottomLeft,
                      color: Colors.grey,
                      maxLine: 1,
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      text: '${product.price} \$',
                      alignment: Alignment.bottomLeft,
                      color: Color.fromARGB(255, 100, 136, 238),
                    )
                  ],
                ),
              ),
            );
          }),
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryScreen(
                                  categoryname: names[Index],
                                )));
                  },
                  child: Container(
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
