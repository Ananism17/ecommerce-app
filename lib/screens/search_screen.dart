import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecommerce_app/products/product_widget.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.search,
            ),
          ),
          title: const TitleText(label: "Search Products"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        searchTextController.clear();
                        FocusScope.of(context).unfocus();
                      });
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                ),
                onChanged: (value) {},
                onSubmitted: (value) {},
              ),
              const SizedBox(
                height: 30,
              ),
              // Expanded(
              //   child: DynamicHeightGridView(
              //     // mainAxisSpacing: 12,
              //     // crossAxisSpacing: 12,
              //     builder: (context, index) {
              //       return const ProductWidget();
              //     },
              //     itemCount: 7,
              //     crossAxisCount: 2,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
