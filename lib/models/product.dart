// This model class represents a single product in the catalog.
// Each product has basic information like title, price, category, etc.
class Product {
  // Unique id of the product
  final int id;

  // Name/title of the product
  final String title;

  // Short description about the product
  final String description;

  // Price of the product
  final double price;

  // Path of the image stored in assets
  final String imageAsset;

  // Category of the product (for filtering)
  final String category;

  // Rating value of the product
  final double rating;

  // Constructor with required fields.
  // I made it const because product data does not change.
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageAsset,
    required this.category,
    required this.rating,
  });

  // This factory method converts JSON data into a Product object.
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
