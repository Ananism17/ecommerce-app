import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.image,
    required this.name,
  });

  final String image, name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          height: 80,
          width: 80,
        ),
        const SizedBox(
          height: 10,
        ),
        SubtitleText(
          label: name,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
