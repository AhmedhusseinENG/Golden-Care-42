import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../notifications/patient_notification.dart';
import '../profile_screen/profile_screen.dart';
import '../ui/assets.dart';
import 'add_medicine.dart';

class MedicineDetailsScreen extends StatefulWidget {
  static const String routName = 'medicine details';

  const MedicineDetailsScreen({Key? key}) : super(key: key);

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  int selectedIndex = 1;
  List<Map<String, dynamic>> medicines = [];

  @override
  void initState() {
    super.initState();
    fetchMedicinesFromApi();
  }

  Future<void> fetchMedicinesFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? patientId = prefs.getString('patientId');

    if (patientId == null) {
      print('❌ patientID not found in SharedPreferences');
      return;
    }

    final String apiUrl =
        "https://migration.runasp.net/api/Medicine/getAllMedicines/$patientId";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Data from API: $data');  // طباعة البيانات للتأكد

        setState(() {
          // تحويل كل عنصر إلى Map<String, dynamic>
          medicines = data.cast<Map<String, dynamic>>();
          // تأكد من إضافة isTakenList لكل دواء بناءً على timesPerDay أو medicineNumTimes
          for (var med in medicines) {
            int times = med['medicineNumTimes'] ?? 1;
            med['isTakenList'] = List.generate(times, (_) => false);
          }
        });
      } else {
        print('❌ Failed to load medicines: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching medicines: $e');
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
          fetchMedicinesFromApi();  // جلب الأدوية عند اختيار التبويب
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

  List<Widget> buildMedicineCards(Map<String, dynamic> medicine, Size screenSize) {
    final int intervalHours = medicine['medicineNumTimes'] ?? 12;  // كل كم ساعة الجرعة
    final int dosesPerDay = (24 / intervalHours).floor();

    final String? startTimeString = medicine['startTime'];
    DateTime startDateTime;

    try {
      startDateTime = DateTime.parse(startTimeString!);
    } catch (e) {
      final now = DateTime.now();
      startDateTime = DateTime(now.year, now.month, now.day, 0, 0);  // 12 AM افتراضيًا
    }

    return List.generate(dosesPerDay, (index) {
      final DateTime doseDateTime = startDateTime.add(Duration(hours: intervalHours * index));
      final TimeOfDay doseTime = TimeOfDay(hour: doseDateTime.hour, minute: doseDateTime.minute);
      return _buildMedicineCard(medicine, doseTime, screenSize, index);
    });
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomeScreen.routName);
          },
          iconSize: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade100, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search your records',
                                hintStyle: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(Icons.search, color: AppColors.primaryColor, size: 30),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenSize.width * 0.03),
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
              SizedBox(height: screenSize.height * 0.03),
              Center(
                child: Text(
                  'Your Medications Today',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),

              // عرض الأدوية
              medicines.isNotEmpty
                  ? Column(
                children: medicines.expand((medicine) {
                  return buildMedicineCards(medicine, screenSize);
                }).toList(),
              )
                  : Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    'No medicines found. Please add a medicine.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // زر الإضافة
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 50,
            child: SizedBox(
              width: 70,
              height: 70,
              child: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMedicineScreen(isEdit: false),
                    ),
                  );
                  if (result != null && result is Map<String, dynamic>) {
                    setState(() {
                      int calculatedTimesPerDay = (24 / (result['medicineNumTimes'] ?? 6)).round();
                      medicines.add({
                        ...result,
                        'timesPerDay': calculatedTimesPerDay,
                        'isTakenList': List.generate(calculatedTimesPerDay, (_) => false),
                      });
                    });
                  }
                },
                backgroundColor: AppColors.primaryColor,
                child: Icon(Icons.add, color: Colors.white, size: 40),
              ),
            ),
          ),
        ],
      ),

      // شريط التنقل السفلي
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMedicineCard(
      Map<String, dynamic> medicine,
      TimeOfDay doseTime,
      Size screenSize,
      int doseIndex,
      ) {
    final String? imageUrl = medicine['medicineImagePath'];
    final String imageFullUrl = imageUrl != null ? 'https://migration.runasp.net$imageUrl' : '';
    final List<bool> isTakenList = medicine['isTakenList'] ?? [];

    // تأكد من أن doseIndex ضمن حدود isTakenList
    final bool isTaken = (doseIndex >= 0 && doseIndex < isTakenList.length) ? isTakenList[doseIndex] : false;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ListTile(
                    title: Text(
                      medicine['medicineName'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Color(0xff003F5F),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${medicine['medicineDosage'] ?? ''} mg',
                          style: TextStyle(
                            color: Color(0xff003F5F),
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 4,
                          children: [
                            Text(
                              'Every ',
                              style: TextStyle(
                                color: Color(0xff003F5F),
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${medicine['medicineNumTimes'] ?? ''}',
                              style: TextStyle(
                                color: Color(0xff003F5F),
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              ' hours | ',
                              style: TextStyle(
                                color: Color(0xff003F5F),
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${(24 / (medicine['medicineNumTimes'] ?? 1)).floor()}',
                              style: TextStyle(
                                color: Color(0xff003F5F),
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              ' times a day',
                              style: TextStyle(
                                color: Color(0xff003F5F),
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: imageFullUrl.isNotEmpty
                        ? Image.network(imageFullUrl, fit: BoxFit.cover)
                        : Icon(Icons.medication, size: 100, color: Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.05),
            Row(
              children: [
                Icon(Icons.notifications, color: Colors.red, size: 30),
                SizedBox(width: screenSize.width * 0.01),
                Text('Reminders', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                Spacer(),
              ],
            ),
            SizedBox(height: screenSize.height * 0.015),

            // وقت الجرعة مع زر التأكيد
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  doseTime.format(context),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: AppColors.primaryColor,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    // فتح شاشة التعديل مع تمرير بيانات الدواء
                    final updatedMedicine = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMedicineScreen(
                          isEdit: true,
                          existingName: medicine['medicineName'],
                          existingDosage: medicine['medicineDosage']?.toString(),
                          existingTime: TimeOfDay(
                            hour: doseTime.hour,
                            minute: doseTime.minute,
                          ),
                          existingImage: null, // لو عندك صورة، حولها لـ File
                          existingHours: medicine['medicineNumTimes'],
                          existingId: medicine['medicineID'], // ← هذا هو الأهم، لازم تبعتي المعرف هنا

                          // إذا لديك معرف الدواء مثلاً existingId: medicine['id'],
                        ),
                      ),
                    );

                    if (updatedMedicine != null && updatedMedicine is Map<String, dynamic>) {
                      setState(() {
                        // تحديث بيانات الدواء في قائمة medicines
                        int medicineIndex = medicines.indexOf(medicine);
                        if (medicineIndex != -1) {
                          medicines[medicineIndex] = {
                            ...medicines[medicineIndex],
                            ...updatedMedicine,
                          };
                        }
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(Icons.edit, color: AppColors.primaryColor, size: 30),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
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
}