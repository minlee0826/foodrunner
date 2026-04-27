import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverMapScreen extends StatefulWidget {
  const DriverMapScreen({super.key});

  @override
  State<DriverMapScreen> createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  late GoogleMapController mapController;

  LatLng driverLocation = const LatLng(37.7749, -122.4194); // default

  void updateLocation() async {
    final driverId = FirebaseAuth.instance.currentUser!.uid;

    // simulate movement
    driverLocation = LatLng(
      driverLocation.latitude + 0.0001,
      driverLocation.longitude + 0.0001,
    );

    await FirebaseFirestore.instance
        .collection('drivers')
        .doc(driverId)
        .update({
      'lat': driverLocation.latitude,
      'lng': driverLocation.longitude,
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // update every 5 seconds
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      updateLocation();
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Map"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: driverLocation,
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("driver"),
            position: driverLocation,
          )
        },
      ),
    );
  }
}