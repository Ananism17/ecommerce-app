import 'package:ecommerce_app/constants/app_colors.dart';
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.getIsDarkTheme
              ? AppColors.darkScaffoldColor
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: themeProvider.getIsDarkTheme
                  ? Colors.white.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                themeProvider.getIsDarkTheme ? image : imageDark,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
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
          ),
        ),
      ),
    );
  }
}
