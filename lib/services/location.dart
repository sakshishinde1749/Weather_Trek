import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';



class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Location location = Location();

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    await location.getCurrentLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Latitude: ${location.latitude}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Longitude: ${location.longitude}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class Location {
  double latitude = 12.5;
  double longitude = 19.4;

  Future<bool> checkLocationPermission() async {
    // Check if the location permission is already granted
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // If the user has denied the permission, handle it here
      return false;
    } else {
      // Request the location permission
      status = await Permission.location.request();
      if (status.isGranted) {
        return true;
      } else {
        // If the user denies the permission request, handle it here
        return false;
      }
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      bool hasPermission = await checkLocationPermission();
      if (hasPermission) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );
        latitude = position.latitude;
        longitude = position.longitude;
      } else {
        print('Location permission denied');
      }
    } catch (e) {
      print(e);
    }
  }
}
