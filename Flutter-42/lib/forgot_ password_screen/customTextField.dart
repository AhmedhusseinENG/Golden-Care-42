import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../ui/assets.dart';

class CustomTextField extends StatefulWidget{
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPasswordField;
  CustomTextField({
    required this.controller, this.validator, this.isPasswordField = false,});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPasswordField ? !_isPasswordVisible : false,
      decoration: InputDecoration(
        suffixIcon: widget.isPasswordField
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.primaryColor,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null,
        hintStyle: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: _textFileBorder(),
        focusedBorder: _textFileBorder(),
        focusedErrorBorder: _textFileBorder(borderColor: Colors.red),
        errorBorder:  _textFileBorder(borderColor: Colors.red),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      ),
    );
  }
  InputBorder _textFileBorder({Color borderColor = AppColors.primaryColor}){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: borderColor,width: 3),
    );
  }
}