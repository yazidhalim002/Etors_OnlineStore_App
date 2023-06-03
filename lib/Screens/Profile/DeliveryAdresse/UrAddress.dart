import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Screens/Profile/DeliveryAdresse/DeliveryAdress.dart';
import 'package:etors/Service/CustomText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UrAddress extends StatefulWidget {
  const UrAddress({Key? key}) : super(key: key);

  @override
  State<UrAddress> createState() => _UrAddressState();
}

class _UrAddressState extends State<UrAddress> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isExist = false;

  void function() {
    final commandesRef = FirebaseFirestore.instance.collection('users');
    final userCommandeDocRef = commandesRef.doc(user!.uid);

    userCommandeDocRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        setState(() {
          isExist = true;
        });
      } else {
        setState(() {
          isExist = false;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    function();
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
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Your Address",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: isExist == true
          ? StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
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
                                    padding: EdgeInsets.only(
                                        bottom: 70, right: 20, left: 10),
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                    Row(
                      children: [
                        Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DeliveryAdresse()));
                              },
                              child: addressData.length >= 1
                                  ? Text("Edit Address")
                                  : Text("Add Address"),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 100, 136, 238)),
                            ))
                      ],
                    )
                  ],
                );
              },
            )
          : Column(
              children: [
                Expanded(child: Container()),
                Row(
                  children: [
                    Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DeliveryAdresse()));
                          },
                          child: Text("Add Address"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 100, 136, 238)),
                        ))
                  ],
                ),
              ],
            ),
    );
  }
}
