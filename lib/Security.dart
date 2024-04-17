import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:ui_login/CustomAppBar.dart';
import 'package:geolocator/geolocator.dart';

class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  final Telephony telephony = Telephony.instance;

  Future<String> _getCurrentPosition() async {
    try {
      // Request permission to access the device's location
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Permission denied, handle accordingly
        return 'Permission denied';
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Format the coordinates
      String coordinates =
          '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';

      return coordinates;
    } catch (e) {
      // Error occurred while getting the position, handle accordingly
      print('Error getting current position: $e');
      return 'Error getting position';
    }
  }

  void _sendSMS(String coordinates) async {
    List<String> numbers = [
      '+91 8967418564',
      '+91 9062435655',
      '+91 9330492044',
      '+91 9830976993',
      '+91 7363993084'
      // '+91 93304 92044', // Add more numbers here
    ];

    try {
      for (String number in numbers) {
        await telephony.sendSms(
          to: number,
          message: 'Accident reported at coordinates: $coordinates',
        );
        print('SMS sent successfully to $number');
      }
    } catch (error) {
      print('Failed to send SMS: $error');
    }
  }

  void _showConfirmationDialog() async {
    String currentPosition = await _getCurrentPosition();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Emergency"),
          content: Text("Are you sure you want to report an Accident?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform the SOS action here
                Navigator.of(context).pop(); // Close the dialog
                _sendSMS(currentPosition);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "!Report an Accident!\n",
              style: TextStyle(fontSize: 28),
            ),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog();
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Icon(
                  Icons.ads_click_sharp,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
