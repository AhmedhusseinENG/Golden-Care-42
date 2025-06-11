import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'WelcomeScreen.dart';
import 'login/login_screen.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  static String routName = 'OnboardingScreen';
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // ✅ Ensure entire screen is white
        child: Column(
          children: [
            Expanded(
              child: IntroductionScreen(
                globalBackgroundColor: Colors.white,
                pages: [
                  _buildPageModel(
                    imagePath: 'assets/images/doctor1.png',
                    title: "Welcome to",
                    subtitle: "Golden Care App",
                    description:
                    "Your AI-powered companion for predicting blood pressure and monitoring your health.",
                  ),
                  _buildPageModel(
                    imagePath: 'assets/images/doctor2.png',
                    title: "Find Your Perfect",
                    subtitle: "MEDICAL CARE",
                    description:
                    "Our advanced system tracks vital signs, reminds you about medication, and alerts your companions in case of any health concerns.",
                  ),
                  _buildPageModel(
                    imagePath: 'assets/images/doctor3.png',
                    title: "Ready to Start Your Health",
                    subtitle: "JOURNEY?",
                    description:
                    "Sign up now to begin exploring the world of healthcare options and take the first step towards a healthier you.",
                  ),
                  _buildPageModel(
                    imagePath: 'assets/images/doctor4.png',
                    title: "Find and Book Your Ideal",
                    subtitle: "MEDICAL EXPERT",
                    description:
                    "Embark on a journey to better health and locate the perfect medical expert who can guide you on your wellness path.",
                  ),
                ],
                showSkipButton: false,
                showNextButton: false,
                showDoneButton: false,
                dotsDecorator: DotsDecorator(
                  size: const Size.square(8.0),
                  activeSize: const Size(20.0, 8.0),
                  activeColor: Colors.teal,
                  color: Colors.grey,
                  spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),

            // ✅ "Get Started" Button at the Bottom
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildGetStartedButton(context),
            ),
          ],
        ),
      ),
    );
  }

  PageViewModel _buildPageModel({
    required String imagePath,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return PageViewModel(
      titleWidget: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2F6760)),
          ),
        ],
      ),
      bodyWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ],
      ),
      image: _buildImage(imagePath),
      decoration: PageDecoration(
        bodyAlignment: Alignment.topCenter,
        titleTextStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        bodyTextStyle: const TextStyle(fontSize: 18, color: Colors.black54),
        imagePadding: const EdgeInsets.only(top: 30),
        pageColor: Colors.white,
      ),
    );
  }

  // ✅ "Get Started" Button to Navigate to SignupScreen
  Widget _buildGetStartedButton(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDCF1F3), // Light teal background
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()), // ✅ Navigate to SignupScreen
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/resume.png",
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 35),
            const Text(
              "Get Started",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F6760),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ✅ Keeps Images Large and Moves Them Lower
  Widget _buildImage(String path) {
    return Container(
      padding: const EdgeInsets.only(top: 30), // Moves image down
      child: Image.asset(
        path,
        width: 350,
        height: 350,
        fit: BoxFit.contain,
      ),
    );
  }
}
