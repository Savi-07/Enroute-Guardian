import 'package:flutter/material.dart';
import 'package:ui_login/LoginPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;

  const CustomAppBar({
    Key? key,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Set background color to transparent
      elevation: 0, // Remove elevation
      actions: [
        IconButton(
          icon: Icon(
            Icons.logout,
            size: 30, // Increase the size of the icon
            color: Colors.white, // Change the color of the icon
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
