import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/screens/cart/bottom_checkout.dart';
import 'package:ecommerce_app/screens/cart/cart_widget.dart';
import 'package:ecommerce_app/services/assets_manager.dart';
import 'package:ecommerce_app/widgets/empty_bag.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isEmpty = true;

  void showRemoveAllAlert(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
        content: Text(
          "Removed all Products from Cart!",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    List<Product> productList = cartProvider.items;

    isEmpty = productList.isEmpty;

    return WillPopScope(
      onWillPop: () async {
        // Show an alert dialog when the back button is pressed
        bool exit = await _showExitConfirmationDialog(context) ?? false;
        return exit;
      },
      child: isEmpty
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
                title: TitleText(label: "Cart (${productList.length})"),
                actions: [
                  IconButton(
                    onPressed: () {
                      cartProvider.clearCart();
                      showRemoveAllAlert(context);
                    },
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
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    return CartWidget(
                      product: productList[index],
                    );
                  },
                ),
              ),
              bottomSheet: const CartBottomSheet(),
            ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('No'),
            onPressed: () {
              // Navigator.pop returns false to WillPopScope
              Navigator.pop(context, false);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes'),
            onPressed: () {
              // Navigator.pop returns true to WillPopScope
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
