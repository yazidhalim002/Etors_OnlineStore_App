import 'package:etors/Classes/Product.dart';
import 'package:etors/Screens/Seller/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../Service/CustomText.dart';

var productID = 0;

class SellerOrderScreen extends StatefulWidget {
  final String sellerId;

  SellerOrderScreen({required this.sellerId});

  @override
  _SellerOrderScreenState createState() => _SellerOrderScreenState();
}

class _SellerOrderScreenState extends State<SellerOrderScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ordered Products'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: SellerProdId.length,
        itemBuilder: (context, index) {
          productID = SellerProdId[index];
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('Commandes')
                .where('products', arrayContains: productID.toString())
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

              if (snapshot.hasData) {
                final documents = snapshot.data!.docs;
                if (documents.isNotEmpty) {
                  final commandData = documents[0].data();
                  final addressInfo = commandData['Address'];
                  final idCommande = commandData['idCommande'];

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Products')
                        .where('id', isEqualTo: productID)
                        .snapshots(),
                    builder: (context, productSnapshot) {
                      if (productSnapshot.hasError) {
                        return Text('Error: ${productSnapshot.error}');
                      }

                      if (productSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (productSnapshot.hasData) {
                        final productDocuments = productSnapshot.data!.docs;
                        if (productDocuments.isNotEmpty) {
                          final productData = productDocuments[0].data();

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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          CustomText(
                                            text: productData['name'],
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          CustomText(
                                            text: productData['color'],
                                            maxLine: 1,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Delivery(
                                                                      idCommande,
                                                                      productID)));
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape:
                                                            const StadiumBorder(),
                                                        backgroundColor: Colors
                                                            .red.shade400),
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 70,
                                                      child: Center(
                                                          child: Text(
                                                        "Delivery",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 13),
                                                      )),
                                                    )),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ViewDetails(
                                                                      addressInfo)));
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape:
                                                            const StadiumBorder(),
                                                        backgroundColor: Colors
                                                            .red.shade400),
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 70,
                                                      child: Center(
                                                          child: Text(
                                                        "View Details",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 11),
                                                      )),
                                                    )),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }

                      return const ListTile(
                        title: Text('Product not found'),
                      );
                    },
                  );
                }
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }

  Widget ViewDetails(dynamic addressInfo) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(
            LineAwesomeIcons.angle_left,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 110,
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
                              text: addressInfo['ContactName'] + "\n",
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              text: addressInfo['PhoneNumber'] + "\n",
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              text: addressInfo['Street'] + "\n",
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              text: addressInfo['City'] +
                                  "," +
                                  addressInfo['Province'] +
                                  "," +
                                  addressInfo['ZipCode'],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot>? documentsStream;

  void getDocuments() {
    setState(() {
      documentsStream = FirebaseFirestore.instance
          .collection('users')
          .where('available', isEqualTo: true)
          .where('Type', isEqualTo: "Livreur")
          .snapshots();
    });
  }

  Widget Delivery(int idCommande, var productID) {
    print(idCommande);
    return Scaffold(
        appBar: AppBar(
          title: Text('Delivery'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('available', isEqualTo: true)
              .where('Type', isEqualTo: 'Livreur')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final users = snapshot.data?.docs ?? [];

            if (users.isEmpty) {
              return Text('No users found.');
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final userData = users[index].data() as Map<String, dynamic>;

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 100, 136, 238)),
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: userData['image'] != ''
                                ? Image.network(
                                    userData['image'],
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/icons/User.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          CustomText(
                            text: userData['Username'],
                            fontSize: 18,
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: RecButton(
                          title: "Choose",
                          color: Colors.red.shade400,
                          fct: () {
                            setState(() async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userData['uid'])
                                  .update({
                                'available': false,
                                'idCommande': idCommande,
                                'productID': productID
                              });
                            });
                          },
                        ),
                      )
                    ]),
                  ),
                );
              },
            );
          },
        ));
  }
}

class RecButton extends StatelessWidget {
  const RecButton({
    super.key,
    required this.title,
    required this.color,
    required this.fct,
  });

  final String title;
  final Color color;
  final Function fct;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          fct();
        },
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(), backgroundColor: color),
        child: SizedBox(
          height: 40,
          width: 100,
          child: Center(
              child: Text(
            title,
            style: GoogleFonts.poppins(fontSize: 20),
          )),
        ));
  }
}
