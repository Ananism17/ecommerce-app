import 'package:ecommerce_app/models/categories_model.dart';
import 'package:ecommerce_app/services/assets_manager.dart';

class AppConstants {
  static String imageUrl =
      "https://i0.wp.com/electrabd.com/wp-content/uploads/2023/05/RT65.jpg?fit=1300%2C1038&ssl=1";

  static List<String> bannersImage = [
    AssetManager.bannerOneImagePath,
    AssetManager.bannerTwoImagePath,
    AssetManager.bannerThreeImagePath,
    AssetManager.bannerFourImagePath,
  ];

  static List<CategoryModel> categoryList = [
    CategoryModel(id: "mobile", name: "Mobile", image: AssetManager.logoImagePath),
    CategoryModel(id: "mobile", name: "Mobile", image: AssetManager.logoImagePath),
    CategoryModel(id: "mobile", name: "Mobile", image: AssetManager.logoImagePath),
    CategoryModel(id: "mobile", name: "Mobile", image: AssetManager.logoImagePath),
    CategoryModel(id: "mobile", name: "Mobile", image: AssetManager.logoImagePath),
    CategoryModel(id: "mobile", name: "Mobile", image: AssetManager.logoImagePath),
  ];
}
