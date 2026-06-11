import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final Color color;

  const CalcButton({
    super.key,
    required this.text,
    this.textColor = Colors.black,
    this.backgroundColor = const Color(0xffEEF1F7),
    this.onTap, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: color, // 🔥 IMPORTANT FIX
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}