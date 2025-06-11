import 'package:flutter/material.dart';
import 'package:golden_care_2/forgot_%20password_screen/set_password.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../ui/assets.dart';
import 'forgot_password.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String routeName = 'reset password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String email = "";
  TextEditingController otpController = TextEditingController();
  bool isOtpValid = false;

  void userEmail() {
    final route = ModalRoute.of(context);
    final args = route?.settings.arguments;
    if (args is String && args.isNotEmpty) {
      email = args;
    } else {
      email = "your email";
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userEmail();
  }

  void _onOtpChanged(String value) {
    setState(() {
      isOtpValid = value.length == 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.15),

              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xffECECEC),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, ForgotPasswordScreen.routName);
                  },
                  color: AppColors.primaryColor,
                  iconSize: 30,
                ),
              ),

              SizedBox(height: screenSize.height * 0.03),

              const Text(
                "Check your email",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: screenSize.height * 0.02),

              Text(
                "We sent a reset link to ${email.isNotEmpty ? email : "your email"}\nEnter the 5-digit code mentioned in the email",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff989898),
                ),
              ),

              SizedBox(height: screenSize.height * 0.03),

              PinCodeTextField(
                appContext: context,
                length: 5,
                controller: otpController,
                keyboardType: TextInputType.number,
                autoFocus: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 60,
                  fieldWidth: 60,
                  activeFillColor: AppColors.primaryColor,
                  inactiveFillColor: Colors.white,
                  inactiveColor: Colors.grey,
                  selectedColor: AppColors.primaryColor,
                  borderWidth: 0,
                ),
                onChanged: _onOtpChanged,
              ),

              SizedBox(height: screenSize.height * 0.02),

              SizedBox(
                width: screenSize.width,
                height: screenSize.height * 0.06,
                child: ElevatedButton(
                  onPressed: isOtpValid
                      ? () {
                    String otp = otpController.text.trim();
                    if (mounted) {
                      Navigator.pushReplacementNamed(
                          context, SetPassword.routeName);
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOtpValid
                        ? AppColors.primaryColor
                        : const Color(0xffD8ECE9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Verify Code",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenSize.height * 0.03),

              Center(
                child: const Text(
                  "Haven't got the email yet?",
                  style: TextStyle(
                    color: Color(0xff808285),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              Center(
                child: TextButton(
                  onPressed: () {
                    print("Resend email tapped");

                  },
                  child: Text(
                    'Resend email',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
