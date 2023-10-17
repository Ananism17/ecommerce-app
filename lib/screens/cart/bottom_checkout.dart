import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               const Flexible(
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(
                      label: "Total (1 Product(s)/ 10 Item(s))",
                      fontSize: 16,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SubtitleText(
                      label: "Tk. 6,19,900",
                      color: Colors.blue,
                    ),
                  ],
                             ),
               ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buroLogoGreen,
                  elevation: 5,
                ),
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text("Checkout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
