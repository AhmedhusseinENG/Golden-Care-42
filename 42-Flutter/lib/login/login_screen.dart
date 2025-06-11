import 'package:flutter/material.dart';
import '../signup_screen.dart';
import '../ui/assets.dart';
import 'loginContinue_screen.dart';

class LoginScreen extends StatelessWidget {
  static String routName = 'welcome';

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  image: DecorationImage(
                    image: AssetImage(AppImages.logoImage),
                    alignment: Alignment.centerLeft,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenSize.height * 0.1),
                          Image.asset(
                            AppImages.heartImage,
                          ),
                          SizedBox(height: screenSize.height * 0.03),
                          const Text(
                            "Welcome",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.01),
                          const Text(
                            "Login to continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        AppImages.leave1Image,
                        fit: BoxFit.contain,
                        width: screenSize.width * 0.4,
                        height: screenSize.height * 0.18,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: screenSize.width * 0.4,
                      child: Image.asset(
                        AppImages.leave2Image,
                        fit: BoxFit.contain,
                        width: screenSize.width * 0.2,
                        height: screenSize.height * 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.07),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Create an account to get started OR \n Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.1),
              SizedBox(
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, LoginContinueScreen.routName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              SizedBox(
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, SignupScreen.routName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Sign UP",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // مسافة بسيطة إضافية أسفل الأزرار
            ],
          ),
        ),
      ),
    );
  }
}
