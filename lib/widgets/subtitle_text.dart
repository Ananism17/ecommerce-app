import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({
    super.key,
    required this.label,
    this.fontSize = 16,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.color = const Color.fromARGB(255, 122, 120, 120),
    this.textDecoration = TextDecoration.none,
  });

  final String label;
  final double fontSize;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final Color? color;
  final TextDecoration textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
        color: color,
        fontStyle: fontStyle,
      ),
    );
  }
}
