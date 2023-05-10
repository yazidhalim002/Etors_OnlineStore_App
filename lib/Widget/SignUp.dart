import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Widget/CheckScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _FnameController = TextEditingController();
  final _LnameController = TextEditingController();
  final _UsernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();
  late String _isSeller = "Acheteur";

  final Color color = Color.fromARGB(255, 100, 136, 238);

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CheckScreen()));
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'Username': _UsernameController.text,
          'firstName': _FnameController.text,
          'lastName': _LnameController.text,
          'Email': _emailController.text,
          'Type': _isSeller,
        });
      } on FirebaseAuthException catch (e) {
        // Handle the error
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 100, 136, 238),
          ),
          height: 230,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Center(
              child: Image.asset(
                'assets/logobg.png',
                height: 300,
                width: 300,
              ),
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InputText(
                            Controller: _FnameController,
                            Text: 'FirstName',
                            isPass: false),
                      ),
                      Expanded(
                        child: InputText(
                            Controller: _LnameController,
                            Text: 'LastName',
                            isPass: false),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputText(
                    Controller: _UsernameController,
                    Text: 'Username',
                    isPass: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputText(
                    Controller: _emailController,
                    Text: 'Email',
                    isPass: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputText(
                    Controller: _passwordController,
                    Text: 'Password',
                    isPass: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputText(
                    Controller: _confirmpasswordcontroller,
                    Text: 'Confirm Password',
                    isPass: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: "Acheteur",
                            groupValue: _isSeller,
                            onChanged: (value) {
                              setState(() {
                                _isSeller = value.toString();
                              });
                            },
                          ),
                          Text('Acheteur'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "Vendeur",
                            groupValue: _isSeller,
                            onChanged: (value) {
                              setState(() {
                                _isSeller = value.toString();
                              });
                            },
                          ),
                          Text('Vendeur'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "Livreur",
                            groupValue: _isSeller,
                            onChanged: (value) {
                              setState(() {
                                _isSeller = value.toString();
                              });
                            },
                          ),
                          Text('Livreur'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      RecButton(
                        title: 'Sign up',
                        color: color,
                        fct: submitForm,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      RecButton(
                        title: 'Login',
                        color: Color.fromARGB(255, 150, 100, 130),
                        fct: () {
                          Navigator.of(context).pushReplacementNamed('Login');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class InputText extends StatelessWidget {
  const InputText({
    super.key,
    required this.Controller,
    required this.Text,
    this.isPass = false,
  });

  final TextEditingController Controller;
  final String Text;
  final bool isPass;

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
          height: 50,
          width: 150,
          child: Center(
              child: Text(
            title,
            style: GoogleFonts.poppins(fontSize: 23),
          )),
        ));
  }
}
