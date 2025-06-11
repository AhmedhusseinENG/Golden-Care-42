import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_screen/home_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../ui/assets.dart';
import 'ecg_provider.dart';

class ECGScreen extends StatefulWidget {
  static String routName = "ecg model";

  @override
  _ECGScreenState createState() => _ECGScreenState();
}

class _ECGScreenState extends State<ECGScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
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

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40), // مسافة بين أعلى الشاشة والسهم
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.primaryColor,size: 30,),
              onPressed: () => Navigator.pushReplacementNamed(context, HomeScreen.routName),
            ),
            SizedBox(height: 20), // مسافة قبل النص
            Center(
              child: Text(
                "Check the heart rate",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
              ),
            ),
            Spacer(flex:2), // دفع الصورة لأسفل بشكل متناسق
            Center(
              child: Image.asset(
                'assets/images/ecg_demo2.gif',
                fit: BoxFit.contain, // ضمان ظهور الصورة بالكامل
                width:double.infinity,
                height: 150,
              ),
            ),
            Spacer(flex: 1), // مسافة بين الصورة والنص
            Center(
              child: Text(
                "Heart rate",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
              ),
            ),
            Spacer(flex: 1), // دفع المستطيل لأسفل قليلًا
            Consumer<ECGProvider>(
              builder: (context, provider, child) {
                bool isFirstTime = provider.result.isEmpty && provider.status != ECGStatus.loading;

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(30),
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Result", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                            SizedBox(height: 5),
                            provider.status == ECGStatus.loading
                                ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green), // لون التحميل أخضر
                            )
                                : Text(provider.result, style: TextStyle(fontSize: 16, color: AppColors.primaryColor)),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: provider.status == ECGStatus.loading
                            ? null
                            : () async => await provider.startMeasurement(),
                        child: Text(
                          "Check",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),


                    ],
                  ),
                );
              },
            ),


            Spacer(flex: 2), // مسافة صغيرة بين المستطيل والديفايدر
            Divider(height: 30, color: Colors.grey),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
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