import 'package:flutter/material.dart';
import 'package:golden_care_2/profile_screen/settings/password_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Ecg_model/ECG_screen.dart';
import '../../home_screen/home_screen.dart';
import '../../login/login_screen.dart';
import '../../ui/assets.dart';
import '../profile_screen.dart';
import 'notification_settings.dart';

//✅ تم ربط زر "Delete" في البوب أب بدالة deleteAccount()
// ✅ deleteAccount() تتصل بالـ API لحذف الحساب
// ✅ إذا تم الحذف بنجاح، يتم توجيه المستخدم لشاشة تسجيل الدخول
// ✅ إذا فشل الحذف، يظهر تنبيه للمستخدم

class SettingsScreen extends StatefulWidget {
  static String routName = "settings_screen";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 3;
  final String apiUrl = "https://yourapi.com/deleteAccount"; // رابط API حذف الحساب

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

  // ✅ دالة حذف الحساب
  Future<void> deleteAccount() async {
    try {
      String userId = "12345"; // استبدل بالـ userId الفعلي المخزن عند تسجيل الدخول

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId}),
      );

      if (response.statusCode == 200) {
        // ✅ حذف ناجح → تحويل المستخدم لشاشة تسجيل الدخول
        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routName, (route) => false);
      } else {
        // ❌ فشل الحذف → عرض رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete account. Please try again.")),
        );
      }
    } catch (e) {
      print("Error deleting account: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please check your internet connection.")),
      );
    }
  }

  // ✅ نافذة تأكيد حذف الحساب
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/Rectangle.png", width: 50, height: 50),
              const SizedBox(height: 15),
              const Text("Are You Sure?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("You want to delete Your Account", style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        deleteAccount(); // 🔹 تنفيذ حذف الحساب
                      },
                      child: const Text("Delete", style: TextStyle(fontSize: 16, color: Colors.red)),
                    ),
                  ),
                  Container(height: 40, width: 1, color: Colors.grey[300]),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Keep Account", style: TextStyle(fontSize: 16, color: AppColors.primaryColor)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 90,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.primaryColor, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 15),
          child: Text(
            'Settings',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          children: [
            _buildSettingsOption(
              title: 'Notification Setting',
              imagePath: 'assets/images/noti.png',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSettingsScreen()));
              },
            ),
            const SizedBox(height: 1),
            _buildSettingsOption(
              title: 'Password Manager',
              imagePath: 'assets/images/key.png',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordManagerScreen()));
              },
            ),
            const SizedBox(height: 1),
            _buildSettingsOption(
              title: 'Delete Account',
              imagePath: 'assets/images/pro.png',
              onTap: _showDeleteAccountDialog,
            ),
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

  Widget _buildSettingsOption({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
        leading: Image.asset(imagePath, width: 40, height: 40),
        title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 20, color: AppColors.primaryColor),
        onTap: onTap,
      ),
    );
  }
}
