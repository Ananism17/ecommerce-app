class Product {
  Product({
    required this.slug,
    required this.title,
    required this.price,
    required this.photo,
    this.details,
    this.qty = 1,
  });

  final String slug;
  final String title;
  final double price;
  final String photo;
  final String? details;
  final int qty;
}
