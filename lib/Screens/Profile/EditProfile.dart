import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Service/CustomText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:path/path.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  String _displayimage = 'assets/icons/User.png';
  var _image;
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _FnameController = TextEditingController();
  final _LnameController = TextEditingController();
  final _UsernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserData();
  }

  Future _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });

    try {
      final reference = FirebaseStorage.instance
          .ref()
          .child('profile/${basename(_image!.path)}');
      final uploadTask = reference.putFile(_image!);

      final snapshot = await uploadTask.whenComplete(() => null);

      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _displayimage = downloadUrl;

        final userDocRef = FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({'image': _displayimage});
      });

      print(_displayimage);
    } catch (error) {
      print("Error uploading image: $error");
    }
  }

  void EditData() {
    setState(() async {
      final userDocRef =
          FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        'firstName': _FnameController.text,
        'lastName': _LnameController.text,
        'Username': _UsernameController.text,
        'Email': _emailController.text,
      });

// Update the password
      await user.updatePassword(_passwordController.text);
    });
  }

  void _fetchUserData() async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userData = await userDoc.get();
    final imageLink = userData.data()!['image'];

    if (imageLink == null) {
      setState(() {
        _displayimage = 'assets/icons/User.png';
      });
    } else {
      setState(() {
        _displayimage = imageLink;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                LineAwesomeIcons.angle_left,
                color: Colors.black,
              )),
          title: Padding(
            padding: const EdgeInsets.only(left: 88),
            child: CustomText(
              text: "Edit Profile",
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                    padding:
                        const EdgeInsets.only(top: 80, left: 25, right: 25),
                    child: Column(children: [
                      Column(children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: _displayimage != ''
                                    ? Image.network(
                                        _displayimage,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/icons/User.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _uploadImage();
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color:
                                          Color.fromARGB(255, 100, 136, 238)),
                                  child: const Icon(
                                    LineAwesomeIcons.camera,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Form(
                            child: Column(
                          children: [
                            InputText(
                              Controller: _FnameController,
                              Text: 'Firstname',
                              isPass: false,
                              icon: Icons.person_search,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputText(
                              Controller: _LnameController,
                              Text: 'Lastname',
                              isPass: false,
                              icon: Icons.person_search,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputText(
                              Controller: _UsernameController,
                              Text: 'Username',
                              isPass: false,
                              icon: Icons.person,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputText(
                              Controller: _emailController,
                              Text: 'Email',
                              isPass: false,
                              icon: Icons.mail,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputText(
                              Controller: _passwordController,
                              Text: 'Password',
                              isPass: true,
                              icon: Icons.fingerprint,
                            ),
                          ],
                        ))
                      ]),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfileScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 100, 136, 238),
                                side: BorderSide.none,
                                shape: StadiumBorder()),
                            child: const Text(
                              'Edit Profile',
                            )),
                      ),
                    ]))));
  }
}

class InputText extends StatelessWidget {
  const InputText({
    super.key,
    required this.Controller,
    required this.Text,
    this.isPass = false,
    required this.icon,
  });

  final TextEditingController Controller;
  final String Text;
  final bool isPass;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30),
      child: TextFormField(
        obscureText: isPass,
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
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 100, 136, 238))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }
}
