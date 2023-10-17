import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.label,
    this.fontSize = 20,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.maxLines,
  });

  final String label;
  final double fontSize;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final Color? color;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
