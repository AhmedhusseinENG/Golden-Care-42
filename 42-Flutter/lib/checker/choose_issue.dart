import 'package:flutter/material.dart';
import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../medicine_reminder/medicine_details.dart';
import '../profile_screen/profile_screen.dart';
import '../ui/assets.dart';
import 'disease_detail.dart';
// استيراد ProfileScreen من الملف profile_screen.dart مع اسم مستعار
import 'package:golden_care_2/profile_screen/profile_screen.dart' as profile;

// استيراد ProfileScreen من الملف disease_detail.dart مع اسم مستعار
import 'package:golden_care_2/checker/disease_detail.dart' as disease;


class ChooseIssueScreen extends StatefulWidget {
  static const String routName = 'choose issue';

  @override
  State<ChooseIssueScreen> createState() => _ChooseIssueScreenState();
}

class _ChooseIssueScreenState extends State<ChooseIssueScreen> {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == selectedIndex) return;

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

  final List<String> diseases = [
    "Abdominal Hernia",
    "Influenza",
    "Diabetes",
    "Deep Vein Thrombosis",
    "Crohn's Disease",
    "Sepsis",
    "Conjunctivitis",
    "Epilepsy",
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Choose Your Issue",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.08),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.8,
                ),
                itemCount: diseases.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DiseaseDetailScreen(diseaseName: diseases[index]),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffEFF8F9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Text(
                        diseases[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
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
        items: [
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/home.png")),
              label: "Home"),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/reminder.png")),
              label: "Medicine Reminder"),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/measure.png")),
              label: "Measure"),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/profile.png")),
              label: "Profile"),
        ],
      ),
    );
  }
}