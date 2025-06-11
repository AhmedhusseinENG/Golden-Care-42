import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Ecg_model/ECG_screen.dart';
import '../../home_screen/home_screen.dart';
import '../../ui/assets.dart';
import '../profile_screen.dart';

class NotificationSettingsScreen extends StatefulWidget {
  static String routName = "notification_settings";

  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool generalNotification = false;
  bool sound = false;
  bool vibrate = false;
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    _fetchNotificationSettings(); // ✅ جلب الإعدادات من الـ API عند فتح الصفحة
  }

  Future<void> _fetchNotificationSettings() async {
    try {
      var response = await http.get(
        Uri.parse("https://yourapi.com/getNotificationSettings"),
        headers: {
          "Authorization": "Bearer YOUR_AUTH_TOKEN", // 🔹 استبدل بالتوكين الحقيقي
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          generalNotification = data["generalNotification"];
          sound = data["sound"];
          vibrate = data["vibrate"];
        });
      } else {
        _showError("Failed to fetch settings");
      }
    } catch (e) {
      _showError("An error occurred. Please try again.");
    }
  }

  Future<void> _updateNotificationSettings(String setting, bool value) async {
    try {
      var response = await http.post(
        Uri.parse("https://yourapi.com/updateNotificationSettings"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_AUTH_TOKEN",
        },
        body: jsonEncode({
          "setting": setting,
          "value": value,
        }),
      );

      if (response.statusCode != 200) {
        _showError("Failed to update settings");
      }
    } catch (e) {
      _showError("An error occurred. Please try again.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

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
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.primaryColor, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Notification Setting',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSwitchTile("General Notification", generalNotification, (value) {
              setState(() => generalNotification = value);
              _updateNotificationSettings("generalNotification", value);
            }),
            _buildSwitchTile("Sound", sound, (value) {
              setState(() => sound = value);
              _updateNotificationSettings("sound", value);
            }),
            _buildSwitchTile("Vibrate", vibrate, (value) {
              setState(() => vibrate = value);
              _updateNotificationSettings("vibrate", value);
            }),
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
        type: BottomNavigationBarType.fixed,
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

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryColor,
            inactiveTrackColor: Color(0xFFD9EAE8),
            inactiveThumbColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
