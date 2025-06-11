import 'package:flutter/material.dart';
import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../medicine_reminder/medicine_details.dart';
import '../profile_screen/profile_screen.dart';
import '../shared_preferences_helper.dart';
import '../ui/assets.dart';

import 'companion_notification.dart'; // استدعاء شاشة المرافق

class PatientNotificationScreen extends StatefulWidget {
  static const String routName = 'notification for patient';

  @override
  State<PatientNotificationScreen> createState() => _PatientNotificationScreenState();
}

class _PatientNotificationScreenState extends State<PatientNotificationScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final isPatient = await SharedPreferencesHelper.isPatient();
    if (isPatient == false) {
      // المستخدم مرافق، نحوله لشاشة نوتيفيكيشن المرافق
      Navigator.pushReplacementNamed(context, CompanionNotificationScreen.routName);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 30,
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Today', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Color(0xff757575))),
          const SizedBox(height: 10),
          NotificationTile(
            image: 'assets/images/graduated.jpg',
            text: 'Aml wants to become your companion',
            time: '9:01am',
            buttonText: 'ACCEPT',
            onPressed: () {
              // API integration later
            },
          ),
          NotificationTile(
            icon: Icons.notifications,
            text: "It's time to take the medicine (Panadol)",
            time: '8:01am',
            buttonText: 'CONFIRM',
            onPressed: () {
              // API integration later
            },
          ),
          const SizedBox(height: 20),
          const Text('Yesterday', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Color(0xff757575))),
          const SizedBox(height: 10),
          NotificationTile(
            image: 'assets/images/person3.png',
            text: 'Salma requested to become your companion',
            time: '9:01am',
            buttonText: 'ACCEPT',
            onPressed: () {
              // API integration later
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

/// 👇 الكلاس المساعد NotificationTile
class NotificationTile extends StatelessWidget {
  final String? image;
  final IconData? icon;
  final String text;
  final String time;
  final String buttonText;
  final VoidCallback onPressed;

  const NotificationTile({
    super.key,
    this.image,
    this.icon,
    required this.text,
    required this.time,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null)
              CircleAvatar(backgroundImage: AssetImage(image!), radius: 24)
            else if (icon != null)
              Icon(icon, color: Colors.red, size: 45),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (buttonText.isNotEmpty)
                        SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: onPressed,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              backgroundColor: AppColors.primaryColor,
                            ),
                            child: Text(
                              buttonText,
                              style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}