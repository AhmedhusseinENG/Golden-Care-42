import 'package:flutter/material.dart';
import 'package:golden_care_2/shared_preferences_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'home_screen/home_screen.dart';
import 'login/loginContinue_screen.dart';
import 'login/login_screen.dart';
import '../services/auth_service.dart';

class PatientSignupScreen extends StatefulWidget {
  @override
  _PatientSignupScreenState createState() => _PatientSignupScreenState();
}

class _PatientSignupScreenState extends State<PatientSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? selectedGender;
  bool isGenderValid = true;
  File? _image;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerPatient() async {
    if (_image == null) {
      print("Please select an image");
      return;
    }

    if (_formKey.currentState!.validate() && selectedGender != null && _image != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final authService = AuthService();
      final patientId = await authService.registerPatient(
        username: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        gender: selectedGender!,
        image: _image!,
      );

      Navigator.pop(context); // close the loader

      if (patientId != null) {
        /// ✅ تخزين بيانات المستخدم بالكامل (مش بس patientId)
        await SharedPreferencesHelper.saveUserData(
          userData: {
            'username': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'gender': selectedGender!,
            'image': _image!.path,
            'patientId': patientId,
            'role': 'patient',
          },
          username: _nameController.text.trim(),
          profileImagePath: _image!.path,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginContinueScreen()),
        );

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Registration Failed"),
            content: const Text("Please try again."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all required fields.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileImage(),
              const SizedBox(height: 20),
              _buildTextField("Name", _nameController, TextInputType.name, validator: _validateName),
              _buildTextField("Email Address", _emailController, TextInputType.emailAddress, validator: _validateEmail),
              _buildTextField("Password", _passwordController, TextInputType.visiblePassword, isPassword: true, validator: _validatePassword),
              const SizedBox(height: 10),
              _buildGenderSelection(),
              if (!isGenderValid)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 5),
                  child: const Text(
                    "Please select a gender",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 20),
              _buildSignupButton(),
              _buildLoginRedirect(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFBCBEC0), width: 1),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.person, size: 60, color: Color(0xFF595A5C))
                    : null,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: const Color(0xFF2F6760),
                child: const Icon(Icons.add, size: 18, color: Color(0xFFBCBEC0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType,
      {bool isPassword = false, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2F6760),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? !_isPasswordVisible : false,
          validator: validator,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2F6760), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2F6760), width: 2.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            )
                : null,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _genderOption("Female", "assets/images/female.png"),
        const SizedBox(width: 50),
        _genderOption("Male", "assets/images/male.png"),
      ],
    );
  }

  Widget _genderOption(String label, String assetPath) {
    bool isSelected = selectedGender == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = label;
          isGenderValid = true;
        });
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF2F6760) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Image.asset(assetPath, height: 50),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F6760),
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _registerPatient,
        child: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Already have an account? ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginContinueScreen()),
              );
            },
            child: const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2F6760))),
          ),
        ],
      ),
    );
  }

  String? _validateName(String? value) => value == null || value.isEmpty ? "Name is required" : null;
  String? _validateEmail(String? value) => (value == null || value.isEmpty || !RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(value)) ? "Enter a valid email" : null;
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }
}
