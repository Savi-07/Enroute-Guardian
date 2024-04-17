import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_login/CustomAppBar.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate the ideal height and width for the image
    final double idealImageHeight =
        screenSize.height * 0.2; // 20% of screen height
    final double idealImageWidth =
        screenSize.width * 0.3; // 30% of screen width

    return Scaffold(
      appBar: CustomAppBar(context: context),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(155, 56, 55, 57),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                // top: MediaQuery.of(context).size.height * 0.05,
                right: 15,
                left: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "assets/images/profilepic.png",
                            height: idealImageHeight,
                            width: idealImageWidth,
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sahil Kumar Singh",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Contact: 6291817369",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Gmail:singhsahilkumar10@gmail.com",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey, // specify the color of the line
                    thickness: 1, // specify the thickness of the line
                  ),
                  Text(
                    "GENERAL INFORMATION\n",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Date of Birth-10-05-2004\nWeight-58 KG\nHeight- 5'8\nLicence Number-WB05 20220023907",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey, // specify the color of the line
                    thickness: 1, // specify the thickness of the line
                  ),
                  Text(
                    "MEDICAL INFORMATION\n",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Blood Group-AB+\nAlergy-Null\nMajor health issue-None",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey, // specify the color of the line
                    thickness: 1, // specify the thickness of the line
                  ),
                  Text(
                    "ADDRESS\n",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Address-1250, Madurdaha Hussainpur main road\nPolice station-Annandopur\nPin Code-700107\nCity-Kolkata\nState-West Bengal",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey, // specify the color of the line
                    thickness: 1, // specify the thickness of the line
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
