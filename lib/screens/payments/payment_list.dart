import 'dart:convert';

import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/screens/payments/make_payment.dart';
import 'package:ecommerce_app/screens/payments/payment_card.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class PaymentList extends StatefulWidget {
  const PaymentList({
    super.key,
    required this.type,
  });

  final String type;

  @override
  State<PaymentList> createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  late Future<List<dynamic>> fetchData;
  final List<dynamic> paymentList = <dynamic>[];

  bool dataFetched = false;
  int currentPage = 1;
  int totalPage = 1;

  @override
  void initState() {
    super.initState();
    fetchData = fetchPayments(currentPage);
    fetchData.then((data) {
      setState(() {
        paymentList.addAll(data);
      });
    });
  }

  Future<void> loadMoreData() async {
    setState(() {
      currentPage++;
    });

    final newOrders = await fetchPayments(currentPage);

    setState(() {
      if (newOrders.isNotEmpty) {
        paymentList.addAll(newOrders);
      }
    });
  }

  Future<List<dynamic>> fetchPayments(int page) async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;
    final url =
        Uri.parse('${AppConstants.baseUrl}api/v1/payment-list?page=$page');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonResponse = json.decode(response.body);

    final status = jsonResponse['status'];

    if (status) {
      dynamic data;

      if (widget.type == "CE") {
        data = jsonResponse['payments']['ce_payments'];
      } else {
        data = jsonResponse['payments']['device_payments'];
      }
      setState(() {
        totalPage = data['last_page'] as int;
        dataFetched = true;
      });
      final dataArray = data?['data'] as List<dynamic>;
      return dataArray;
    } else {
      print(jsonResponse);
    }
    return [];
  }

  void _openPaymentOverlay() {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      constraints: const BoxConstraints(
        maxHeight: 750,
      ),
      context: context,
      builder: (ctx) => MakePayment(
        type: widget.type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return dataFetched
        ? paymentList.isEmpty
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
                  title: TitleText(
                    label: "${widget.type} Payment List",
                  ),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buroLogoGreen,
                      ),
                      onPressed: _openPaymentOverlay,
                      child: const Text(
                        '+ Make Payment',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: TitleText(
                        label: "List is Empty!",
                      ),
                    ),
                  ],
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
                  title: TitleText(
                    label: "${widget.type} Payment List",
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buroLogoGreen,
                          elevation: 5,
                        ),
                        onPressed: _openPaymentOverlay,
                        child: const Text(
                          '+ Make Payment',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          Map<String, dynamic> payment = paymentList[index];
                          return PaymentCard(
                            payment: payment,
                          );
                        },
                        itemCount: paymentList.length,
                      ),
                    ),
                  ],
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
              title: TitleText(
                label: "${widget.type} Payment List",
              ),
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
