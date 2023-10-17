import 'package:ecommerce_app/screens/cart/quantity_bottom_sheet.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FittedBox(
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: FancyShimmerImage(
                  imageUrl:
                      "https://fairelectronics.com.bd/media/catalog/product/cache/319fae9b97668b3e085d70c666e80bc7/a/7/a73-awesomewhite.jpg",
                  height: size.height * 0.2,
                  width: size.width * 0.5,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              IntrinsicWidth(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.5,
                          child: const Text(
                            overflow: TextOverflow.ellipsis,
                            "Galaxy A73 5G 8/256 GB",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SubtitleText(
                          label: "TK 61,999.00",
                          color: Colors.blue,
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await showModalBottomSheet(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return const QuantityBottomSheet();
                              },
                            );
                          },
                          icon: const Icon(Icons.arrow_drop_down),
                          label: const Text("Qty: 1"),
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
