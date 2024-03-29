import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Service/BottomNavigationBar.dart';
import 'package:etors/Service/auth.dart';
import 'package:etors/Widget/CheckScreen.dart';
import 'package:etors/Widget/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final Color color = Color.fromARGB(255, 100, 136, 238);

  Future<String?> getType(String email) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    return doc.get('Type');
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

//NEED TO REVIEW THE PAGE

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CheckScreen()));
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'WARNING!',
          message: 'the email or the password may incorrect',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      Navigator.of(context).pushReplacementNamed('Login');
    }
  }

  void openSignupScreen() {
    Navigator.of(context).pushReplacementNamed('Signup');
  }

  void ForgotPasswordScreen() {
    Navigator.of(context).pushReplacementNamed('forgot');
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 100, 136, 238),
          ),
          height: 270,
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                InputText(
                  Controller: emailController,
                  Text: 'Email',
                  isPass: false,
                ),
                const SizedBox(
                  height: 35,
                ),
                InputText(
                  Controller: passwordController,
                  Text: 'Password',
                  isPass: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 20)),
                    RecButton(
                      title: 'Sign up',
                      color: color,
                      fct: openSignupScreen,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    RecButton(
                      title: 'Login',
                      color: Color.fromARGB(255, 150, 100, 130),
                      fct: signIn,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 130,
                      child: Divider(
                        thickness: 3,
                        endIndent: 0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Sign up with',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      child: Divider(
                        thickness: 3,
                        indent: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    CircularButton(
                      backcolor: Colors.white70,
                      image: 'assets/GOOGLE.png',
                      fct: () {
                        AuthService().GoogleSignInMethode();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckScreen()));
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    CircularButton(
                      backcolor: Colors.black,
                      image: 'assets/FACEBOOK.png',
                      fct: () {},
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        AuthService().OTP();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Color.fromARGB(255, 226, 226, 226)),
                      child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(132, 63, 63, 63),
                                spreadRadius: 0,
                                blurRadius: 120)
                          ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/cell-phone.png',
                              height: 30,
                              width: 30,
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class CircularButton extends StatelessWidget {
  const CircularButton({
    super.key,
    required this.image,
    required this.backcolor,
    required this.fct,
  });

  final String image;
  final Color backcolor;
  final Function fct;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        fct();
      },
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(), backgroundColor: backcolor),
      child: Container(
        child: Image.asset(
          image,
          height: 60,
          width: 60,
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
