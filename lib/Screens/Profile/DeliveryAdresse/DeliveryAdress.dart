import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Service/CustomText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class DeliveryAdresse extends StatefulWidget {
  const DeliveryAdresse({super.key});

  @override
  State<DeliveryAdresse> createState() => _DeliveryAdresseState();
}

class _DeliveryAdresseState extends State<DeliveryAdresse> {
  final _form1 = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();
  final _contactnameController = TextEditingController();
  final _phonenumController = TextEditingController();
  final _streetController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipcodeController = TextEditingController();
  bool _isDefault = true;
  User? user = FirebaseAuth.instance.currentUser!;

  void Save() async {
    if (_form1.currentState!.validate() && _form2.currentState!.validate()) {
      try {
        Map<String, dynamic> address = {
          'ContactName': _contactnameController.text.trim(),
          'PhoneNumber': _phonenumController.text.trim(),
          'Street': _streetController.text.trim(),
          'Province': _provinceController.text.trim(),
          'City': _cityController.text.trim(),
          'ZipCode': _zipcodeController.text.trim(),
        };

        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');

        await usersCollection.doc(user!.uid).update({'Address': address});

        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
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
            text: "Add New Address",
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Form(
                          key: _form1,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              padding: const EdgeInsets.only(top: 20, left: 10),
                              height: 260,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(223, 254, 254, 254)),
                              child: Column(
                                children: [
                                  CustomText(
                                    text: "Personal information",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Input(
                                      Controller: _contactnameController,
                                      Text: "Contact Name*"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: CustomText(
                                      text: "Please enter a Contact Name",
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Input(
                                      Controller: _phonenumController,
                                      Text: "Mobile Number*"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: CustomText(
                                      text: "Please enter mobile phone number",
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Form(
                          key: _form2,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              padding: const EdgeInsets.only(top: 15, left: 10),
                              height: 409,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(223, 254, 254, 254)),
                              child: Column(
                                children: [
                                  CustomText(
                                    text: "Address",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Input(
                                      Controller: _streetController,
                                      Text: "Street, house/apartment/unit*"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Input(
                                      Controller: _provinceController,
                                      Text: "Province*"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Input(
                                      Controller: _cityController,
                                      Text: "City*"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Input(
                                      Controller: _zipcodeController,
                                      Text: "Zipcode*"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          Save();
                        },
                        child: Text("Save"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color.fromARGB(255, 100, 136, 238)),
                      ))
                ],
              )
            ],
          ),
        ));
  }
}

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.Controller,
    required this.Text,
  });
  final TextEditingController Controller;
  final String Text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: Controller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your $Text';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: Text,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }
}
