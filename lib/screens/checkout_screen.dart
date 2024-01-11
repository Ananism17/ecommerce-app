import 'dart:convert';

import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/models/center.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/root_screen.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  //post-variables
  final _shippingNameController = TextEditingController();
  final _customerIdController = TextEditingController();
  final _nidController = TextEditingController();
  int? selectedId;

  late Future<List<CenterItem>> fetchData;
  final List<CenterItem> centerList = <CenterItem>[
    CenterItem(id: 0, name: "Select a Center"),
  ];

  String? nidErrorText;
  bool dataFetched = false;

  //init-state
  @override
  void initState() {
    super.initState();
    fetchData = fetchCenters();
    fetchData.then((data) {
      setState(() {
        centerList.addAll(data);
        selectedId = centerList[0].id;
        dataFetched = true;
      });
    });
  }

  //fetch-centers
  Future<List<CenterItem>> fetchCenters() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;

    final url = Uri.parse('${AppConstants.baseUrl}api/v1/centers');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonResponse = json.decode(response.body);

    final status = jsonResponse['status'];

    if (status) {
      final data = jsonResponse['centerDetails'];
      final dataArray = data?['data'] as List<dynamic>?;
      if (dataArray != null) {
        final List<CenterItem> centers = dataArray.map((item) {
          final int id = item['id'] as int;
          final String name = item['center_name'] as String;

          return CenterItem(
            id: id,
            name: name,
          );
        }).toList();

        return centers;
      }
      // print(productList);
    } else {
      print(jsonResponse);
    }
    return [];
  }

  //place-order
  Future<void> _placeOrder() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String userName = userProvider.userName;
    String userEmail = userProvider.userEmail;
    String userPhone = userProvider.userPhone;
    String userAddress = userProvider.userAddress;

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    List<Product> productList = cartProvider.items;

    final url = Uri.parse('${AppConstants.baseUrl}api/v1/place-order');

    List<Map<String, dynamic>> cartItems = productList.map((product) {
      return {
        'id': product.id,
        'cartQuantity': 1,
      };
    }).toList();

    final data = <String, dynamic>{
      'customer_id': _customerIdController.text,
      'customer_name': userName,
      'customer_email': userEmail,
      'customer_phone': userPhone,
      'customer_address': userAddress,
      'shipping_name': _shippingNameController.text,
      'shipping_email': userEmail,
      'shipping_phone': userPhone,
      'shipping_address': userAddress,
      'cartTotalAmount': cartProvider.totalPrice,
      'cartTotalQuantity': 1,
      'payment_type': "COD",
      "nid": _nidController.text,
      "center_id": selectedId,
      "cartItems": cartItems,
    };

    if (productList[0].type == 1) {
      data['cartType'] = "DEVICE";
    } else {
      data['cartType'] = "CE";
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    final jsonResponse = json.decode(response.body);
    final status = jsonResponse['status'];
    final message = jsonResponse['message'];

    if (status) {
      cartProvider.clearCart();
      // ignore: use_build_context_synchronously
      _showOrderSuccessAlert(context, message);
      _goHome();
    } else {
      print(jsonResponse);
      // ignore: use_build_context_synchronously
      _showOrderErrorAlert(context, message);
    }
  }

  void _showOrderSuccessAlert(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showOrderErrorAlert(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const RootScreen(),
      ),
    );
  }

  //dispose
  @override
  void dispose() {
    _shippingNameController.dispose();
    _customerIdController.dispose();
    _nidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final cartProvider = Provider.of<CartProvider>(context);
    List<Product> productList = cartProvider.items;

    return dataFetched
        ? Scaffold(
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
                                TitleText(
                                  label: userProvider.userName,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TitleText(
                                  label: userProvider.userEmail,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TitleText(
                                  label: userProvider.userPhone,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TitleText(
                                  label: userProvider.userAddress,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        thickness: 1,
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
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Customer Name",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _customerIdController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Customer ID",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _nidController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "NID",
                          errorText: nidErrorText,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(17),
                        ],
                        onChanged: (text) {
                          if (text.isEmpty ||
                              !(text.length == 10 ||
                                  text.length == 13 ||
                                  text.length == 17)) {
                            setState(() {
                              nidErrorText =
                                  "NID must be 10, 13, or 17 digits long.";
                            });
                          } else {
                            setState(() {
                              nidErrorText = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: themeProvider.getIsDarkTheme
                              ? const Color.fromARGB(255, 34, 29, 50)
                              : const Color.fromARGB(255, 244, 242, 242),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: DropdownButton<int>(
                          value: selectedId,
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedId = newValue;
                            });
                          },
                          items:
                              centerList.map<DropdownMenuItem<int>>((center) {
                            return DropdownMenuItem<int>(
                              value: center.id,
                              child: SubtitleText(
                                label: center.name,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const TitleText(label: "Cart Information"),
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
                                ...productList.asMap().entries.map(
                                  (entry) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: TitleText(
                                                label:
                                                    '${index + 1}. ${item.title}',
                                                fontSize: 16,
                                                maxLines: 2,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "${item.price}",
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16.0),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                      ],
                                    );
                                  },
                                ).toList(),
                                const SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 3,
                                      child: TitleText(
                                        label: 'Cart Total: ',
                                        fontSize: 16,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${cartProvider.totalPrice}',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buroLogoGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                          ),
                          onPressed: _placeOrder,
                          child: const Text("Place Order"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
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
            body: Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: themeProvider.getIsDarkTheme
                    ? Colors.white
                    : Colors.lightBlue,
                size: 60,
                secondRingColor: AppColors.buroLogoGreen,
                thirdRingColor: AppColors.buroLogoOrange,
              ),
            ),
          );
  }
}
