
import 'dart:async';

import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String routName = 'WelcomeScreen';
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboarding screen after 3 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF316B5D), // Background color
      body: Stack(
        children: [
          // Bottom Left Leaf (Smaller)
          Positioned(
            bottom: 0,
            left: 20,
            child: Image.asset(
              'assets/images/SmallLeaf.png', // Ensure this file exists
              width: 110, // Reduced width
              height: 180, // Reduced height
              fit: BoxFit.cover,
            ),
          ),

          // Bottom Right Leaf (Same size)
          Positioned(
            bottom: 0,
            right: 20,
            child: Image.asset(
              'assets/images/BigLeaf.png', // Ensure this file exists
              width: 250,
              height: 320,
              fit: BoxFit.cover,
            ),
          ),

          // Centered Logo & Text (Moved up)
          Positioned(
            top: 250, // Adjust this value to move it higher or lower
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bigger Logo
                Image.asset(
                  'assets/images/GoldenLogo.png', // Ensure this file exists
                  width: 100, // Increased width
                  height: 90, // Increased height
                ),
                const SizedBox(height: 10),

                // Text
                const Text(
                  'Golden Care',
                  style: TextStyle(
                    fontSize: 24, // Slightly larger text
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}