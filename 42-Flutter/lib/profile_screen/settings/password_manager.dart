import 'package:flutter/material.dart';
import '../../Ecg_model/ECG_screen.dart';
import '../../forgot_ password_screen/forgot_password.dart';
import '../../home_screen/home_screen.dart';
import '../../ui/assets.dart';
import '../profile_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class PasswordManagerScreen extends StatefulWidget {
  static String routName = "password_manager";

  @override
  _PasswordManagerScreenState createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscuredCurrent = true;
  bool _isObscuredNew = true;
  bool _isObscuredConfirm = true;

  int _selectedIndex = 3;

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
          Navigator.pushReplacementNamed(context, HomeScreen.routName);

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
  Future<void> _changePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // 🔹 التحقق من صحة المدخلات
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields."), backgroundColor: Colors.red),
      );
      return;
    }
    if (!isValidPassword(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password must be at least 8 characters, include uppercase, lowercase, number, and special character."), backgroundColor: Colors.red),
      );
      return;
    }
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match!"), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      // 🔹 تجهيز البيانات للإرسال
      String userId = "12345"; // يجب جلبه من التخزين المحلي أو الـ Auth
      var response = await http.post(
        Uri.parse("https://yourapi.com/changePassword"), // 🔹 رابط الـ API
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_AUTH_TOKEN" // استبدل بالتوكين الحقيقي
        },
        body: jsonEncode({
          "userId": userId,
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        }),
      );

      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"]), backgroundColor: Colors.green),
        );

        // 🔹 تفريغ الحقول بعد النجاح
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"]), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again."), backgroundColor: Colors.red),
      );
    }
  }
  bool isValidPassword(String password) {

    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.primaryColor, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Password Manager',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Current Password"),
            _buildPasswordField(_currentPasswordController, _isObscuredCurrent, () {
              setState(() => _isObscuredCurrent = !_isObscuredCurrent);
            }),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            _buildLabel("New Password"),
            _buildPasswordField(_newPasswordController, _isObscuredNew, () {
              setState(() => _isObscuredNew = !_isObscuredNew);
            }),
            _buildLabel("Confirm New Password"),
            _buildPasswordField(_confirmPasswordController, _isObscuredConfirm, () {
              setState(() => _isObscuredConfirm = !_isObscuredConfirm);
            }),
            const Spacer(),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: _changePassword, // 🔹 تنفيذ دالة تغيير الباسورد عند الضغط
                  child: const Text(
                    "Change Password",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, bool isObscured, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: isObscured,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFD9EAE8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        suffixIcon: IconButton(
          icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}