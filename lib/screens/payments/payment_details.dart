import 'dart:convert';

import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/services/currency_formatter.dart';
import 'package:ecommerce_app/services/date_formatter.dart';
import 'package:ecommerce_app/services/pdf_viewer.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key, required this.id});

  final int id;

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  late Future<dynamic> fetchData;
  dynamic paymentDetails = {};

  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchData = fetchPaymentDetails();
    fetchData.then((data) {
      setState(() {
        paymentDetails = data;
        dataFetched = true;
      });
    });
  }

  Future<dynamic> fetchPaymentDetails() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;
    final url = Uri.parse('${AppConstants.baseUrl}api/v1/payment/${widget.id}');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonResponse = json.decode(response.body);

    final status = jsonResponse['status'];

    if (status) {
      final data = jsonResponse['payment'];

      return data;
    } else {
      print(jsonResponse);
    }
    return null;
  }

  void showImageAsModal(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Center(
            child: Zoom(
              backgroundColor: Colors.transparent,
              child: FancyShimmerImage(
                imageUrl: imageUrl,
                boxFit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  void showPdf(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (_) => PDFViewerFromUrl(
          url: url,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    List<dynamic> orderPayments = [];
    if (dataFetched) {
      orderPayments = paymentDetails['order_payments'] as List<dynamic>;
    }

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
              title: const TitleText(label: "Payment Details"),
              elevation: 5,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const TitleText(label: "Payment Information"),
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
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: TitleText(
                                    label: "Payment No.:",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TitleText(
                                    label: paymentDetails
                                            .containsKey('payment_number')
                                        ? paymentDetails['payment_number']
                                        : '',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: TitleText(
                                    label: "Payment Status:",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: paymentDetails['payment_status'] == "0"
                                      ? const TitleText(
                                          label: "Pending",
                                          fontSize: 16,
                                        )
                                      : paymentDetails['payment_status'] == "1"
                                          ? const TitleText(
                                              label: "Verified",
                                              fontSize: 16,
                                            )
                                          : const TitleText(
                                              label: "denied",
                                              fontSize: 16,
                                            ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: TitleText(
                                    label: "Total Amount:",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(
                                    flex: 3,
                                    child: TitleText(
                                      label:
                                          "TK. ${formatCurrency(paymentDetails['amount_credit'].toDouble())}",
                                      fontSize: 16,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: TitleText(
                                    label: "Bank:",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TitleText(
                                    label: paymentDetails.containsKey('bank')
                                        ? paymentDetails['bank']
                                        : '',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: TitleText(
                                    label: "Payment Date:",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TitleText(
                                    label: paymentDetails
                                            .containsKey('payment_date')
                                        ? formattedDateWidget(
                                            formatDate:
                                                paymentDetails['payment_date'],
                                            customFormat: 'dd MMM, yyyy',
                                          )
                                        : '',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: TitleText(
                                    label: "Submitted Date:",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TitleText(
                                    label: paymentDetails
                                            .containsKey('created_at')
                                        ? formattedDateWidget(
                                            formatDate:
                                                paymentDetails['created_at'],
                                            customFormat: 'dd MMM, yyyy',
                                          )
                                        : '',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const TitleText(label: "Deposit Information"),
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
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: TitleText(
                                    label: "Bank:",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TitleText(
                                    label: paymentDetails
                                            .containsKey('transaction_details')
                                        ? json.decode(paymentDetails[
                                            'transaction_details'])['bank']
                                        : '',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: TitleText(
                                    label: "Branch:",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TitleText(
                                    label: paymentDetails
                                            .containsKey('transaction_details')
                                        ? json.decode(paymentDetails[
                                            'transaction_details'])['branch']
                                        : '',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: TitleText(
                                    label: "Account No.:",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TitleText(
                                    label: paymentDetails
                                            .containsKey('transaction_details')
                                        ? json.decode(paymentDetails[
                                                'transaction_details'])[
                                            'account_no']
                                        : '',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (userProvider.companyId != "2")
                    const TitleText(label: "Order Information"),
                  if (userProvider.companyId != "2")
                    const SizedBox(
                      height: 20,
                    ),
                  if (userProvider.companyId != "2")
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        color: themeProvider.getIsDarkTheme
                            ? const Color.fromARGB(255, 3, 51, 90)
                            : Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(0.5),
                                1: FlexColumnWidth(2.5),
                                2: FlexColumnWidth(2),
                              },
                              children: [
                                const TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TitleText(
                                          label: '#',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TitleText(
                                          label: 'Order Number',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TitleText(
                                          label: 'Amount',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ...orderPayments.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  var payment = entry.value;
                                  var orderNumber =
                                      payment['order_info']['order_number'];
                                  var orderAmount = payment['amount'];
                                  return TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TitleText(
                                            label: '${index + 1}. ',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TitleText(
                                            label: '$orderNumber',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TitleText(
                                            label:
                                                "TK. ${formatCurrency(orderAmount.toDouble())}",
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            )),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buroLogoGreen,
                            ),
                            // onPressed: () {
                            //   showImageAsModal(context,
                            //       "${AppConstants.baseUrl}storage/payment_slip/${paymentDetails['payment_slip']}");
                            // },
                            onPressed: () {
                              String imageUrl =
                                  "${AppConstants.baseUrl}storage/payment_slip/${paymentDetails['payment_slip']}";
                              if (imageUrl.toLowerCase().endsWith(".pdf")) {
                                // If the URL ends with ".pdf", handle PDF view
                                showPdf(context, imageUrl);
                              } else {
                                // Otherwise, assume it's an image and handle image view
                                showImageAsModal(context, imageUrl);
                              }
                            },
                            child: const Text("View Payment Slip"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))
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
              title: const TitleText(label: "Product Details"),
              elevation: 5,
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
