import 'package:ecommerce_app/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class OrderTracker extends StatefulWidget {
  const OrderTracker({super.key, required this.orderStatus});

  final dynamic orderStatus;

  @override
  State<OrderTracker> createState() => _OrderTrackerState();
}

class _OrderTrackerState extends State<OrderTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  CustomTile(
                    title: "Accepted",
                    isFirst: true,
                    isLast: false,
                    isPast: widget.orderStatus.containsKey('accepted') ||
                        widget.orderStatus.containsKey('confirmed'),
                    tileIcon: Icons.check_outlined,
                  ),
                  CustomTile(
                    title: "Approved",
                    isFirst: false,
                    isLast: false,
                    isPast: widget.orderStatus.containsKey('approved'),
                    tileIcon: Icons.thumb_up,
                  ),
                  CustomTile(
                    title: "In-Transit",
                    isFirst: false,
                    isLast: false,
                    isPast: widget.orderStatus.containsKey('in_transit'),
                    tileIcon: Icons.local_shipping,
                  ),
                  CustomTile(
                    title: "Delivered",
                    isFirst: false,
                    isLast: true,
                    isPast: widget.orderStatus.containsKey('delivered') ||
                        widget.orderStatus.containsKey('received'),
                    tileIcon: Icons.archive,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
