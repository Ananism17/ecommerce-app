import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/screens/payments/payment_details.dart';
import 'package:ecommerce_app/services/currency_formatter.dart';
import 'package:ecommerce_app/services/date_formatter.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key, required this.payment});

  final Map<String, dynamic> payment;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Card(
      color: themeProvider.getIsDarkTheme
          ? const Color.fromARGB(255, 3, 51, 90)
          : Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Number:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SubtitleText(
                            label: payment['payment_number'].toString(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Status:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          payment['payment_status'] == "0"
                              ? const SubtitleText(
                                  label: "Pending",
                                )
                              : payment['payment_status'] == "1"
                                  ? const SubtitleText(
                                      label: "Verified",
                                    )
                                  : const SubtitleText(
                                      label: "denied",
                                    ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Amount:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SubtitleText(
                            label:
                                "TK. ${formatCurrency(payment['amount_credit'].toDouble())}",
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Date:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SubtitleText(
                            label: formattedDateWidget(
                              formatDate: payment['payment_date'],
                              customFormat: "dd MMM, yyyy",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buroLogoGreen,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => PaymentDetails(
                      id: payment["id"],
                    ),
                  ),
                );
              },
              child: const Text(
                'View Details',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
