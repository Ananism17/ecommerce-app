import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({super.key});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          print("Go to object details page!");
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FancyShimmerImage(
                imageUrl: AppConstants.imageUrl,
                height: size.height * 0.22,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TitleText(
                    label: "Samsung Refrigerator RT65K7058BS/D2 | 670Ltr.",
                    fontSize: 16,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  flex: 1,
                  child: SubtitleText(
                    label: "TK 1,31,506",
                    color: Colors.blue,
                  ),
                ),
                Flexible(
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.buroLogoOrange,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(12),
                      splashColor: AppColors.buroLogoGreen,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.add_shopping_cart),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
