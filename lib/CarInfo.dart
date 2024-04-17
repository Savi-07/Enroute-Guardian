import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_login/CustomAppBar.dart';

class CarInfo extends StatefulWidget {
  const CarInfo({Key? key});

  @override
  State<CarInfo> createState() => _CarInfoState();
}

class _CarInfoState extends State<CarInfo> {
  @override
  Widget build(BuildContext context) {
    // Get the screen size
    // final size padheight = MediaQuery.of(context).size.;
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(context: context),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Container(
              width: screenSize.width, // Set container width to full screen width
              decoration: BoxDecoration(
                color: const Color.fromARGB(155, 56, 55, 57),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    "assets/images/CarInfopic.png",
                    height: MediaQuery.of(context).size.height * 0.13,
                  ),
                  SizedBox(
                    height: 10,
                  ), // Added spacing between image and text
                  Text(
                    "HONDA AMAZE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Divider(
                    color: Colors.grey, // specify the color of the line
                    thickness: 1, // specify the thickness of the line
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "CAR INFORMATION\n",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Registration Date - 01/02/2022\nMileage-56’358 km\nVehicle Class-Copact\nLicence Number- WB05 20220023907\nCar Number-WB 02AD 6305\nWarranty expires- May'25",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
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
