import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/services/assets_manager.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';

class EmptyBag extends StatelessWidget {
  const EmptyBag({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });

  final String imagePath, title, subtitle, buttonText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 128.0),
              child: Image.asset(
                AssetManager.emptyCartImagePath,
                width: double.infinity,
                height: size.height * 0.35,
              ),
            ),
            const TitleText(
              label: "Whoops!",
              fontSize: 40,
              color: Colors.red,
            ),
            const SizedBox(
              height: 20,
            ),
            SubtitleText(
              label: title,
              fontSize: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            SubtitleText(
              label: subtitle,
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buroLogoGreen,
                  elevation: 5,
                ),
                onPressed: () {},
                icon: const Icon(Icons.shopping_bag),
                label: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
