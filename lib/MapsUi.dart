// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:google_maps_flutter_andqroid/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    _location = Location();
    _cameraPosition = CameraPosition(
      target: LatLng(0, 0), // Initial position
      zoom: 15,
    );
    _initLocation();
  }

  // Initialize location tracking
  _initLocation() {
    _location?.getLocation().then((location) {
      setState(() {
        _currentLocation = location;
      });
    });
    _location?.onLocationChanged.listen((newLocation) {
      setState(() {
        _currentLocation = newLocation;
      });
    });
  }

  // Move the camera to the current location
  moveToCurrentLocation() async {
    final GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
            _currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0),
        zoom: 15,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          SizedBox(height: 3),
          Expanded(
            child: _buildMap(),
          ),
        ],
      ),
    );
  }

  // Build Google Map widget
  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: _cameraPosition!,
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {
        if (!_googleMapController.isCompleted) {
          _googleMapController.complete(controller);
        }
      },
      myLocationEnabled: true, // Show current location button
      myLocationButtonEnabled: true, // Enable current location button
    );
  }
}
