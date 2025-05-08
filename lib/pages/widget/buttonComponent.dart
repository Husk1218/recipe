import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {
  final Color btnColor;
  final String text;
  final double btnWidth;
  final double borderRadius;
  final Color textColor;
  const ButtonComponent(
      {super.key,
      required this.btnColor,
      required this.text,
      required this.btnWidth,
      required this.borderRadius,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: btnWidth,
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: btnColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
