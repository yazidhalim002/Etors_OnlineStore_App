import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etors/Screens/Buyer/OrderConfirmation.dart';
import 'package:etors/Screens/Profile/BillingDetails/ContactUs.dart';
import 'package:etors/Screens/Profile/DeliveryAdresse/DeliveryAdress.dart';
import 'package:etors/Screens/Profile/DeliveryAdresse/UrAddress.dart';
import 'package:etors/Screens/Profile/EditProfile.dart';
import 'package:etors/Screens/Profile/FAQ.dart';
import 'package:etors/Screens/Profile/Order/BuyerOrder.dart';
import 'package:etors/Screens/Profile/Order/SellerOrder.dart';
import 'package:etors/Screens/Seller/Dashboard.dart';
import 'package:etors/Service/CustomText.dart';
import 'package:etors/Service/auth.dart';
import 'package:etors/Widget/CheckScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _displayimage = 'assets/icons/User.png';
  bool _isLoading = true;

  final user = FirebaseAuth.instance.currentUser!;

  var _image;

  String _firstname = '';
  String _lastname = '';
  String _email = '';
  String _userType = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserData();
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
      _firstname = userData.data()!['firstName'];
      _lastname = userData.data()!['lastName'];
      _email = userData.data()!['Email'];
      _userType = userData.data()!['Type'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: CustomText(
          text: "Profile",
          fontSize: 20,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon,
                color: isDark ? Colors.white : Colors.black,
              ))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    Column(
                      children: [
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
                          ],
                        ),
                        const SizedBox(height: 10),
                        _firstname != '' && _lastname != ''
                            ? Text(
                                _firstname + ' ' + _lastname,
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            : Text('${user.displayName}',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(_email, style: GoogleFonts.poppins()),
                        const SizedBox(height: 10),
                      ],
                    ),
                    SizedBox(
                      height: 45,
                      width: 200,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfileScreen()));
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
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    ProfileMenuWidget(
                        title: 'Orders',
                        icon: LineAwesomeIcons.box,
                        onPressed: () {
                          if (_userType == "Acheteur") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OrderedProductsScreen()));
                          } else if (_userType == "Vendeur") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SellerOrderScreen(
                                        sellerId: FirebaseAuth
                                            .instance.currentUser!.uid)));
                          }
                        },
                        endIcon: false),
                    ProfileMenuWidget(
                        isEnabled: _userType == "Vendeur"
                            ? false
                            : _userType == "Acheteur"
                                ? true
                                : false,
                        title: 'Delivery Adresse',
                        icon: LineAwesomeIcons.user_check,
                        onPressed: () {
                          print(_userType);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UrAddress(),
                              ));
                        },
                        endIcon: false),
                    ProfileMenuWidget(
                        title: 'Contact Us',
                        icon: LineAwesomeIcons.headphones,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactusScreen(),
                              ));
                        },
                        endIcon: false),
                    ProfileMenuWidget(
                        title: 'FAQ',
                        icon: LineAwesomeIcons.info,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FAQScreen()));
                        },
                        endIcon: false),
                    ProfileMenuWidget(
                        title: 'Log Out',
                        icon: LineAwesomeIcons.alternate_sign_out,
                        onPressed: () {
                          AuthService().signout();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckScreen()));
                        },
                        endIcon: true),
                  ],
                ),
              ),
            ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.endIcon,
    this.textColor,
    this.isEnabled = true,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool endIcon;
  final Color? textColor;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: isEnabled,
      onTap: onPressed,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: !endIcon
                ? Color.fromARGB(255, 34, 40, 154).withOpacity(0.1)
                : Colors.red.withOpacity(0.1)),
        child: Icon(
          icon,
          color: !endIcon ? Color.fromARGB(255, 34, 40, 154) : Colors.red,
        ),
      ),
      title: CustomText(
        text: title,
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: !endIcon ? Colors.black : Colors.red,
      ),
      trailing: !endIcon
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.withOpacity(0.2)),
              child: const Icon(
                LineAwesomeIcons.angle_right,
                size: 18.0,
                color: Colors.grey,
              ),
            )
          : SizedBox(),
    );
  }
}
