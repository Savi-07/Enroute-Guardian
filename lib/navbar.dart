import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:ui_login/AccDetection.dart';
import 'package:ui_login/AddUsers.dart';
import 'package:ui_login/HomeScreen.dart';
import 'package:ui_login/Profile.dart';
import 'package:ui_login/Security.dart';
// import 'package:ui_login/AddUsers.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    AddUsers(),
    Security(),
    Profile(),
    // AccidentDetectionApp()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        buttonBackgroundColor: Color.fromARGB(0, 241, 235, 235),
        color: Colors.black,
        items: [
          _buildNavItem(Icons.home, 'Home'),
          _buildNavItem(Icons.add, 'Users'),
          _buildNavItem(Icons.security, 'SOS'),
          _buildNavItem(Icons.person, 'Profile'),
          // _buildNavItem(Icons.person, 'Accident'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String text) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 25,
            color: Colors.orange,
          ),
          SizedBox(height: 1),
          Text(
            text,
            style: TextStyle(color: Colors.orange, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
