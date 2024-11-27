import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart'; // Import the permission_handler package
import 'package:voice_meet/route/pageroute.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Request permissions as soon as the splash screen loads
  }

  Future<void> _requestPermissions() async {
    // Requesting camera, microphone, and storage permissions
    var statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.locationWhenInUse,
      Permission.photos,
      Permission.storage,
    ].request();

    // Optionally, you can check and handle the statuses here.
    if (statuses[Permission.camera]!.isDenied) {
      print("Camera permission denied");
    }
    if (statuses[Permission.microphone]!.isDenied) {
      print("Microphone permission denied");
    }
    if (statuses[Permission.storage]!.isDenied) {
      print("Storage permission denied");
    }

    // Navigate to the next screen after a delay of 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RoutePath.welcome); // Replace with your next route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
          ),
          // Semi-transparent overlay to improve text visibility
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          // Positioned text at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to Our voice meet!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Communicate with strangers or bot',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
