import 'package:etors/Widget/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void signout() async {
    FirebaseAuth.instance.signOut();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(),
                IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.bell))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 100, 136, 238),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Balance",
                        style: GoogleFonts.inconsolata(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 26),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("10 \$",
                              style: GoogleFonts.inconsolata(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30)),
                          Row(
                            children: [
                              Text("Withdraw",
                                  style: GoogleFonts.inconsolata(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 26)),
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300),
                                  child: Icon(LineAwesomeIcons.angle_right),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Text("On Hold",
                          style: GoogleFonts.inconsolata(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 26)),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30, top: 10),
                      child: Text("0 \$",
                          style: GoogleFonts.inconsolata(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 26)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text("Copyrights by Etors",
                              style: GoogleFonts.inconsolata(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 150, 100, 130),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          "Commandes",
                          style: GoogleFonts.inconsolata(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 26),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 40,
                            ),
                            child: Text(
                              "0",
                              style: GoogleFonts.inconsolata(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40, right: 10),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade300),
                                child: Icon(LineAwesomeIcons.angle_right),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
