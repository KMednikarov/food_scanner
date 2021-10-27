import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:food_scanner/features/scan_barcode/data/datasources/product_item_remote_data_source.dart';
import 'package:food_scanner/features/scan_barcode/data/models/product_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:openfoodfacts/openfoodfacts.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockOpenFoodFactApi extends Mock implements OpenFoodAPIClient {}

void main() {
  MockOpenFoodFactApi client = MockOpenFoodFactApi();
  ProductItemRemoteDataSourceImpl remoteDataSource =
      ProductItemRemoteDataSourceImpl(client: client);
  final barcode = '3800091500130';
  ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode,
      language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);

  test('Should perform a GET request on a URL', () async {
    //arrange
    final ProductResult productResult =
        await OpenFoodAPIClient.getProduct(configuration);
    final expected = ProductModel.fromProductResult(productResult);
    //act
    final result = await remoteDataSource.getProduct(barcode);

    //assert
    expect(result, equals(expected));
  });
}
