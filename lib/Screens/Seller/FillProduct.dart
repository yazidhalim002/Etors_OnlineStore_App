import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Screens/Seller/AddProduct.dart';
import 'package:etors/Widget/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

int id = 1;

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
  String _displayimage = "";

  void Done() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Products').doc().set({
          'id': id,
          'name': _nameController.text.trim(),
          'price': _priceController.text.trim(),
          'description': _descriptionController.text.trim(),
          'size': _sizeController.text.trim(),
          'sold': _soldController.text.trim(),
          'color': _colorController.text.trim(),
          'uid': userCredential.uid.trim(),
          'image': _displayimage.trim(),
          'category': _selectedCategory
        });
        id++;
      } on FirebaseAuthException catch (e) {
        print(e);
      }
    }
  }

  String _selectedCategory = 'Men';

  final List<String> _categories = <String>[
    'Men',
    'Women',
    'Watch',
    'Device',
    'Gamming'
  ];

  Future uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });

    try {
      final reference = FirebaseStorage.instance
          .ref()
          .child('images/${basename(_image!.path)}');
      final uploadTask = reference.putFile(_image!);

      final snapshot = await uploadTask.whenComplete(() => null);

      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _displayimage = downloadUrl;
      });
    } catch (error) {
      print("Error uploading image: $error");
    }
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
                        child: _displayimage != ""
                            ? Image.network(_displayimage)
                            : const SizedBox()),
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
                      height: 7,
                    ),
                    InputText(
                      Controller: _nameController,
                      Text: "Product Name",
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    InputText(
                      Controller: _priceController,
                      Text: "Price",
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    InputText(
                      Controller: _descriptionController,
                      Text: "description",
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    InputText(
                      Controller: _sizeController,
                      Text: "Size",
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    InputText(
                      Controller: _colorController,
                      Text: "Color",
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    InputText(
                      Controller: _soldController,
                      Text: "Sold",
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: 350,
                      height: 58,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedCategory,
                        items: _categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                  ],
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductScreen(uid: userCredential.uid)));
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
