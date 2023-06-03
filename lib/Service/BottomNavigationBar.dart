import 'package:etors/Screens/Buyer/CartScreen.dart';
import 'package:etors/Screens/Buyer/Explore.dart';
import 'package:etors/Screens/Livreur/Livreur.dart';
import 'package:etors/Screens/Profile/Profile.dart';
import 'package:etors/Screens/Seller/Dashboard.dart';
import 'package:etors/Screens/Seller/AddProduct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key, required this.type});

  final String type;

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  var currentIndex = 0;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    List<Widget>? _screens;
    if (widget.type == "Acheteur") {
      _screens = [
        ExploreScreen(),
        CartScreen(),
        ProfileScreen(),
      ];
    } else if (widget.type == "Vendeur") {
      _screens = [
        DashboardScreen(),
        ProductScreen(
          uid: user.uid,
        ),
        ProfileScreen(),
      ];
    } else {
      _screens = [Livreur(), ProfileScreen()];
    }
    return Scaffold(
      body: _screens![currentIndex],
      bottomNavigationBar: widget.type == "Acheteur"
          ? _buildBottomNavigationBarAcheteur()
          : widget.type == "Vendeur"
              ? _buildBottomNavigationBarVendeur()
              : _buildBottomNavigationBarLivreur(),
    );
  }

  Widget _buildBottomNavigationBarAcheteur() {
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

  Widget _buildBottomNavigationBarVendeur() {
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

  Widget _buildBottomNavigationBarLivreur() {
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
