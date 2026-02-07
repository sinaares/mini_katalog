class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageAsset;
  final String category;
  final double rating;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageAsset,
    required this.category,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    price: (json['price'] as num).toDouble(),
    imageAsset: json['imageAsset'] as String,
    category: json['category'] as String,
    rating: (json['rating'] as num).toDouble(),
  );
}
