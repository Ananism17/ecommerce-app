import 'package:ecommerce_app/screens/cart/bottom_checkout.dart';
import 'package:ecommerce_app/screens/cart/cart_widget.dart';
import 'package:ecommerce_app/services/assets_manager.dart';
import 'package:ecommerce_app/widgets/empty_bag.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    return isEmpty
        ? EmptyBag(
            imagePath: AssetManager.emptyCartImagePath,
            title: "Your cart is empty!",
            subtitle: "Please add some Items!",
            buttonText: "Shop Now")
        : Scaffold(
            appBar: AppBar(
              leading: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.shopping_cart,
                ),
              ),
              title: const TitleText(label: "Cart (6)"),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                bottom: kBottomNavigationBarHeight + 40.0,
              ),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const CartWidget();
                },
              ),
            ),
            bottomSheet: const CartBottomSheet(),
          );
  }
}
