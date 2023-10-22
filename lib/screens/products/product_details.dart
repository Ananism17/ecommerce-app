import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/currency_formatter.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final detailsList = product.details != ""
        ? product.details.split('\r\n').map((line) {
            final parts = line.split('\t');
            return {
              'type': parts[0],
              'details': parts[1],
            };
          }).toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_sharp,
          ),
        ),
        title: const TitleText(label: "Product Details"),
      ),
      body: Center(
        child: Column(
          children: [
            FancyShimmerImage(
              imageUrl:
                  "${AppConstants.baseUrl}storage/thumbnails/${product.photo}",
              height: size.height * 0.4,
              width: double.infinity,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TitleText(
                              label: product.title,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buroLogoGreen,
                            ),
                            onPressed: () {},
                            child: Text(
                              "৳ ${formatCurrency(product.price)}",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            detailsList.isNotEmpty ? detailsList.length : 1,
                        itemBuilder: (context, index) {
                          if (detailsList.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SubtitleText(
                                      label: product.details,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            final detail = detailsList[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SubtitleText(
                                      label: detail['type'] ?? "",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: SubtitleText(
                                      label: detail['details'] ?? "",
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buroLogoOrange,
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Add to Cart",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
