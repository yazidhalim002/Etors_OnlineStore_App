import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Widget/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class FillProduct extends StatefulWidget {
  const FillProduct({super.key});

  @override
  State<FillProduct> createState() => _FillProductState();
}

class _FillProductState extends State<FillProduct> {
  final _formKey = GlobalKey<FormState>();
  final userCredential = FirebaseAuth.instance.currentUser!;
  final Color color = Color.fromARGB(255, 100, 136, 238);
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sizeController = TextEditingController();
  final _colorController = TextEditingController();
  final _soldController = TextEditingController();
  var _image;
  //this link is display a white background
  //when the user choose product image the system will display whitebackground until do the process of upload the image in the firebase storage and get the link
  String _displayimage = "https://www.ledr.com/colours/white.htm";

  void Done() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Products').doc().set({
          'name': _nameController.text,
          'price': _priceController.text,
          'description': _descriptionController.text,
          'size': _sizeController.text,
          'sold': _soldController.text,
          'color': _colorController.text,
          'uid': userCredential.uid,
          'image': _displayimage,
        });
      } on FirebaseAuthException catch (e) {
        print(e);
      }
    }
  }

  Future uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });

    final reference = FirebaseStorage.instance
        .ref()
        .child('images/${basename(_image!.path)}');
    final uploadTask = reference.putFile(_image!);

    final snapshot = await uploadTask.whenComplete(() => null);

    final downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      _displayimage = downloadUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      height: 150,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: _image != null
                          ? Image.network(_displayimage)
                          : Image.asset(
                              'assets/white.jpg',
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: uploadImage,
                        style: ElevatedButton.styleFrom(backgroundColor: color),
                        child: SizedBox(
                          height: 50,
                          width: 200,
                          child: Center(
                              child: Text(
                            "Upload Image",
                            style: GoogleFonts.poppins(fontSize: 23),
                          )),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    InputText(
                      Controller: _nameController,
                      Text: "Product Name",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputText(
                      Controller: _priceController,
                      Text: "Price",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputText(
                      Controller: _descriptionController,
                      Text: "description",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputText(
                      Controller: _sizeController,
                      Text: "Size",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputText(
                      Controller: _colorController,
                      Text: "Color",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputText(
                      Controller: _soldController,
                      Text: "Sold",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    RecButton(
                        title: "Back",
                        color: color,
                        fct: () {
                          Navigator.pop(context);
                        }),
                    RecButton(
                        title: "Done",
                        color: Color.fromARGB(255, 150, 100, 130),
                        fct: () {
                          Done();
                        }),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
