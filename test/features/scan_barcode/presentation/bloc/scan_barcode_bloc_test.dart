import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_scanner/core/error/failures.dart';
import 'package:food_scanner/features/scan_barcode/presentation/bloc/scan_barcode_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:food_scanner/features/scan_barcode/domain/entities/product_item.dart';
import 'package:food_scanner/features/scan_barcode/domain/usecases/get_product_item.dart';

class MockGetProductItemFromScan extends Mock implements GetProductItemEvent {}

class MockGetProductItem extends Mock implements GetProductItem {}

void main() {
  final String barcode = '3800091500130';
  final ProductItem productItem =
      ProductItem(barcode: barcode, productName: 'Велинград ALCALIA - 1,5 L');

  GetProductItemEvent getProductItemEvent =
      GetProductItemEvent(barcode: barcode);

  MockGetProductItem getProductItemUseCase = MockGetProductItem();
  ScanBarcodeBloc scanBarcodeBloc =
      ScanBarcodeBloc(productItem: getProductItemUseCase);
  setUpAll(() {
    registerFallbackValue(Params(barcode: barcode));
  });
  group('GetProductItemFromScan', () {
    test(' - Should return Server Failure Message', () async {
      when(() => getProductItemUseCase(any()))
          .thenAnswer((_) async => Left(ServerFailure()));
      expectLater(
          scanBarcodeBloc.stream,
          emitsInOrder([
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ]));
      scanBarcodeBloc.add(getProductItemEvent);
    });
    test(' - Should return Cache Failure Message', () async {
      when(() => getProductItemUseCase(any()))
          .thenAnswer((_) async => Left(CacheFailure()));
      expectLater(
          scanBarcodeBloc.stream,
          emitsInOrder([
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ]));
      scanBarcodeBloc.add(getProductItemEvent);
    });
    test(' - Should return data from get product use case', () async {
      //arrange
      when(() => getProductItemUseCase(any()))
          .thenAnswer((_) async => Right(productItem));
      //act
      scanBarcodeBloc.add(getProductItemEvent);
      await untilCalled(() => getProductItemUseCase(any()));
      //assert
      verify(() => getProductItemUseCase(Params(barcode: barcode)));
    });
    test(
        ' - Should emit [Loading, Found] states when data is loaded successfully',
        () async {
      //arrange
      when(() => getProductItemUseCase(Params(barcode: barcode)))
          .thenAnswer((_) async => Right(productItem));
      //assert
      final expected = [Loading(), Found(productItem: productItem)];

      expectLater(scanBarcodeBloc.stream, emitsInOrder(expected));
      //act
      scanBarcodeBloc.add(GetProductItemEvent(barcode: barcode));
    });
  });
}
