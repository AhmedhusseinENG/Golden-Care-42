import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../forgot_ password_screen/forgot_password.dart';

import '../home_screen/home_screen.dart';
import '../shared_preferences_helper.dart';
import '../signup_screen.dart';
import '../ui/assets.dart';
import 'customTextField.dart';

class LoginContinueScreen extends StatefulWidget {
  static String routName = 'login';

  @override
  State<LoginContinueScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginContinueScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Color forgotPasswordColor = AppColors.primaryColor;
  Color signUpColor = AppColors.primaryColor;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('https://migration.runasp.net/api/Auth/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': _emailController.text,
            'password': _passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          if (responseData != null) {
            final isPatient = responseData['patientId'] == null;
            final role = isPatient ? 'patient' : 'companion';
            responseData['role'] = role;

            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('userData', jsonEncode(responseData));

            // ✅ التخزين الصحيح للـ patientId حسب نوع المستخدم
            if (isPatient) {
              // لو مريض → نخزن الـ id كمعرّف المريض
              await prefs.setString('patientId', responseData['id'].toString());
              print('✅ Logged in as PATIENT, saved patientId = ${responseData['id']}');
            } else {
              // لو مرافق → نخزن الـ patientId الموجود في البيانات
              await prefs.setString('patientId', responseData['patientId'].toString());
              print('✅ Logged in as COMPANION, saved patientId = ${responseData['patientId']}');
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }

        } else {
          _showErrorDialog('Invalid login credentials.');
        }
      } catch (e) {
        _showErrorDialog('An error occurred. Please try again.');
      }
    }
  }

  // عرض رسالة خطأ
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenSize.height * 0.55,
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
                        Image.asset(AppImages.heartImage),
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    CustomTextField(
                      controller: _emailController,
                      isPasswordField: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        //if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zAA-Z0-9.-]+$")
                        //    .hasMatch(value)) {
                         // return "Enter a valid email";
                       // }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    CustomTextField(
                      controller: _passwordController,
                      isPasswordField: true,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Wrong Password',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        forgotPasswordColor = Colors.blue;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        forgotPasswordColor = AppColors.primaryColor;
                      });
                    },
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, ForgotPasswordScreen.routName);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: forgotPasswordColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.06,
              child: ElevatedButton(
                onPressed: _login,
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't Have an Account?",
                  style: TextStyle(
                    color: Color(0xff808285),
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      signUpColor = Colors.blue;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      signUpColor = AppColors.primaryColor;
                    });
                  },
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, SignupScreen.routName);
                    },
                    child: Text(
                      ' Sign Up',
                      style: TextStyle(
                        color: signUpColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
