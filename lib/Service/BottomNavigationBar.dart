import 'package:etors/Screens/Buyer/Cart.dart';
import 'package:etors/Screens/Buyer/Explore.dart';
import 'package:etors/Screens/Profile.dart';
import 'package:etors/Screens/Seller/Dashboard.dart';
import 'package:etors/Screens/Seller/AddProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key, required this.gendre});

  final Type gendre;

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  var currentIndex = 0;

  final List<Widget> _buyerScreens = [
    ExploreScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  final List<Widget> _sellerScreens = [
    DashboardScreen(),
    ProductScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.gendre == Type.Vendeur
          ? _buyerScreens[currentIndex]
          : _sellerScreens[currentIndex],
      bottomNavigationBar: widget.gendre == Type.Vendeur
          ? bottomNavigationBarBayer()
          : bottomNavigationBarSeller(),
    );
  }

  Widget bottomNavigationBarBayer() {
    int Index = 0;
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          activeIcon: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              "Explore",
              style: GoogleFonts.workSans(fontSize: 16),
            ),
          ),
          label: "",
          icon: Image.asset(
            'assets/BottomNavigationBar/pointer.png',
            fit: BoxFit.contain,
            width: 30,
          ),
        ),
        BottomNavigationBarItem(
          activeIcon: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text("Cart", style: GoogleFonts.workSans(fontSize: 16)),
          ),
          label: "",
          icon: Image.asset(
            'assets/BottomNavigationBar/shopping-cart.png',
            fit: BoxFit.contain,
            width: 30,
          ),
        ),
        BottomNavigationBarItem(
          activeIcon: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text("Profile", style: GoogleFonts.workSans(fontSize: 16)),
          ),
          label: "",
          icon: Image.asset(
            'assets/BottomNavigationBar/user.png',
            fit: BoxFit.contain,
            width: 30,
          ),
        )
      ],
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      elevation: 0,
      backgroundColor: Colors.grey.shade50,
      selectedItemColor: Colors.black,
      currentIndex: currentIndex,
    );
  }

  Widget bottomNavigationBarSeller() {
    int Index = 0;
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          activeIcon: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              "Dashboard",
              style: GoogleFonts.workSans(fontSize: 16),
            ),
          ),
          label: "",
          icon: Image.asset(
            'assets/BottomNavigationBar/graph.png',
            fit: BoxFit.contain,
            width: 30,
          ),
        ),
        BottomNavigationBarItem(
          activeIcon: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text("Products", style: GoogleFonts.workSans(fontSize: 16)),
          ),
          label: "",
          icon: Image.asset(
            'assets/BottomNavigationBar/shipping.png',
            fit: BoxFit.contain,
            width: 30,
          ),
        ),
        BottomNavigationBarItem(
          activeIcon: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text("Profile", style: GoogleFonts.workSans(fontSize: 16)),
          ),
          label: "",
          icon: Image.asset(
            'assets/BottomNavigationBar/user.png',
            fit: BoxFit.contain,
            width: 30,
          ),
        )
      ],
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      elevation: 0,
      backgroundColor: Colors.grey.shade50,
      selectedItemColor: Colors.black,
      currentIndex: currentIndex,
    );
  }
}

enum Type {
  Acheteur,
  Vendeur,
  Livreur;
}
