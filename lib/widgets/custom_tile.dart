import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    required this.title,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.tileIcon,
  });

  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String title;
  final IconData tileIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast ? Colors.green.shade800 : Colors.green.shade100,
        ),
        indicatorStyle: IndicatorStyle(
          width: 40,
          color: isPast ? Colors.green.shade800 : Colors.green.shade100,
          iconStyle: IconStyle(
            iconData: Icons.done,
            color: isPast ? Colors.white : Colors.transparent,
            fontSize: 20,
          ),
        ),
        endChild: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: isPast ? Colors.green.shade600 : Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    tileIcon,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
