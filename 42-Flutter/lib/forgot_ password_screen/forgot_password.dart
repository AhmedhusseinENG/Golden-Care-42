import 'package:flutter/material.dart';
import 'package:golden_care_2/forgot_%20password_screen/reset_password.dart';
import '../login/loginContinue_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String routName = 'forgot password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEmailValid = false;

  void _onEmailChanged(String value) {
    setState(() {
      isEmailValid = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true, // مهم لتفادي overflow وقت ظهور الكيبورد
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenSize.height * 0.1),

                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color(0xffECECEC),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, LoginContinueScreen.routName);
                    },
                    iconSize: 30,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Forgot password",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Please enter your email to reset the password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff989898)),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Your Email",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _emailController,
                  onChanged: _onEmailChanged,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: const TextStyle(color: Color(0xffDADADA), fontWeight: FontWeight.bold),
                    enabledBorder: _textFieldBorder(),
                    focusedBorder: _textFieldBorder(borderColor: Colors.grey),
                    errorBorder: _textFieldBorder(borderColor: Colors.red),
                    focusedErrorBorder: _textFieldBorder(borderColor: Colors.red),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    if (!isEmailValid) {
                      return 'Please enter a valid email.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: screenSize.width,
                  height: screenSize.height * 0.06,
                  child: ElevatedButton(
                    onPressed: isEmailValid
                        ? () {
                      if (_formKey.currentState?.validate() ?? false) {
                        Navigator.pushNamed(
                          context,
                          ResetPasswordScreen.routeName,
                          arguments: _emailController.text,
                        );
                      }
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEmailValid
                          ? const Color(0xff2F6760)
                          : const Color(0xffD8ECE9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Reset Password",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputBorder _textFieldBorder({Color borderColor = Colors.grey}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: borderColor, width: 2),
    );
  }
}
