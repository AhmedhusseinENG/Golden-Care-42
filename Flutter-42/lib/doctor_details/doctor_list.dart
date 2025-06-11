import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../../ui/assets.dart';
import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../medicine_reminder/medicine_details.dart';
import '../profile_screen/profile_screen.dart';
import 'doctor_number.dart';

class DoctorListScreen extends StatefulWidget {
  static const String routName = 'doctor list';
  final Map<String, String>? newDoctor;

  DoctorListScreen({this.newDoctor});

  static List<Map<String, String>> doctors = [];

  @override
  State<DoctorListScreen> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorListScreen> {
  int selectedIndex = 0;
  bool _isAddingDoctor = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specialistController = TextEditingController();

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

  void _toggleAddDoctor() {
    setState(() {
      _isAddingDoctor = !_isAddingDoctor;
    });
  }

  // Method to call the phone number and open dialer
  void _callPhone(String phoneNumber) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (res == null || !res) {
      print("Could not open the phone dialer.");
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
        title: Text(
          "Doctor List",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w400,
            fontSize: 25,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: DoctorListScreen.doctors.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: AppColors.primaryColor, width: 2),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            DoctorListScreen.doctors[index]['name'] ?? 'Unknown',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          subtitle: Text(
                            DoctorListScreen.doctors[index]['specialist'] ?? 'No Specialization',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.call, color: Colors.green, size: 30),
                            onPressed: () {
                              final phone = DoctorListScreen.doctors[index]['phone'] ?? '';
                              _callPhone(phone);  // Calling method to open the dialer
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isAddingDoctor ? 0 : -400,
            left: 0,
            right: 0,
            child: Visibility(
              visible: _isAddingDoctor,
              child: Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 2)],
                ),
                child: Column(
                  children: [
                    Text(
                      "Add Doctor",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primaryColor),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    _buildTextField("Name", _nameController),
                    SizedBox(height: screenSize.height * 0.02),
                    _buildTextField("Phone Number", _phoneController, keyboardType: TextInputType.phone),
                    SizedBox(height: screenSize.height * 0.02),
                    _buildTextField("Specialist In", _specialistController),
                    SizedBox(height: screenSize.height * 0.04),
                    Center(
                      child: SizedBox(
                        width: screenSize.width * 0.7,
                        height: screenSize.height * 0.06,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_nameController.text.isNotEmpty &&
                                _phoneController.text.isNotEmpty &&
                                _specialistController.text.isNotEmpty) {
                              final doctor = {
                                'name': _nameController.text,
                                'phone': _phoneController.text,
                                'specialist': _specialistController.text
                              };
                              setState(() {
                                DoctorListScreen.doctors.add(doctor);
                                _nameController.clear();
                                _phoneController.clear();
                                _specialistController.clear();
                                _isAddingDoctor = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: Text("Add Doctor", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: !_isAddingDoctor
          ? Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 20),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: _toggleAddDoctor,
            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.add, color: Colors.white, size: 40),
          ),
        ),
      )
          : null,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primaryColor),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: _textFieldBorder(),
            focusedBorder: _textFieldBorder(),
            focusedErrorBorder: _textFieldBorder(borderColor: Colors.red),
            errorBorder: _textFieldBorder(borderColor: Colors.red),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
        ),
      ],
    );
  }

  InputBorder _textFieldBorder({Color borderColor = AppColors.primaryColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: borderColor, width: 2),
    );
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
}