import 'package:flutter/material.dart';
import '../ui/assets.dart';

class DoctorNumber extends StatefulWidget {
  static const String routName = 'doctor number';
  final String initialPhoneNumber;

  DoctorNumber({this.initialPhoneNumber = ""});

  @override
  State<DoctorNumber> createState() => _DoctorNumberState();
}

class _DoctorNumberState extends State<DoctorNumber> {
  late String phoneNumber;

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.initialPhoneNumber;
  }

  void addNumber(String number) {
    setState(() {
      phoneNumber += number;
    });
  }

  void deleteNumber() {
    if (phoneNumber.isNotEmpty) {
      setState(() {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: screenSize.height * 0.2),
          Text(
            phoneNumber,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: screenSize.height * 0.01),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  buildDialButton('1', "•"),
                  buildDialButton('2', "ABC"),
                  buildDialButton('3', "DEF"),
                  buildDialButton('4', "GHI"),
                  buildDialButton('5', "JKL"),
                  buildDialButton('6', "MNO"),
                  buildDialButton('7', "PQRS"),
                  buildDialButton('8', "TUV"),
                  buildDialButton('9', "WXYZ"),
                  buildDialButton('*', ""),
                  buildDialButton('0', "+"),
                  buildDialButton('#', ""),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: Icon(Icons.call, color: Colors.white, size: 50),
                  ),
                ),
                SizedBox(width: screenSize.width * 0.2),
                IconButton(
                  onPressed: deleteNumber,
                  icon: Icon(Icons.backspace, color: Color(0xff757575), size: 50),
                ),
              ],
            ),
          ),
          SizedBox(height: screenSize.height * 0.06),
        ],
      ),
    );
  }

  Widget buildDialButton(String number, String letters) {
    return GestureDetector(
      onTap: () => addNumber(number),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
          ),
          if (letters.isNotEmpty)
            Text(
              letters,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}