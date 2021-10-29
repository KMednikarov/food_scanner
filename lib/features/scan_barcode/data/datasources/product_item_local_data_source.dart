import 'package:food_scanner/core/error/exceptions.dart';

import '../models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class ProductItemLocalDataSource {
  /// Get product data by barcode from local data source.
  ///
  /// Throws a [NoLocalDataException] for all error codes.
  Future<ProductModel> getProduct(String barcode);

  /// Cache a product to local data.
  ///
  /// Throws a [CacheException] for all error codes.
  Future<void> cacheProduct(ProductModel product);
}

const CACHED_PRODUCT_ITEM = 'CACHED_PRODUCT_ITEM';

class ProductItemLocalDataSourceImpl extends ProductItemLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductItemLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheProduct(ProductModel product) {
    return sharedPreferences.setString(
      CACHED_PRODUCT_ITEM,
      json.encode(product.toJson()),
    );
  }

  @override
  Future<ProductModel> getProduct(String barcode) {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCT_ITEM);

    if (jsonString != null) {
      return Future.value(ProductModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
