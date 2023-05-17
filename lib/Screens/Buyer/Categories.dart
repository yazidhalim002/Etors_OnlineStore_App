import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Screens/Buyer/Explore.dart';
import 'package:etors/Service/CustomText.dart';
import 'package:etors/Service/Details_product.dart';
import 'package:flutter/material.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Classes/Product.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryname;
  const CategoryScreen({
    super.key,
    required this.categoryname,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Product> products = [];
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LineAwesomeIcons.angle_left,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomText(
                text: widget.categoryname,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
                fontSize: 30,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 150,
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: allProducts
                      .where(
                          (product) => product.category == widget.categoryname)
                      .length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, Index) {
                    final List<Product> categoryProducts = allProducts
                        .where((product) =>
                            product.category == widget.categoryname)
                        .toList();
                    final product = categoryProducts[Index];

                    return product.category == widget.categoryname
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreen(id: product.id)));
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .4,
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
                          )
                        : SizedBox();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
