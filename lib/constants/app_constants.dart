import 'package:ecommerce_app/models/categories_model.dart';
import 'package:ecommerce_app/services/assets_manager.dart';

class AppConstants {
  static String imageUrl =
      "https://i0.wp.com/electrabd.com/wp-content/uploads/2023/05/RT65.jpg?fit=1300%2C1038&ssl=1";

  static List<String> bannersImage = [
    AssetManager.bannerOneImagePath,
    AssetManager.bannerTwoImagePath,
    // AssetManager.bannerThreeImagePath,
    AssetManager.bannerFourImagePath,
  ];

  static List<CategoryModel> categoryList = [
    CategoryModel(
      id: "mobile",
      name: "Mobile",
      image: AssetManager.mobileLogoImagePath,
      imageDark: AssetManager.mobileLogoLightImagePath,
    ),
    CategoryModel(
      id: "tv",
      name: "TV",
      image: AssetManager.tvLogoImagePath,
      imageDark: AssetManager.tvLogoLightImagePath,
    ),
    CategoryModel(
      id: "refrigerator",
      name: "Refrigerator",
      image: AssetManager.fridgeLogoImagePath,
      imageDark: AssetManager.fridgeLogoLightImagePath,
    ),
    CategoryModel(
      id: "washing-machine",
      name: "Washing Machine",
      image: AssetManager.wmLogoImagePath,
      imageDark: AssetManager.wmLogoLightImagePath,
    ),
    CategoryModel(
      id: "ac",
      name: "AC",
      image: AssetManager.acLogoImagePath,
      imageDark: AssetManager.acLogoLightImagePath,
    ),
    CategoryModel(
      id: "microwave",
      name: "Microwave",
      image: AssetManager.ovenLogoImagePath,
      imageDark: AssetManager.ovenLogoLightImagePath,
    ),
  ];

  //api-url

  //test-api
  // static String baseUrl = 'http://13.213.31.196/';

  // live-api
  // static String baseUrl = 'http://18.136.120.3/';
  static String baseUrl = 'http://13.250.105.120/';
}
