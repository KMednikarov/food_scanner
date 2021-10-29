import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:food_scanner/features/scan_barcode/domain/entities/product_item.dart';
import 'package:food_scanner/features/scan_barcode/presentation/bloc/scan_barcode_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProductItemFromScan extends Mock
    implements GetProductItemFromScan {}

void main() {
  ProductItem productItem = ProductItem(
      barcode: '3800091500130', productName: 'Велинград ALCALIA - 1,5 L');
  GetProductItemFromScan getProductItemFromScan =
      GetProductItemFromScan(productItem: productItem);
  ScanBarcodeBloc scanBarcodeBloc =
      ScanBarcodeBloc(productScan: getProductItemFromScan);

  group('GetProductItemFromScan', () {
    test('', () async* {
      scanBarcodeBloc.add(getProductItemFromScan);
      expectLater(
          scanBarcodeBloc.state,
          emitsInOrder([
            Initial(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ]));
    });
  });
}
