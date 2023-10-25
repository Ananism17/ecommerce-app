class Product {
  Product({
    required this.id,
    required this.slug,
    required this.title,
    required this.price,
    required this.photo,
    required this.stock,
    this.details,
    this.qty = 1,
  });

  final int id;
  final String slug;
  final String title;
  final double price;
  final String photo;
  final int stock;
  final String? details;
  final int qty;
}
