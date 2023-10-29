import 'dart:convert';

import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/services/date_formatter.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class MakePayment extends StatefulWidget {
  const MakePayment({
    super.key,
    required this.type,
  });

  final String type;

  @override
  State<MakePayment> createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  late TextEditingController _bankNameController;
  late TextEditingController _branchNameController;

  late Future<Map<String, dynamic>> fetchData;
  dynamic bankDetailsDevice = {};
  dynamic bankDetailsCE = {};

  late Future<Map<String, dynamic>> fetchOrders;
  final List<dynamic> ordersCE = <dynamic>[];
  final List<dynamic> ordersDevice = <dynamic>[

  ];

  bool dataFetched = false;

  DateTime? _selectedDate;

  String? selectedValue; //orders

  @override
  void initState() {
    _bankNameController = TextEditingController();
    _branchNameController = TextEditingController();
    fetchData = fetchBankDetails();
    fetchData.then((data) {
      setState(() {
        bankDetailsCE = data['ce'];
        bankDetailsDevice = data['device'];
        dataFetched = true;
      });
    });

    fetchOrders = fetchOrderLists();
    fetchOrders.then((data) {
      setState(() {
        ordersCE.addAll(data['ce']);
        ordersDevice.addAll(data['device']);
      });
    });

    super.initState();
  }

  Future<Map<String, dynamic>> fetchBankDetails() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;
    final url = Uri.parse('${AppConstants.baseUrl}api/v1/bank-accounts');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonResponse = json.decode(response.body);

    final status = jsonResponse['status'];

    if (status) {
      final detailsCE = jsonResponse['accounts'][0];
      final detailsDevice = jsonResponse['accounts'][1];

      return {
        'ce': detailsCE,
        'device': detailsDevice,
      };
    } else {
      print(jsonResponse);
    }
    return {
      'ce': null,
      'device': null,
    };
  }

  Future<Map<String, dynamic>> fetchOrderLists() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;
    final url = Uri.parse('${AppConstants.baseUrl}api/v1/order-type');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonResponse = json.decode(response.body);

    final status = jsonResponse['status'];

    if (status) {
      final detailsCE = jsonResponse['orders']['ce_orders'];
      final detailsDevice = jsonResponse['orders']['device'];

      return {
        'ce': detailsCE,
        'device': detailsDevice,
      };
    } else {
      print(jsonResponse);
    }
    return {
      'ce': null,
      'device': null,
    };
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _branchNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    List deviceList;

    if (widget.type == "CE") {
      deviceList = ordersCE as List;
    } else {
      deviceList = ordersDevice as List;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Center(
                  child: TitleText(
                    label: "Payment for ${widget.type}",
                    fontSize: 24,
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
                                  label: "Account Title:",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TitleText(
                                  label: widget.type == 'CE'
                                      ? bankDetailsCE.containsKey('title')
                                          ? bankDetailsCE['title']
                                          : ''
                                      : bankDetailsDevice.containsKey('title')
                                          ? bankDetailsDevice['title']
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
                                  label: widget.type == 'CE'
                                      ? bankDetailsCE.containsKey('account_no')
                                          ? bankDetailsCE['account_no']
                                          : ''
                                      : bankDetailsDevice
                                              .containsKey('account_no')
                                          ? bankDetailsDevice['account_no']
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
                                  label: "Bank Name:",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TitleText(
                                  label: widget.type == 'CE'
                                      ? bankDetailsCE.containsKey('bank')
                                          ? bankDetailsCE['bank']
                                          : ''
                                      : bankDetailsDevice.containsKey('bank')
                                          ? bankDetailsDevice['bank']
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
                                  label: widget.type == 'CE'
                                      ? bankDetailsCE.containsKey('branch')
                                          ? bankDetailsCE['branch']
                                          : ''
                                      : bankDetailsDevice.containsKey('branch')
                                          ? bankDetailsDevice['branch']
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
                                  label: "Routing No:",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TitleText(
                                  label: widget.type == 'CE'
                                      ? bankDetailsCE.containsKey('routing_no')
                                          ? bankDetailsCE['routing_no']
                                          : ''
                                      : bankDetailsDevice
                                              .containsKey('routing_no')
                                          ? bankDetailsDevice['routing_no']
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
                const TitleText(label: "Payment Form"),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _bankNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Bank Name",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _branchNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Branch Name",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: _presentDatePicker,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: themeProvider.getIsDarkTheme
                          ? const Color.fromARGB(255, 34, 29, 50)
                          : const Color.fromARGB(255, 244, 242, 242),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    child: Row(
                      children: [
                        SubtitleText(
                          label: _selectedDate == null
                              ? "No Date Selected"
                              : formattedDateWidget(
                                  formatDate: _selectedDate.toString(),
                                  customFormat: 'dd MMM, yyyy',
                                ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
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
                  child: DropdownButton<String>(
                    value: selectedValue,
                    hint: const SubtitleText(label: "Choose Orders to pay for"),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                    items: deviceList.map<DropdownMenuItem<String>>((order) {
                      return DropdownMenuItem<String>(
                        value: order['value'],
                      
                        child: SubtitleText(
                          label: order['label'],
                        ),
                      );
                    }).toList(),
                    
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
