import 'dart:convert';
import 'package:flutter/services.dart';
import '../../core/errors/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final String jsonAssetPath;

  const ProductLocalDataSourceImpl({
    this.jsonAssetPath = 'assets/data/products.json',
  });

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      // Simulate brief network/disk load latency
      await Future.delayed(const Duration(milliseconds: 350));
      final String jsonString = await rootBundle.loadString(jsonAssetPath);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      return jsonList
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Failed to load products from local JSON asset: $e');
    }
  }
}
