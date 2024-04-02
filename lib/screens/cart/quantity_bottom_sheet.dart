import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';

class QuantityBottomSheet extends StatelessWidget {
  final ValueNotifier<int> selectedQuantity;

  const QuantityBottomSheet({super.key, required this.selectedQuantity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 6,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              // shrinkWrap: true,
              itemCount: 1000,
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: () {
                        selectedQuantity.value = index + 1;
                        Navigator.pop(context);
                      },
                      child: SubtitleText(label: "${index + 1}"),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
