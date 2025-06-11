import 'package:flutter/material.dart';
import 'package:golden_care_2/profile_screen/profile_screen.dart';
import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../medicine_reminder/medicine_details.dart';
import '../ui/assets.dart';


class AboutUsScreen extends StatefulWidget {
  static const String routName = 'aboutUs';

  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  int selectedIndex = 3;

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

  final List<Map<String, String>> teamMembers = [
    {
      'name': 'eng/Salma Hamdi',
      'role': 'Hardware/flutter Developer',
      'study': 'Artificial Intelligence',
      'image': 'assets/images/salma66.jpg',
    },
    {
      'name': 'eng:Nagwa Hamada',
      'role': 'flutter Developer',
      'study': 'Artificial Intelligence',
      'image': 'assets/images/Nagwa3.jpg',
    },
    {
      'name': 'eng:Rana Osama',
      'role': 'flutter Developer',
      'study': 'Artificial Intelligence',
      'image': 'assets/images/Rana1.jpg',
    },
    {
      'name': 'eng:Hassan Soliman',
      'role': 'AI Specialist',
      'study': 'Artificial Intelligence',
      'image': 'assets/images/hassan.jpg',
    },
    {
      'name': 'eng:Ahmed Hussein',
      'role': 'Backend Developer',
      'study': 'Artificial Intelligence',
      'image': 'assets/images/ahmed.jpg',
    },
    {
      'name': 'eng:Kareem Ayman',
      'role': 'UI/UX Designer/AI',
      'study': 'Artificial Intelligence',
      'image': 'assets/images/Kareem.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(color: AppColors.primaryColor,fontSize: 28, fontWeight: FontWeight.bold,),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                "Golden Care Team",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: teamMembers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final member = teamMembers[index];
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(member['image']!),
                      ),
                      SizedBox(height: 10),
                      Text(
                        member['name']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        member['role']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        member['study']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 30),
              Divider(color: Colors.grey),
              SizedBox(height: 20),
              Text(
                "We are a passionate team of developers committed to creating innovative healthcare solutions.\n\n"
                    "With a strong background in mobile development and AI technologies, "
                    "we strive to improve people's lives through smart and user-friendly applications.\n\n"
                    "Our mission is to make healthcare more accessible, efficient, and intuitive — "
                    "because we believe everyone deserves the best care, everywhere, anytime.\n\n"
                    "Powered by Golden Care Team.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
