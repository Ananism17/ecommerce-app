import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNameText extends StatelessWidget {
  const AppNameText({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 2),
      baseColor: AppColors.buroLogoGreen,
      highlightColor: AppColors.buroLogoOrange,
      child:  const TitleText(label: "FEL B2B"),
    );
  }
}
