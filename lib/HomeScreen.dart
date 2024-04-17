import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui_login/CarInfo.dart';
import 'package:ui_login/CustomAppBar.dart';
import 'package:ui_login/Emergency.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Telephony telephony = Telephony.instance;
  bool _isDialogOpen = false;

  // Accelerometer variables
  double _x = 0.0;
  double _y = 0.0;
  double _z = 0.0;
  double _prevAcceleration = 0.0;
  double _presentAcceleration = 0.0;
  double _lastAcceleration = 0.0;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // Noise meter variables
  bool _isRecording = false;
  NoiseReading? _latestNoiseReading;
  double _smoothedMaxDecibel = 0.0;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? _noiseMeter;
  static const int _smoothingWindow = 5;
  List<double> _maxDecibelBuffer = [];

  // Constants
  static const double _brakeThreshold = 5.0;
  static const double _gravity = 9.8;
  static const double _alpha = 1;
  static const double _accidentThreshold = 1;
  static const double _lowSpeedThreshold = 2;
  static const int _mp = 30;
  static const double _lowSpeedThresholdKMH = 24;

  @override
  void initState() {
    super.initState();
    _initAccelerometer();
    _initNoiseMeter();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _noiseSubscription?.cancel();
    super.dispose();
  }

  Future<String> _getCurrentPosition() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return 'Permission denied';
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      String coordinates =
          '${position.latitude.toStringAsFixed(6)}° N, ${position.longitude.toStringAsFixed(6)}° E';

      return coordinates;
    } catch (e) {
      print('Error getting current position: $e');
      return 'Error getting position';
    }
  }

  void _initAccelerometer() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;

        double linearAcceleration =
            sqrt(pow(_x, 2) + pow(_y, 2) + pow(_z, 2)) - _gravity;
        linearAcceleration = _lastAcceleration +
            _alpha * (linearAcceleration - _lastAcceleration);

        if (linearAcceleration > _brakeThreshold) {
          _handleAccidentDetection(linearAcceleration);
        }

        _prevAcceleration = _lastAcceleration;
        _presentAcceleration = linearAcceleration;
        _lastAcceleration = linearAcceleration;
      });
    });
  }

  void _initNoiseMeter() async {
    _noiseMeter = NoiseMeter();
    if (!(await _checkPermission())) await _requestPermission();
    _noiseSubscription = _noiseMeter?.noise.listen((NoiseReading noiseReading) {
      if (!mounted) return;
      setState(() {
        _latestNoiseReading = noiseReading;
        _maxDecibelBuffer.add(noiseReading.maxDecibel);

        if (_maxDecibelBuffer.length > _smoothingWindow) {
          _maxDecibelBuffer.removeAt(0);
        }

        _smoothedMaxDecibel = _maxDecibelBuffer.reduce((a, b) => a + b) /
            _maxDecibelBuffer.length;
      });
    }, onError: (Object error) {
      print(error);
      _stopRecording();
    });
  }

  Future<bool> _checkPermission() async =>
      await Permission.microphone.isGranted;

  Future<void> _requestPermission() async =>
      await Permission.microphone.request();

  void _startRecording() async {
    if (_noiseMeter == null) _noiseMeter = NoiseMeter();
    if (!(await _checkPermission())) await _requestPermission();
    _noiseSubscription = _noiseMeter?.noise.listen((NoiseReading noiseReading) {
      setState(() {
        _latestNoiseReading = noiseReading;
        _maxDecibelBuffer.add(noiseReading.maxDecibel);

        if (_maxDecibelBuffer.length > _smoothingWindow) {
          _maxDecibelBuffer.removeAt(0);
        }

        _smoothedMaxDecibel = _maxDecibelBuffer.reduce((a, b) => a + b) /
            _maxDecibelBuffer.length;
      });
    }, onError: (Object error) {
      print(error);
      _stopRecording();
    });
    setState(() => _isRecording = true);
  }

  void _stopRecording() {
    _noiseSubscription?.cancel();
    setState(() => _isRecording = false);
  }

  void _handleAccidentDetection(double acceleration) {
    double accCondition = acceleration / 4.0;
    double suCondition = _latestNoiseReading != null
        ? _latestNoiseReading!.meanDecibel / 140.0
        : 0.0;
    double ssdCondition = 0.0;
    double elapsedTime = _isDialogOpen ? 0.0 : 30.0;

    if (_latestNoiseReading != null &&
        _latestNoiseReading!.meanDecibel > 82.0) {
      if (_latestNoiseReading!.meanDecibel >= _lowSpeedThresholdKMH) {
        if ((accCondition + suCondition + ssdCondition) >= _lowSpeedThreshold) {
          if (!_isDialogOpen) {
            _isDialogOpen = true;
            _showConfirmationDialog(context);
          }
          return;
        }
      }

      if ((accCondition + suCondition + ssdCondition) >= _accidentThreshold &&
          elapsedTime < _mp) {
        if (!_isDialogOpen) {
          _isDialogOpen = true;
          _showConfirmationDialog(context);
        }
        return;
      }

      if ((accCondition + suCondition) >= _accidentThreshold) {
        if (!_isDialogOpen) {
          _isDialogOpen = true;
          _showConfirmationDialog(context);
        }
        return;
      }
    }
  }

  void _showConfirmationDialog(BuildContext context) async {
    bool userSafe = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Accident Detected')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Are you safe?',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 16),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                userSafe = true;
                Navigator.of(context).pop();
                _isDialogOpen = false;
              },
              child: Text('YES'),
            ),
            TextButton(
              onPressed: () {
                userSafe = false;
                Navigator.of(context).pop();
                _isDialogOpen = false;
              },
              child: Text('NO'),
            ),
          ],
        );
      },
    ).then((_) async {
      // Use then() to execute code after dialog is closed
      _isDialogOpen = false; // Reset the flag after dialog is closed
      if (!userSafe) {
        String currentPosition = await _getCurrentPosition();
        _sendSMS(currentPosition);
      }
    });

    // Set a timer to auto-dismiss the dialog after 10 seconds
    Future.delayed(Duration(seconds: 10), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
        _isDialogOpen = false; // Reset the flag if dialog is dismissed by timer
      }
    });
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(context: context),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(25),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      _isRecording ? "Mic: ON" : "Mic: OFF",
                      style: TextStyle(fontSize: 25, color: Colors.blue),
                    ),
                    margin: EdgeInsets.only(top: 20),
                  ),
                  Container(
                    child: Text(
                      'Noise: ${_latestNoiseReading?.meanDecibel.toStringAsFixed(2)} dB',
                    ),
                    margin: EdgeInsets.only(top: 20),
                  ),
                  Container(
                    child: Text(
                      'Max: ${_smoothedMaxDecibel.toStringAsFixed(2)} dB',
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 8.0,
                  right: 8,
                  bottom: MediaQuery.of(context).size.height * 0.12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      width: 120,
                      height: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Emergency(),
                            ),
                          );
                        },
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Column(
                            children: [
                              Icon(
                                Icons.contact_phone,
                                size: 30,
                                color: Colors.orangeAccent.shade400,
                              ),
                              Text(
                                'Emergency\nContact',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      width: 150,
                      height: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Column(
                            children: [
                              Icon(
                                Icons.cloud,
                                size: 30,
                                color: Colors.white,
                              ),
                              Text(
                                'Weather',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      width: 150,
                      height: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => CarInfo())));
                        },
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Column(
                            children: [
                              Icon(
                                Icons.directions_car,
                                size: 30,
                                color: Colors.black,
                              ),
                              Text(
                                'Car info',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
