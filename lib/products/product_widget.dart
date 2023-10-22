import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/products/product_details.dart';
import 'package:ecommerce_app/services/currency_formatter.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ProductDetails(
                product: product,
              ),
            ),
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FancyShimmerImage(
                imageUrl:
                    "${AppConstants.baseUrl}storage/thumbnails/${product.photo}",
                height: size.height * 0.22,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TitleText(
                    label: product.title,
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
                Flexible(
                  flex: 1,
                  child: SubtitleText(
                    label: formatCurrency(product.price),
                    // label: product.price.toString(),
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
