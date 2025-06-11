import 'package:flutter/material.dart';
import 'package:golden_care_2/profile_screen/profile_screen.dart';
import '../ui/assets.dart';
import '../home_screen/home_screen.dart';
import '../Ecg_model/ECG_screen.dart';

class HelpCenterScreen extends StatefulWidget {
  static String routName = "help center";

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  bool isFaqSelected = true;
  int selectedIndex = -1;
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, HomeScreen.routName);
          break;
        case 1:
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                width: double.infinity,
                color: AppColors.primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Help Center",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "How Can We Help You?",
                      style: TextStyle(
                        color: Color(0xffCAD6FF),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 35,
                  color: Colors.white,
                ),
              ),
              Positioned(
                left: 10,
                top: 65,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildTabButton("FAQ", isFaqSelected, () => setState(() => isFaqSelected = true))),
                SizedBox(width: 10),
                Expanded(child: _buildTabButton("Contact Us", !isFaqSelected, () => setState(() => isFaqSelected = false))),
              ],
            ),
          ),

          Expanded(
            child: isFaqSelected ? _buildFaqSection() : _buildContactSection(),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
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

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Color(0xffD9EAE8),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    List<String> questions = [
      "How do I reset my password?",
      "How can I change my email address?",
      "Why am I not receiving notifications?",
      "How do I delete my account?",
      "Can I recover deleted data?",
      "How to contact support?",
    ];

    List<String> answers = [
      "Go to settings, select 'Password Manager', and follow the instructions.",
      "Navigate to profile settings and update your email address.",
      "Ensure notifications are enabled in settings and check your phone's notification permissions.",
      "Go to settings and select 'Delete Account'. Follow the on-screen instructions.",
      "Unfortunately, deleted data cannot be recovered. Please ensure backups are enabled.",
      "You can contact support through the 'Contact Us' section in Help Center.",
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: List.generate(
        questions.length,
            (index) => Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = selectedIndex == index ? -1 : index;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFD9EAE8),
                  border: Border.all(color: AppColors.primaryColor, width: 2.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ListTile(
                  title: Text(
                    questions[index],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: Icon(
                    selectedIndex == index ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            if (selectedIndex == index)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  answers[index],
                  style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold,),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    List<Map<String, String>> contacts = [
      {'icon': 'assets/images/email.png', 'text': 'Email', 'details': 'support@example.com'},
      {'icon': 'assets/images/whatsapp.png', 'text': 'Whatsapp', 'details': '+1 234 567 890'},
      {'icon': 'assets/images/facebook.png', 'text': 'Facebook', 'details': 'facebook.com/yourpage'},
      {'icon': 'assets/images/insta.png', 'text': 'Instagram', 'details': 'instagram.com/yourpage'},
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: List.generate(
        contacts.length,
            (index) => Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = selectedIndex == index ? -1 : index;
                });
              },
              child: ListTile(
                leading: Image.asset(contacts[index]['icon']!, width: 30, height: 30),
                title: Text(contacts[index]['text']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                trailing: Icon(selectedIndex == index ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.primaryColor),
              ),
            ),
            if (selectedIndex == index)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(contacts[index]['details']!, style: TextStyle(color: Colors.black54, fontSize: 16)),
              ),
          ],
        ),
      ),
    );
  }
}

//import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:graduation/profile_screen/profile_screen.dart';
// import '../ui/assets.dart';
// import '../home_screen/home_screen.dart';
// import '../Ecg_model/ECG_screen.dart';
//
// class HelpCenterScreen extends StatefulWidget {
//   static String routName = "help center";
//
//   @override
//   _HelpCenterScreenState createState() => _HelpCenterScreenState();
// }
//
// class _HelpCenterScreenState extends State<HelpCenterScreen> {
//   bool isFaqSelected = true;
//   int selectedIndex = -1;
//   int _selectedIndex = 3;
//
//   void _onItemTapped(int index) {
//     if (_selectedIndex != index) {
//       setState(() {
//         _selectedIndex = index;
//       });
//
//       switch (index) {
//         case 0:
//           Navigator.pushReplacementNamed(context, HomeScreen.routName);
//           break;
//         case 1:
//           Navigator.pushReplacementNamed(context, HomeScreen.routName);
//           break;
//         case 2:
//           Navigator.pushReplacementNamed(context, ECGScreen.routName);
//           break;
//         case 3:
//           Navigator.pushReplacementNamed(context, ProfileScreen.routName);
//           break;
//       }
//     }
//   }
//
//   // 🔹 جلب الأسئلة من API
//   Future<List<Map<String, String>>> fetchFAQs() async {
//     final response = await http.get(Uri.parse("https://yourapi.com/faqs")); // ضع رابط API هنا
//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       return data.map((faq) => {"question": faq["question"], "answer": faq["answer"]}).toList();
//     } else {
//       throw Exception("Failed to load FAQs");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
//                 width: double.infinity,
//                 color: AppColors.primaryColor,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Help Center",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "How Can We Help You?",
//                       style: TextStyle(
//                         color: Color(0xffCAD6FF),
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: 35,
//                   color: Colors.white,
//                 ),
//               ),
//               Positioned(
//                 left: 10,
//                 top: 80,
//                 child: IconButton(
//                   icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ],
//           ),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(child: _buildTabButton("FAQ", isFaqSelected, () => setState(() => isFaqSelected = true))),
//                 SizedBox(width: 10),
//                 Expanded(child: _buildTabButton("Contact Us", !isFaqSelected, () => setState(() => isFaqSelected = false))),
//               ],
//             ),
//           ),
//
//           Expanded(
//             child: isFaqSelected ? _buildFaqSection() : _buildContactSection(),
//           ),
//         ],
//       ),
//
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.white,
//         currentIndex: _selectedIndex,
//         selectedItemColor: AppColors.primaryColor,
//         unselectedItemColor: Colors.grey,
//         showSelectedLabels: true,
//         showUnselectedLabels: true,
//         type: BottomNavigationBarType.fixed,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/home.png")), label: "Home"),
//           BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/reminder.png")), label: "Medicine Reminder"),
//           BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/measure.png")), label: "Measure"),
//           BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/profile.png")), label: "Profile"),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.primaryColor : Colors.transparent,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Center(
//           child: Text(
//             title,
//             style: TextStyle(
//               color: isSelected ? Colors.white : AppColors.primaryColor,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // 🔹 استخدام FutureBuilder لجلب الأسئلة من API
//   Widget _buildFaqSection() {
//     return FutureBuilder<List<Map<String, String>>>(
//       future: fetchFAQs(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator()); // عرض تحميل البيانات
//         } else if (snapshot.hasError) {
//           return Center(child: Text("Failed to load FAQs")); // في حالة حدوث خطأ
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text("No FAQs available")); // في حالة عدم وجود بيانات
//         }
//
//         List<Map<String, String>> faqs = snapshot.data!;
//
//         return ListView(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           children: List.generate(
//             faqs.length,
//             (index) => Column(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedIndex = selectedIndex == index ? -1 : index;
//                     });
//                   },
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Color(0xFFD9EAE8),
//                       border: Border.all(color: AppColors.primaryColor, width: 1.5),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: ListTile(
//                       title: Text(
//                         faqs[index]["question"]!,
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                       trailing: Icon(
//                         selectedIndex == index ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (selectedIndex == index)
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.all(10.0),
//                     margin: EdgeInsets.only(bottom: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       faqs[index]["answer"]!,
//                       style: TextStyle(color: Colors.black54, fontSize: 16),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
