import 'package:flutter/material.dart';
import 'patient_signup_screen.dart';
import 'companion_signup_screen.dart';

class SignupScreen extends StatefulWidget {
  static String routName ="signup";
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isPatient = true; // Toggle between Patient & Companion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildLogo(), // ✅ Logo and Text at the Top
          const SizedBox(height: 40),
          _buildToggleButtons(),
          Expanded(
            child: isPatient ? PatientSignupScreen() : CompanionSignupScreen(),
          ),
        ],
      ),
    );
  }

  // ✅ Logo and App Name (Bigger Size)
  Widget _buildLogo() {
    return Center(
      child: Column(
        children: [
          Image.asset("assets/images/GreenLogo.png", height: 80),
          const Text(
            "Golden Care",
            style: TextStyle(
              fontSize: 28, // تكبير الخط
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F6760),
            ),
          ),
        ],
      ),
    );
  }

  // 🔘 Toggle Buttons (Switch between Patient & Companion)
  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(child: _toggleButton("Patient", isPatient)),
          const SizedBox(width: 10),
          Expanded(child: _toggleButton("Companion", !isPatient)),
        ],
      ),
    );
  }

  Widget _toggleButton(String title, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => isPatient = title == "Patient"),
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2F6760) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2F6760), // Border color
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF2F6760),
          ),
        ),
      ),
    );
  }
}



