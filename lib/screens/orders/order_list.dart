import 'dart:convert';

import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/screens/orders/order_card.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late Future<List<dynamic>> fetchData;
  final List<dynamic> orderList = <dynamic>[];

  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchData = fetchOrders();
    fetchData.then((data) {
      setState(() {
        orderList.addAll(data);
      });
    });
  }

  Future<List<dynamic>> fetchOrders() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;
    final url = Uri.parse('${AppConstants.baseUrl}api/v1/order-list');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonResponse = json.decode(response.body);

    final status = jsonResponse['status'];

    if (status) {
      final data = jsonResponse['orders'];
      final dataArray = data?['data'] as List<dynamic>;
      return dataArray;
    } else {
      print(jsonResponse);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {

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
        title: const TitleText(
          label: "Order List",
        ),
      ),
      body: ListView.builder(
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> order = orderList[index];
          return OrderCard(order: order);
        },
      ),
    );
  }
}
