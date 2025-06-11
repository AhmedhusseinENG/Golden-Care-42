import 'package:flutter/material.dart';
class CustomText extends StatelessWidget{
  String text;
  CustomText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}