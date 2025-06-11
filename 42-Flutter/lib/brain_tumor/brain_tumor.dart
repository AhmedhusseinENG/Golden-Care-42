import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../medicine_reminder/medicine_details.dart';
import '../profile_screen/profile_screen.dart';
import '../ui/assets.dart';

class BrainTumerScreen extends StatefulWidget {
  static const routeName = '/brain-tumer';

  @override
  State<BrainTumerScreen> createState() => _BrainTumerScreenState();
}

class _BrainTumerScreenState extends State<BrainTumerScreen> {
  File? _selectedImage;
  String? _result;
  double? _confidence;
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushNamed(context, HomeScreen.routName);
          break;
        case 1:
          Navigator.pushNamed(context, MedicineDetailsScreen.routName);
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _result = null;
        _confidence = null;
      });
    }
  }

  Future<void> _predictTumor() async {
    if (_selectedImage == null) return;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://renderflaskbraintumor.onrender.com/predict'),
      );

      request.files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print('📦 Raw response: $responseData');

      if (response.statusCode == 200) {
        try {
          var jsonResponse = json.decode(responseData);
          print("✅ JSON Response: $jsonResponse");
          print("🔍 Message: ${jsonResponse['message']}");
          print("🔍 Confidence: ${jsonResponse['confidence']}");

          setState(() {
            _result = jsonResponse['message'];
            _confidence = jsonResponse['confidence'];
          });
        } catch (e) {
          print("❌ Failed to decode JSON: $e");
          print("📦 Response body: $responseData");
          setState(() {
            _result = 'Invalid JSON from server.';
            _confidence = null;
          });
        }
      } else {  // هنا الـ else في نفس مستوى الـ if
        print("❌ Server error: ${response.statusCode}");
        print("📦 Response body: $responseData");
        setState(() {
          _result = 'Prediction failed. Server error';
          _confidence = null;
        });
      }
    } catch (e) {
      print("❌ Error during prediction: $e");
      setState(() {
        _result = 'Prediction failed. Please try again later.';
        _confidence = null;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, HomeScreen.routName);
                      },
                      color: AppColors.primaryColor,
                      iconSize: 30,
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Brain Tumor Detection',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: Image.asset(
                    'assets/images/brain.png',
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please pick a photo to check',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildImagePreview(),
                const SizedBox(height: 30),
                _buildButton('Select Photo', _pickImage),
                const SizedBox(height: 20),
                _buildButton('Predict Output', _predictTumor),
                const SizedBox(height: 20),
                if (_result != null && _result!.isNotEmpty) _buildResultBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _selectedImage != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
        ),
      )
          : const Icon(
        Icons.image_outlined,
        size: 80,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildResultBox() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFEFF8F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              _result ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        ],
      ),
    );
  }



  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F6760),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/images/home.png")),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/images/reminder.png")),
          label: "Medicine Reminder",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/images/measure.png")),
          label: "Measure",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/images/profile.png")),
          label: "Profile",
        ),
      ],
    );
  }
}
