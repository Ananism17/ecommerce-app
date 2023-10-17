import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/products/category_widget.dart';
import 'package:ecommerce_app/products/latest_arrival.dart';
import 'package:ecommerce_app/services/assets_manager.dart';
import 'package:ecommerce_app/widgets/app_name_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(AssetManager.logoImagePath),
          ),
          title: const AppNameText(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: size.height * 0.25,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Swiper(
                      autoplay: true,
                      itemCount: AppConstants.bannersImage.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          AppConstants.bannersImage[index],
                          fit: BoxFit.fill,
                        );
                      },
                      pagination: const SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.red,
                        color: Colors.white,
                      )),
                      // control: const SwiperControl(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const TitleText(label: "Latest Arrivals"),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: size.height * 0.14,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return const LatestArrival();
                    },
                    itemCount: 10,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const TitleText(label: "Categories"),
              const SizedBox(
                height: 15,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: List.generate(AppConstants.categoryList.length, (index) {
                  return CategoryWidget(
                    image: AppConstants.categoryList[index].image,
                    name: AppConstants.categoryList[index].name,
                  );
                }),
              ),
            ],
          ),
        ));
  }
}
