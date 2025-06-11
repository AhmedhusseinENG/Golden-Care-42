import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'qr_scan_screen.dart';
import 'home_screen/home_screen.dart';
import 'login/loginContinue_screen.dart';
import 'login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';


class CompanionSignupScreen extends StatefulWidget {
  @override
  _CompanionSignupScreenState createState() => _CompanionSignupScreenState();
}

class _CompanionSignupScreenState extends State<CompanionSignupScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController patientIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String? selectedGender;
  bool isGenderValid = true;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> registerCompanion() async {
    final uri = Uri.parse('https://migration.runasp.net/api/Auth/register/companion');

    var request = http.MultipartRequest('POST', uri)
      ..fields['username'] = nameController.text
      ..fields['email'] = emailController.text
      ..fields['password'] = passwordController.text
      ..fields['gender'] = selectedGender ?? ''
      ..fields['patientId'] = patientIdController.text;

    if (_image != null) {
      final mimeType = lookupMimeType(_image!.path);
      final mimeSplit = mimeType?.split('/');
      if (mimeSplit != null && mimeSplit.length == 2) {
        final imageFile = await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        );
        request.files.add(imageFile);
      }
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginContinueScreen()),
        );
      } else {
        final body = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed: ${response.statusCode}")),
        );
        print("Error body: $body");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $e")),
      );
    }
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate() && selectedGender != null) {
      setState(() {
        isGenderValid = true;
      });
      registerCompanion(); // ← استدعاء دالة API
    } else {
      setState(() {
        isGenderValid = selectedGender != null;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildProfileImage(),
            const SizedBox(height: 10),
            _buildTextField("Name", nameController, TextInputType.name, validator: _validateName),
            _buildQRTextField("Patient ID", patientIdController, TextInputType.text, validator: _validatePatientId),
            _buildTextField("Email Address", emailController, TextInputType.emailAddress, validator: _validateEmail),
            _buildPasswordField(),
            _buildGenderSelection(),
            _buildSignupButton(),
            _buildLoginRedirect(),
          ],
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
              padding: const EdgeInsets.all(1.5),
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
      {bool isPassword = false, IconData? icon, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF2F6760))),
        const SizedBox(height: 2),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword,
          validator: validator,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2F6760), width:2.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2F6760), width: 2.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2.5),
            ),
            suffixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildQRTextField(String label, TextEditingController controller, TextInputType keyboardType,
      {String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF2F6760))),
        const SizedBox(height: 2),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2F6760), width:2.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2F6760), width: 2.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2.5),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.grey),
              onPressed: () async {
                final qrCode = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScanScreen()),
                );
                if (qrCode != null) {
                  setState(() {
                    controller.text = qrCode;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF2F6760))),
        const SizedBox(height: 2),
        TextFormField(
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_isPasswordVisible,
          validator: _validatePassword,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2F6760), width: 2.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2F6760), width: 2.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2.5),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _genderOption("Female", "assets/images/female.png"),
            const SizedBox(width: 50),
            _genderOption("Male", "assets/images/male.png"),
          ],
        ),
        if (!isGenderValid)
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text("Please select a gender", style: TextStyle(color: Colors.red, fontSize: 12)),
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _validateAndSubmit,
        child: const Text("Sign UP", style: TextStyle(fontSize: 16, color: Colors.white)),
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
                MaterialPageRoute(builder: (context) => LoginContinueScreen()), // ✅ Navigate to SignupScreen
              );
            },
            child: const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2F6760))),
          ),
        ],
      ),
    );
  }

  String? _validateName(String? value) => value!.isEmpty ? "Name cannot be empty" : null;

  String? _validatePatientId(String? value) => value!.isEmpty ? "Patient ID cannot be empty" : null;

  String? _validateEmail(String? value) => value!.isEmpty || !value.contains('@') ? "Enter a valid email" : null;

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
