import 'package:flutter/material.dart';
import 'package:golden_care_2/checker/types_symptoms.dart';
import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../medicine_reminder/medicine_details.dart';
import '../profile_screen/profile_screen.dart';
import '../ui/assets.dart';
import 'choose_issue.dart';

class CheckScreen extends StatefulWidget {
  static const String routName = 'checker';
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == selectedIndex) return; // تجنب إعادة تحميل نفس الشاشة
    setState(() {
      selectedIndex = index;
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
          onPressed: () => Navigator.pushReplacementNamed(context, HomeScreen.routName),
          iconSize: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenSize.height * 0.1),
            Image.asset(AppImages.symptomChecker, fit: BoxFit.cover, width: 150),
            SizedBox(height: screenSize.height * 0.03),
            Text(
              'Symptom checker',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.primaryColor),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Text(
              'Take Care Of Yourself',
              style: TextStyle(fontSize: 17, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: screenSize.height * 0.15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 17), // فقط رأسي
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, TypesSymptoms.routName);
                    },
                    child: const Text(
                      'Enter\nSymptoms',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 17),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, ChooseIssueScreen.routName);
                    },
                    child: const Text(
                      'More\nDiseases',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
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
}