import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType inputType;
  final int? maxlenth;
  final bool? readOnly;


  CustomTextField({
    this.label,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.controller,
    this.inputType = TextInputType.text,
    this.maxlenth,
    this.readOnly,  bool? enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? "",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          maxLength: maxlenth,
          controller: controller,
          obscureText: isPassword,
          keyboardType: inputType,
          readOnly: readOnly ?? false,
          decoration: InputDecoration(
            counterText: "",
            prefixIcon: Icon(icon, color: Colors.orange),
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
