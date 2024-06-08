import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

//For privacy the exact formulas and functions have been removed
class AccidentDetectionApp extends StatefulWidget {
  @override
  _AccidentDetectionAppState createState() => _AccidentDetectionAppState();
}

class _AccidentDetectionAppState extends State<AccidentDetectionApp> {
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
  static const int _svp = 30;
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

  // Initialize accelerometer
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

        // Check for sudden acceleration change
        if (linearAcceleration > _brakeThreshold) {
          _handleAccidentDetection(linearAcceleration);
        }

        _prevAcceleration = _lastAcceleration;
        _presentAcceleration = linearAcceleration;
        _lastAcceleration = linearAcceleration;
      });
    });
  }

  // Initialize noise meter
  void _initNoiseMeter() async {
  _noiseMeter = NoiseMeter();
  if (!(await _checkPermission())) await _requestPermission();
  _noiseSubscription = _noiseMeter?.noise.listen((NoiseReading noiseReading) {
    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      _latestNoiseReading = noiseReading;
      _maxDecibelBuffer.add(noiseReading.maxDecibel);

      if (_maxDecibelBuffer.length > _smoothingWindow) {
        _maxDecibelBuffer.removeAt(0);
      }

      _smoothedMaxDecibel =
          _maxDecibelBuffer.reduce((a, b) => a + b) / _maxDecibelBuffer.length;
    });
  }, onError: (Object error) {
    print(error);
    _stopRecording();
  });
}


  // Check microphone permission
  Future<bool> _checkPermission() async =>
      await Permission.microphone.isGranted;

  // Request microphone permission
  Future<void> _requestPermission() async =>
      await Permission.microphone.request();

  // Start noise sampling
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

        _smoothedMaxDecibel =
            _maxDecibelBuffer.reduce((a, b) => a + b) / _maxDecibelBuffer.length;
      });
    }, onError: (Object error) {
      print(error);
      _stopRecording();
    });
    setState(() => _isRecording = true);
  }

  // Stop noise sampling
  void _stopRecording() {
    _noiseSubscription?.cancel();
    setState(() => _isRecording = false);
  }

  // Handle accident detection
  // Handle accident detection
void _handleAccidentDetection(double acceleration) {
  // Calculate the values based on the provided formulas


  
  // For Privacy The Exact Formulas had been removed




  
  // print('No Accident Detected!');
}


  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Accident Detection'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'X: ${_x.toStringAsFixed(2)} g',
                  style: TextStyle(fontSize: 24.0),
                ),
                Text(
                  'Y: ${_y.toStringAsFixed(2)} g',
                  style: TextStyle(fontSize: 24.0),
                ),
                Text(
                  'Z: ${_z.toStringAsFixed(2)} g',
                  style: TextStyle(fontSize: 24.0),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Previous Acceleration: ${_prevAcceleration.toStringAsFixed(2)} m/s^2',
                  style: TextStyle(fontSize: 24.0),
                ),
                Text(
                  'Present Acceleration: ${_presentAcceleration.toStringAsFixed(2)} m/s^2',
                  style: TextStyle(fontSize: 24.0),
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          _isRecording ? "Mic: ON" : "Mic: ON",
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
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: _isRecording ? Colors.red : Colors.green,
          //   child: _isRecording ? Icon(Icons.stop) : Icon(Icons.mic),
          //   onPressed: _isRecording ? _stopRecording : _startRecording,
          // ),
        ),
      );
}
