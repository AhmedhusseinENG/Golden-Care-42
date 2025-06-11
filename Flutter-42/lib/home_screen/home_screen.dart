import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:golden_care_2/checker/check_screen.dart';
import 'package:golden_care_2/doctor_details/doctor_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Ecg_model/ECG_screen.dart';
import '../brain_tumor/brain_tumor.dart';
import '../login/loginContinue_screen.dart';
import '../medicine_reminder/medicine_details.dart';
import '../notifications/patient_notification.dart';
import '../profile_screen/profile_screen.dart';
import '../ui/assets.dart';
import 'HealthDataProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


class HomeScreen extends StatefulWidget {
  static const String routName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  String username = 'John Doe'; // الاسم الافتراضي
  String profileImage = AppImages.userImage; // صورة البروفايل الافتراضية
  String bpCategory = 'No Result';
  double? sbp;
  double? dbp;
  bool isBpLoading = false;
  Timer? _autoUpdateTimer;


  @override
  void initState() {
    super.initState();
    _loadUserData(); // تحميل بيانات المستخدم من SharedPreferences
    _startAutoUpdate(); // <-- هذه السطر الجديد

  }

  // تحميل بيانات المستخدم من SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final userData = jsonDecode(userDataString);

      setState(() {
        username = userData['username'] ?? 'John Doe';
        profileImage = userData['image'] != null
            ? 'https://migration.runasp.net${userData['image']}'
            : AppImages.userImage;
      });
    }
  }

  Future<void> _predictBloodPressure() async {
    setState(() {
      isBpLoading = true;
    });

    try {
      final url = Uri.parse('https://render-app-bloodpressureprediction.onrender.com/predict-abp');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          bpCategory = data['bp_category'] ?? 'Unknown';
          sbp = data['sbp'];
          dbp = data['dbp'];
        });
      } else {
        setState(() {
          bpCategory = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        bpCategory = 'Failed to connect';
      });
    } finally {
      setState(() {
        isBpLoading = false;
      });
    }
  }

  void _startAutoUpdate() {
    _autoUpdateTimer?.cancel(); // لو فيه مؤقت شغال، نلغيه
    _autoUpdateTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      _predictBloodPressure(); // يعمل بريديكت كل 15 ثانية
    });
  }

  @override
  void dispose() {
    _autoUpdateTimer?.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, LoginContinueScreen.routName);
                      },
                      color: AppColors.primaryColor,
                      iconSize: 30,
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: profileImage.startsWith('http')
                          ? NetworkImage(profileImage)
                          : AssetImage(profileImage) as ImageProvider,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Hi, Welcome\n$username", // عرض اسم المستخدم الذي تم تحميله
                        style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, PatientNotificationScreen.routName);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    'assets/images/ecg_demo2.gif',
                    fit: BoxFit.contain,
                    width:double.infinity,
                    height: 150,
                  ),
                ),
                SizedBox(height: 24),
                Consumer<HealthDataProvider>(
                  builder: (context, healthData, child) {
                    if (healthData.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (healthData.hasError) {
                      return Center(child: Text(healthData.errorMessage));
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildHeartRateCard(healthData.heartRate)),
                            SizedBox(width: 16),
                            Expanded(child: _buildSpO2Card(healthData.spo2)),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildBloodPressureCard(),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildBrainTumorCard(context)),
                            SizedBox(width: 12),
                            Expanded(child: _buildHeartDetectionCard(context)),
                          ],
                        ),
                        SizedBox(height: 24),
                        _buildCheckYourSelfButton(context),
                        SizedBox(height: 8),
                        _buildAddDoctorButton(context),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
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

  Widget _buildHeartRateCard(double heartRate) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Text(
                'Heart Rate',
                style: TextStyle(color: Color(0xffAF1F24), fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                '$heartRate BPM',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffAF1F24)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpO2Card(double spO2) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SpO2',
                    style: TextStyle(color: Color(0xff2F6861), fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$spO2%',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff2F6861)),
                  ),
                ],
              ),
              Image.asset(
                AppImages.bloodDrop,
                width: 40,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBloodPressureCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xffD9EFFC), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            AppImages.bloodPressure,
            width: 80,
            fit: BoxFit.fill,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Blood Pressure',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff4C9AD4)),
              ),
              if (isBpLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: CircularProgressIndicator(),
                )
              else
                Text(
                  '$bpCategory${(sbp != null && dbp != null) ? ' (${sbp!.toStringAsFixed(0)}/${dbp!.toStringAsFixed(0)})' : ''}',
                  style: const TextStyle(fontSize: 16, color: Color(0xff356DB6)),
                ),
            ],
          ),
          ElevatedButton(
            onPressed: _predictBloodPressure,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: const Color(0xff4389C8),
            ),
            child: const Text(
              'start',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildBrainTumorCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, BrainTumerScreen.routeName);
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.brainTumor,
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 12),
              const Text(
                'Brain Tumor Detection',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff4389C8), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeartDetectionCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, ECGScreen.routName);
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(color: const Color(0xffFDE9EA), borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.heartModel,
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 12),
              const Text(
                'Heart Rate Detection',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff8E4A77), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckYourSelfButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, CheckScreen.routName);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xffEFF7EE), borderRadius: BorderRadius.circular(15)),
          child: const Center(
              child: Text('Check Your Self', style: TextStyle(color: Color(0xff2F6861), fontSize: 16, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }

  Widget _buildAddDoctorButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, DoctorListScreen.routName);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xffD9EBE8), borderRadius: BorderRadius.circular(15)),
          child: const Center(
              child: Text('Add Doctor', style: TextStyle(color: Color(0xff2F6861), fontSize: 16, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}