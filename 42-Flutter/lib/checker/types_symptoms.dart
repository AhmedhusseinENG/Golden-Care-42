import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:golden_care_2/checker/result_screen.dart';
import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../medicine_reminder/medicine_details.dart';
import '../profile_screen/profile_screen.dart';
import '../ui/assets.dart';
import 'check_screen.dart';

class TypesSymptoms extends StatefulWidget {
  static const String routName = 'types symptoms';

  @override
  State<TypesSymptoms> createState() => _TypesSymptomsState();
}

class _TypesSymptomsState extends State<TypesSymptoms> {
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
        Navigator.pushReplacementNamed(context, MedicineDetailsScreen.routName);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, ECGScreen.routName);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, ProfileScreen.routName);
        break;
    }
  }

  void navigateToResults() {
    if (selectedSymptoms.length >= 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(selectedSymptoms: selectedSymptoms),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least 2 symptoms")),
      );
    }
  }

  List<Map<String, String>> symptoms = [
    {'name': 'Sore Throat', 'image': 'assets/images/sore_throat.png'},
    {'name': 'Cough', 'image': 'assets/images/cough.png'},
    {'name': 'Headache', 'image': 'assets/images/headache.png'},
    {'name': 'Dizzy', 'image': 'assets/images/dizzy.png'},
    {'name': 'Nausea', 'image': 'assets/images/nauses.png'},
    {'name': 'Short Of Breath', 'image': 'assets/images/short_of_breath (2).png'},
    {'name': 'Blurred Vision', 'image': 'assets/images/blured_vision.png'},
    {'name': 'Stomach Pain', 'image': 'assets/images/stomach.png'},
    {'name': 'Fever', 'image': 'assets/images/fever.png'},
  ];
  List<String> selectedSymptoms = [];

  void toggleSelection(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
    });
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.05),
            Text(
              'Select What You Feel Now',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.primaryColor),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Text(
              'Select At Least 2',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
            SizedBox(height: screenSize.height * 0.1),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: symptoms.length,
                itemBuilder: (context, index) {
                  String symptom = symptoms[index]['name']!;
                  String imagePath = symptoms[index]['image']!;
                  bool isSelected = selectedSymptoms.contains(symptom);
                  return GestureDetector(
                    onTap: () => toggleSelection(symptom),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xff939598) : Color(0xffEFF8F9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(imagePath, height: 40),
                          SizedBox(height: screenSize.height * 0.01),
                          Text(
                            symptom,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedSymptoms.length >= 2 ? AppColors.primaryColor : Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 120, vertical: 17),
              ),
              onPressed: selectedSymptoms.length >= 2 ? navigateToResults : null,
              child: Text(
                'Check',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
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
          BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/home.png")), label: "Home"),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/reminder.png")), label: "Medicine Reminder"),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/measure.png")), label: "Measure"),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/profile.png")), label: "Profile"),
        ],
      ),
    );
  }
}