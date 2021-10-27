import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_scanner/features/scan_barcode/domain/entities/product_item.dart';
import 'package:food_scanner/features/scan_barcode/domain/repositories/product_item_repository.dart';
import 'package:food_scanner/features/scan_barcode/domain/usecases/get_product_item.dart';

import 'package:mocktail/mocktail.dart';

class MockProductItemRepository extends Mock implements ProductItemRepository {}

void main() {
  GetProductItem usecase;
  ProductItemRepository repository;
  repository = MockProductItemRepository();
  usecase = GetProductItem(repository);

  final String tBarcode = '123';
  final String productName = 'Product Name';
  final tProductItem = ProductItem(barcode: tBarcode, productName: productName);
  test('should get product item from the repository', () async {
    //arrange
    when(() => repository.getProductItem(any()))
        .thenAnswer((_) async => Right(tProductItem));
    //act
    final result = await usecase(Params(
        barcode: tBarcode,
        product: ProductItem(
          barcode: tBarcode,
          productName: productName,
        )));
    //assert
    expect(result, Right(tProductItem));
    verify(() => repository.getProductItem(any()));
    verifyNoMoreInteractions(repository);
  });
}
