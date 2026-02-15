import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

// This class is responsible for loading product data.
// I use it to read the JSON file from assets and convert it into Product objects.
class ProductRepository {
  // This method loads all products from the local JSON file.
  Future<List<Product>> fetchAll() async {
    // Load the JSON file as a string from the assets folder.
    final raw = await rootBundle.loadString('assets/data/products.json');

    // Decode the JSON string into a list of maps.
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();

    // Convert each map into a Product object using fromJson method.
    return list.map(Product.fromJson).toList();
  }
}
