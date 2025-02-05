import 'package:flutter/material.dart';

class EelvetButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  EelvetButton({required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.pink[600],
      textColor: Colors.white,
      elevation: 10,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      splashColor: Colors.white30,
      highlightColor: Colors.white38,
    );
  }
}
