import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:food_scanner/core/error/exceptions.dart';
import 'package:food_scanner/features/scan_barcode/data/datasources/product_item_local_data_source.dart';
import 'package:food_scanner/features/scan_barcode/data/models/product_model.dart';
import 'package:food_scanner/features/scan_barcode/domain/entities/product_item.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences sharedPreferences = MockSharedPreferences();
  ProductItemLocalDataSourceImpl dataSource =
      ProductItemLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  String barcode = '3800091500130';
  ProductModel expected =
      ProductModel.fromJson(json.decode(fixture('product_item_cached.json')));

  group('getProductItem', () {
    test(
        'should return ProductItem from SharedPreferences if it exists on the cache',
        () async {
      //arrange
      when(() => sharedPreferences.getString(any()))
          .thenReturn(fixture('product_item_cached.json'));
      //act
      final result = await dataSource.getProduct(barcode);
      //assert
      verify(() => sharedPreferences.getString('CACHED_PRODUCT_ITEM'));
      expect(result, equals(expected));
    });

    test('should throw CacheException when there is no value in cache',
        () async {
      //arrange
      when(() => sharedPreferences.getString(any())).thenReturn(null);
      //act
      final call = dataSource.getProduct;
      //assert
      expect(() => call(barcode), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheProductItem', () {
    final productModel =
        ProductModel(barcode: "12345", productName: "test product");
    test('should call SharedPreferences to cache the data', () {
      when(() => sharedPreferences.setString(any(), any()))
          .thenAnswer((_) => Future<bool>.value(true));

      dataSource.cacheProduct(productModel);

      final jsonString = json.encode(productModel.toJson());
      verify(() => sharedPreferences.setString(
            CACHED_PRODUCT_ITEM,
            jsonString,
          ));
    });
  });
}
