import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> fetchAll() async {
    final raw = await rootBundle.loadString('assets/data/products.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(Product.fromJson).toList();
  }
}
