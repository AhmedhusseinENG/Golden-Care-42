// import 'package:flutter/material.dart';
// import '../Ecg_model/ECG_screen.dart';
// import '../home_screen/home_screen.dart';
// import '../profile_screen/profile_screen.dart';
// import '../ui/assets.dart';
//
// class ResultsScreen extends StatefulWidget {
//   final List<String> selectedSymptoms;
//
//   ResultsScreen({required this.selectedSymptoms});
//
//   @override
//   _ResultsScreenState createState() => _ResultsScreenState();
// }
//
// class _ResultsScreenState extends State<ResultsScreen> {
//   int selectedIndex = 0;
//   Map<String, double> diagnosisResults = {};
//
//   Map<String, List<String>> diseaseSymptoms = {
//     "COVID-19": ["Sore Throat", "Fever", "Short Of Breath", "Cough"],
//     "Influenza (Flu)": ["Fever", "Sore Throat", "Cough", "Headache"],
//     "Migraine": ["Headache", "Dizzy", "Blued Vision"],
//     "Food Poisoning": ["Nausea", "Stomach pain", "Fever"],
//     "Gastritis": ["Stomach pain", "Nausea"],
//     "Asthma": ["Short Of Breath", "Cough"]
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     diagnosisResults = normalizeResults(analyzeSymptoms(widget.selectedSymptoms));
//   }
//
//   Map<String, double> analyzeSymptoms(List<String> selectedSymptoms) {
//     Map<String, double> results = {};
//     diseaseSymptoms.forEach((disease, symptoms) {
//       int matchCount = symptoms.where((s) => selectedSymptoms.contains(s)).length;
//       if (matchCount > 0) {
//         results[disease] = matchCount / symptoms.length;
//       }
//     });
//     return results;
//   }
//
//   Map<String, double> normalizeResults(Map<String, double> results) {
//     double total = results.values.fold(0, (sum, val) => sum + val);
//     if (total == 0) return results;
//     return results.map((key, value) => MapEntry(key, (value / total) * 100));
//   }
//
//   void _onItemTapped(int index) {
//     if (index == selectedIndex) return;
//     setState(() {
//       selectedIndex = index;
//     });
//     switch (index) {
//       case 0:
//         Navigator.pushReplacementNamed(context, HomeScreen.routName);
//         break;
//       case 2:
//         Navigator.pushReplacementNamed(context, ECGScreen.routName);
//         break;
//       case 3:
//         Navigator.pushReplacementNamed(context, ProfileScreen.routName);
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: diagnosisResults.isEmpty
//             ? Center(
//           child: Text(
//             "No results available",
//             style: TextStyle(fontSize: 18, color: Colors.red),
//           ),
//         )
//             : Scrollbar(
//           thumbVisibility: true,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: diagnosisResults.entries.map((entry) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Container(
//                         width: 400,
//                         alignment: Alignment.center,
//                         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: Color(0xffEFF8F9),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           "${entry.value.toStringAsFixed(0)}% ${entry.key}",
//                           style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Container(
//                       padding: EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                         color: Color(0xffE6E7E8),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(
//                         getDiseaseDescription(entry.key),
//                         style: TextStyle(fontSize: 18, color: Colors.black),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: selectedIndex,
//         selectedItemColor: AppColors.primaryColor,
//         unselectedItemColor: Colors.grey,
//         showSelectedLabels: true,
//         showUnselectedLabels: true,
//         onTap: _onItemTapped,
//         items: [
//           BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/home.png")), label: "Home"),
//           BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/reminder.png")), label: "Medicine Reminder"),
//           BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/measure.png")), label: "Measure"),
//           BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/profile.png")), label: "Profile"),
//         ],
//       ),
//     );
//   }
//
//   String getDiseaseDescription(String disease) {
//     Map<String, String> descriptions = {
//       "COVID-19": "COVID-19 can cause respiratory symptoms, fever, sore throat, and shortness of breath. It may also lead to fatigue and loss of taste or smell.",
//       "Influenza (Flu)": "The flu causes fever, sore throat, and respiratory symptoms, including shortness of breath, especially if the bronchial tubes are affected.",
//       "Migraine": "Migraine often causes severe headaches, dizziness, and sensitivity to light or sound.",
//       "Food Poisoning": "Food poisoning causes nausea, stomach pain, and fever due to bacterial contamination in food.",
//       "Gastritis": "Gastritis is the inflammation of the stomach lining, causing nausea and stomach pain.",
//       "Asthma": "Asthma can cause shortness of breath and coughing due to airway inflammation."
//     };
//     return descriptions[disease] ?? "No description available.";
//   }
// }



// مرضين اتنين بس

import 'package:flutter/material.dart';
import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../ui/assets.dart';

class ResultsScreen extends StatefulWidget {
  final List<String> selectedSymptoms;

  ResultsScreen({required this.selectedSymptoms});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int selectedIndex = 0;
  Map<String, double> diagnosisResults = {};

  Map<String, List<String>> diseaseSymptoms = {
    "COVID-19": ["Sore Throat", "Fever", "Short Of Breath", "Cough"],
    "Influenza (Flu)": ["Fever", "Sore Throat", "Cough", "Headache"],
    "Migraine": ["Headache", "Dizzy", "Blued Vision"],
    "Food Poisoning": ["Nausea", "Stomach pain", "Fever"],
    "Gastritis": ["Stomach pain", "Nausea"],
    "Asthma": ["Short Of Breath", "Cough"]
  };

  @override
  void initState() {
    super.initState();
    diagnosisResults = normalizeResults(analyzeSymptoms(widget.selectedSymptoms));
  }

  Map<String, double> analyzeSymptoms(List<String> selectedSymptoms) {
    Map<String, double> results = {};
    diseaseSymptoms.forEach((disease, symptoms) {
      int matchCount = symptoms.where((s) => selectedSymptoms.contains(s)).length;
      if (matchCount > 0) {
        results[disease] = matchCount / symptoms.length;
      }
    });
    return results;
  }

  Map<String, double> normalizeResults(Map<String, double> results) {
    if (results.isEmpty) return {};

    var topResults = results.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    topResults = topResults.take(2).toList();

    double total = topResults.fold(0, (sum, entry) => sum + entry.value);
    if (total == 0) return {};

    return {for (var entry in topResults) entry.key: (entry.value / total) * 100};
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: diagnosisResults.isEmpty
            ? Center(
          child: Text(
            "No results available",
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: diagnosisResults.entries.map((entry) {
            return Column(
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
                      "${entry.value.toStringAsFixed(0)}% ${entry.key}",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xffE6E7E8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    getDiseaseDescription(entry.key),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ),
                SizedBox(height: 30),
              ],
            );
          }).toList(),
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

  String getDiseaseDescription(String disease) {
    Map<String, String> descriptions = {
      "COVID-19": "COVID-19 can cause respiratory symptoms, fever, sore throat, and shortness of breath. It may also lead to fatigue and loss of taste or smell.",
      "Influenza (Flu)": "The flu causes fever, sore throat, and respiratory symptoms, including shortness of breath, especially if the bronchial tubes are affected.",
      "Migraine": "Migraine often causes severe headaches, dizziness, and sensitivity to light or sound.",
      "Food Poisoning": "Food poisoning causes nausea, stomach pain, and fever due to bacterial contamination in food.",
      "Gastritis": "Gastritis is the inflammation of the stomach lining, causing nausea and stomach pain.",
      "Asthma": "Asthma can cause shortness of breath and coughing due to airway inflammation."
    };
    return descriptions[disease] ?? "No description available.";
  }
}
