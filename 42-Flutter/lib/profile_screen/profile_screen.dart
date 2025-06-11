import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../medicine_reminder/medicine_details.dart';
import '../ui/assets.dart';
import 'enter_profile_screen.dart';
import 'help_screen.dart';
import 'privacy_policy.dart';
import 'settings/settings.dart';
import 'about_us.dart';

class ProfileScreen extends StatefulWidget {
  static String routName = "profile_screen";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;
  bool _showLogoutBox = false;
  File? _image;
  String _userName = '';
  String _profileImage = 'assets/images/default_profile.png';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final userData = jsonDecode(userDataString);

      setState(() {
        _userName = userData['username'] ?? 'User Name';
        _profileImage = userData['image'] != null
            ? 'https://migration.runasp.net${userData['image']}'
            : 'assets/images/default_profile.png';
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _saveProfileImage(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfileImage(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', imagePath);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, HomeScreen.routName);
          break;
        case 1:
          Navigator.pushNamed(context, MedicineDetailsScreen.routName);
          break;
        case 2:
          Navigator.pushReplacementNamed(context, ECGScreen.routName);
          break;
        case 3:
          Navigator.pushReplacementNamed(context, ProfileScreen.routName);
          break;
      }
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, HomeScreen.routName); // أو صفحة تسجيل الدخول
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider profileImageProvider;
    if (_image != null) {
      profileImageProvider = FileImage(_image!);
    } else if (_profileImage.startsWith('http')) {
      profileImageProvider = NetworkImage(_profileImage);
    } else {
      profileImageProvider = AssetImage(_profileImage);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: AppColors.primaryColor, size: 24),
          onPressed: () => Navigator.pushReplacementNamed(context, HomeScreen.routName),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'My Profile',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: profileImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: const Icon(Icons.camera_alt, color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _userName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildProfileOption('Profile', 'assets/images/green profile.png', onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EnterProfileScreen(isPatient: false)));
                    }),
                    const SizedBox(height: 10),
                    _buildProfileOption('Privacy Policy', 'assets/images/privacy.png', onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
                    }),
                    const SizedBox(height: 10),
                    _buildProfileOption('Settings', 'assets/images/settings.png', onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                    }),
                    const SizedBox(height: 10),
                    _buildProfileOption('Help', 'assets/images/help.png', onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HelpCenterScreen()));
                    }),
                    const SizedBox(height: 10),
                    _buildProfileOption('About Us', 'assets/images/about.png', onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen()));
                    }),
                    const SizedBox(height: 10),
                    _buildProfileOption('Logout', 'assets/images/logout.png', isLogout: true, onTap: () {
                      setState(() {
                        _showLogoutBox = true;
                      });
                    }),
                  ],
                ),
              ),
            ],
          ),
          if (_showLogoutBox)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Are you sure you want to logout?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showLogoutBox = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD9EAE8),
                            padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          child: const Text(
                            "Yes, Logout",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryColor,
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

  Widget _buildProfileOption(String title, String iconPath, {bool isLogout = false, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      leading: Image.asset(iconPath, width: 50, height: 50),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }
}
