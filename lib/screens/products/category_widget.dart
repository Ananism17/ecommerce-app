import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.image,
    required this.imageDark,
    required this.name,
  });

  final String image, imageDark, name;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Image.asset(
          themeProvider.getIsDarkTheme ? imageDark : image,
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
