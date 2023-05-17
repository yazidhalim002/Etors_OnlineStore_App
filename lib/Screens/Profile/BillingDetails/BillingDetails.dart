import 'package:etors/Screens/Profile/BillingDetails/AddCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class BillingDetails extends StatefulWidget {
  const BillingDetails({super.key});

  @override
  State<BillingDetails> createState() => _BillingDetailsState();
}

class _BillingDetailsState extends State<BillingDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
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
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(190, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(132, 63, 63, 63),
                          spreadRadius: 1,
                          blurRadius: 10)
                    ]),
                child: Stack(children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddCard()));
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white.withOpacity(0.5)),
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 2,
              endIndent: 25,
              indent: 25,
            ),
          ],
        ),
      ),
    );
  }
}

class CreditCard extends StatelessWidget {
  const CreditCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 11),
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 11, 21, 5),
          width: 335,
          height: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(112, 117, 117, 117),
                    spreadRadius: 1,
                    blurRadius: 10)
              ]),
        ),
      ),
    );
  }
}
