import 'package:flutter/material.dart';
import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../medicine_reminder/medicine_details.dart';
import '../profile_screen/profile_screen.dart';
import '../ui/assets.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'choose_issue.dart';

class DiseaseDetailScreen extends StatefulWidget {
  static const String routName = 'disease detail';
  final String diseaseName;
  DiseaseDetailScreen({required this.diseaseName});

  @override
  State<DiseaseDetailScreen> createState() => _DiseaseDetailScreenState();
}

class _DiseaseDetailScreenState extends State<DiseaseDetailScreen> {
  int selectedIndex = 0;
  Map<String, dynamic> diseasesData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDiseaseData();
  }

  Future<void> loadDiseaseData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/diseases.json');
      final Map<String, dynamic> data = json.decode(response);

      Map<String, dynamic> diseaseMap = {};
      for (var disease in data['diseases']) {
        diseaseMap[disease['name'].toString().trim().toLowerCase()] = disease;
      }

      setState(() {
        diseasesData = diseaseMap;
        isLoading = false;
      });

      print("تم تحميل الأمراض: ${diseaseMap.keys.toList()}");
    } catch (e) {
      print("خطأ أثناء تحميل البيانات: $e");
    }
  }

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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    String diseaseKey = widget.diseaseName.trim().toLowerCase();
    Map<String, dynamic>? diseaseInfo = diseasesData[diseaseKey];

    String description = diseaseInfo?['description'] ?? "No description available.";
    String treatment = diseaseInfo?['treatment'] ?? "No treatment information available.";

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
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : Padding(
        padding: EdgeInsets.all(20),
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 400,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xffEFF8F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.diseaseName.replaceAll('\n', ' '),
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05),
                Text(
                  "Description:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xffE6E7E8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05),
                Text(
                  "Treatment:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xffE6E7E8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    treatment,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
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
