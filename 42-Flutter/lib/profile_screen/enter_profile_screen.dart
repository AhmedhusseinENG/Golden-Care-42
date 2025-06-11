import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:golden_care_2/profile_screen/profile_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../ui/assets.dart';

class EnterProfileScreen extends StatefulWidget {
  static String routName = "enter_profile_screen";
  final bool isPatient;

  const EnterProfileScreen({Key? key, required this.isPatient}) : super(key: key);

  @override
  _EnterProfileScreenState createState() => _EnterProfileScreenState();
}

class _EnterProfileScreenState extends State<EnterProfileScreen> {
  int _selectedIndex = 3;
  bool _isEditing = false;
  bool _isPasswordVisible = false;
  bool _isLoading = true;
  String? _passwordError;
  String? patientID;

  late TextEditingController _nameController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late TextEditingController _userTypeController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _genderController = TextEditingController();
    _emailController = TextEditingController();
    _userTypeController = TextEditingController();
    _passwordController = TextEditingController();

    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');

      if (userDataString != null) {
        final data = jsonDecode(userDataString);

        final String role = data['role'] ?? '';
        final String userId = data['patientId'] ?? data['id'] ?? '';

        setState(() {
          _nameController.text = data['username'] ?? '';
          _genderController.text = data['gender'] ?? '';
          _emailController.text = data['email'] ?? '';
          _userTypeController.text = role;
          _passwordController.text = "********";
          patientID = role == 'patient' ? userId : null;
          _isLoading = false;
        });
      } else {
        print('No user data found in SharedPreferences');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print("Error loading profile: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
        case 1:
          Navigator.pushNamed(context, HomeScreen.routName);
          break;
        case 2:
          Navigator.pushNamed(context, ECGScreen.routName);
          break;
        case 3:
          Navigator.pushNamed(context, ProfileScreen.routName);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.primaryColor, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Profile',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    if (_userTypeController.text.toLowerCase() == 'patient')
                      Column(
                        children: [
                          QrImageView(
                            data: patientID!, // هذا هو الـ ID الفعلي للمريض
                            version: QrVersions.auto,
                            size: 120.0,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Scan To Get Your ID",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      )
                    else // يعني مرافق
                      const Text(
                        "Companion",
                        style: TextStyle(fontSize: 24, color: Colors.grey),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              buildTextField('Full Name', _nameController),
              buildTextField('Gender', _genderController),
              buildTextField('Email', _emailController),
              buildTextField('User Type', _userTypeController),
              buildPasswordField(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });

                    if (!_isEditing) {
                      // ممكن تعملي هنا update للـ SharedPreferences لو عايزة تحفظي التعديلات
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F6760),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    _isEditing ? 'Save Profile' : 'Update Profile',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF20544D),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/home.png")), label: "Home"),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/reminder.png")), label: "Medicine Reminder"),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/measure.png")), label: "Measure"),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/profile.png")), label: "Profile"),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextField(
            obscureText: obscureText,
            readOnly: !_isEditing,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFD9EAE8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Password", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFD9EAE8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
