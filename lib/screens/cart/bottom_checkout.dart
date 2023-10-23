import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/services/currency_formatter.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

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
                Flexible(
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(
                      label: "Total (${cartProvider.items.length} Product(s)/ ${cartProvider.items.length} Item(s))",
                      fontSize: 16,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SubtitleText(
                      label: "TK. ${formatCurrency(cartProvider.totalPrice)}",
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
