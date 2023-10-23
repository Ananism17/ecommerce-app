import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _shippingNameController = TextEditingController();
  final _customerIdController = TextEditingController();
  final _nidController = TextEditingController();
  final _centerIdController = TextEditingController();

  @override
  void dispose() {
    _shippingNameController.dispose();
    _customerIdController.dispose();
    _nidController.dispose();
    _centerIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

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
        title: const TitleText(label: "Checkout"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const TitleText(label: "Billing Information"),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    color: themeProvider.getIsDarkTheme
                        ? const Color.fromARGB(255, 3, 51, 90)
                        : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SubtitleText(label: userProvider.userName),
                          const SizedBox(
                            height: 10,
                          ),
                          SubtitleText(label: userProvider.userEmail),
                          const SizedBox(
                            height: 10,
                          ),
                          SubtitleText(label: userProvider.userPhone),
                          const SizedBox(
                            height: 10,
                          ),
                          SubtitleText(label: userProvider.userAddress),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const TitleText(label: "Shipping Information"),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _shippingNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    label: SubtitleText(
                      label: "Customer Name",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _customerIdController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: SubtitleText(
                      label: "Customer ID",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _nidController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: SubtitleText(
                      label: "NID",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _centerIdController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: SubtitleText(
                      label: "Center ID",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
