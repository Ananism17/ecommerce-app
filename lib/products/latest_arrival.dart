import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/currency_formatter.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class LatestArrival extends StatelessWidget {
  const LatestArrival({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {},
        child: SizedBox(
          width: size.width * 0.5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FancyShimmerImage(
                    imageUrl:
                        "${AppConstants.baseUrl}storage/thumbnails/${product.photo}",
                    height: size.height * 0.24,
                    width: size.width * 0.32,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add_shopping_cart),
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: SubtitleText(
                        label: "৳ ${formatCurrency(product.price)}",
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
