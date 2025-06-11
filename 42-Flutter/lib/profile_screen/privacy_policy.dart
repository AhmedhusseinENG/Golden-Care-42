import 'package:flutter/material.dart';
import 'package:golden_care_2/profile_screen/profile_screen.dart';
import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../ui/assets.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  static String routName = "privacy_policy";

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushNamed(context, HomeScreen.routName);
          break;
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
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.primaryColor, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle("Privacy Policy for Golden Care"),
            _buildText("Golden Care is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and protect your personal information in compliance with data protection laws."),
            _buildSection("1. Information We Collect", "We collect personal information such as name, email, health data (heart rate, blood pressure), medication details, and user preferences. We may also collect device information and app usage data for analytics purposes."),
            _buildSection("2. How We Use Your Data", "We use your data to monitor health conditions, send alerts to caregivers, provide medicine reminders, and improve user experience. Additionally, we analyze anonymized data to enhance our AI models."),
            _buildSection("3. Data Sharing", "Your data is not shared with third parties unless required by law or for medical emergencies. We do not sell or trade your personal information."),
            _buildSection("4. Data Security", "We implement strong security measures to protect your data, including encryption, secure servers, and restricted access protocols. Your information is stored securely and accessible only by authorized personnel."),
            _buildSection("5. Your Rights", "You have the right to access, modify, or delete your data at any time by contacting our support team. You can also request to download a copy of your data."),
            _buildSection("6. Retention Period", "We retain your personal data only as long as necessary to provide you with our services. After this period, your data is securely deleted."),
            _buildSection("7. Contact Us", "If you have any questions about this Privacy Policy, please contact us through the app's support section or via email at support@goldencare.com."),
          ],
        ),
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

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
    );
  }

  Widget _buildText(String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: Text(
        content,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
