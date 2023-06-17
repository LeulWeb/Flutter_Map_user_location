// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  return runApp(MaterialApp(
    home: const Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final geolocator = Geolocator()

  double lattidue = 0;
  double longitude = 0;

  double liveLattitude = 0;
  double liveLongitude = 0;

  void _getCurrentLocation() async {
    // check if service is enabled

    bool isEnabled = await Geolocator.isLocationServiceEnabled();

    // This will make sure the location service is enabled before getting the location
    if (!isEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable location service'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Ask for permission

      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable location service'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        //I will get the current location
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          lattidue = position.latitude;
          longitude = position.longitude;
        });
      }
    }
  }

  //tracking the user location
  void _liveLocation() async {
    LocationSettings setting = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: setting)
        .listen((Position position) {
      setState(() {
        liveLattitude = position.latitude;
        liveLongitude = position.longitude;
      });
    });
  }

  void _showInMap(lat, long) async {
    String mapUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';

    await canLaunchUrl(Uri.parse(mapUrl))
        ? await launchUrlString(mapUrl)
        : throw 'Could not launch $mapUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Hello World'),
          Text('Latitude: $lattidue'),
          Text('Longitude: $longitude'),
          TextButton(
            child: Text('Click me'),
            onPressed: () {
              _getCurrentLocation();
            },
          ),

          // tracking the user location
          Text('Latitude: $liveLattitude'),
          Text('Longitude: $liveLongitude'),
          TextButton(
            onPressed: _liveLocation,
            child: Text('Live Location'),
          ),

          // open google map
          TextButton(
            child: Text('Open Google Map'),
            onPressed: () {
              _showInMap(lattidue, longitude);
            },
          )
        ],
      ),
    ));
  }
}
