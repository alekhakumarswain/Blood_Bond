import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

void main() {
  final latLng = LatLng(20.333, 85.821);
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text(
            'LatLng: (${latLng.latitude.toStringAsFixed(3)}, ${latLng.longitude.toStringAsFixed(3)})'),
      ),
    ),
  ));
}
