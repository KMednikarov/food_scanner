import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_scanner/core/error/exceptions.dart';
import 'package:food_scanner/core/error/failures.dart';
import 'package:food_scanner/features/scan_barcode/data/models/product_model.dart';
import 'package:food_scanner/features/scan_barcode/domain/entities/product_item.dart';
import 'package:mocktail/mocktail.dart';

import 'package:food_scanner/core/platform/network_info.dart';
import 'package:food_scanner/features/scan_barcode/data/datasources/product_item_local_data_source.dart';
import 'package:food_scanner/features/scan_barcode/data/datasources/product_item_remote_data_source.dart';
import 'package:food_scanner/features/scan_barcode/data/repositories/product_item_repository_impl.dart';

class MockRemoteDataSource extends Mock implements ProductItemRemoteDataSource {
}

class MockLocalDataSource extends Mock implements ProductItemLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteDataSource mockRemoteDataSource = MockRemoteDataSource();
  MockLocalDataSource mockLocalDataSource = MockLocalDataSource();
  MockNetworkInfo mockNetworkInfo = MockNetworkInfo();

  ProductItemRepositoryImpl repository = ProductItemRepositoryImpl(
    remoteDataSource: mockRemoteDataSource,
    localDataSource: mockLocalDataSource,
    networkInfo: mockNetworkInfo,
  );

  group('getProductItem', () {
    final String barcode = '123';
    final String productName = 'Product Name';
    final ProductModel product =
        ProductModel(barcode: barcode, productName: productName);

    test(' - Check if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.cacheProduct(product))
          .thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getProduct(any()))
          .thenAnswer((_) async => product);

      //act
      await repository.getProductItem(barcode);

      //assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group(' - Device is online', () {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      test(
          ' - Should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getProduct(any()))
            .thenAnswer((_) async => product);
        when(() => mockLocalDataSource.cacheProduct(product))
            .thenAnswer((_) async => true);
        //act
        final result = await repository.getProductItem(barcode);
        //assert
        verify(() => mockRemoteDataSource.getProduct(any()));
        expect(result, equals(Right(product)));
      });
      test(
          ' - Should cache data when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getProduct(any()))
            .thenAnswer((_) async => product);
        //act
        await repository.getProductItem(barcode);
        //assert
        verify(() => mockRemoteDataSource.getProduct(barcode));
        verify(() => mockLocalDataSource.cacheProduct(product));
      });

      test(
          ' - Should return [ServerFailure] when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getProduct(any()))
            .thenThrow(ServerException());
        //act
        final result = await repository.getProductItem(barcode);
        //assert
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group(' - Device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(' - Should return locally cached data when present', () async {
        //arrange
        when(() => mockLocalDataSource.getProduct(any()))
            .thenAnswer((_) async => product);

        //act
        final result = await repository.getProductItem(barcode);
        //assert
        verify(() => mockLocalDataSource.getProduct(barcode));
        expect(result, equals(Right(product)));
      });
      test(
          ' - Should return [CacheFailure] when there is no cache data present',
          () async {
        //arrange
        when(() => mockLocalDataSource.getProduct(any()))
            .thenThrow(CacheException());

        //act
        final result = await repository.getProductItem(barcode);
        //assert
        verify(() => mockLocalDataSource.getProduct(barcode));
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
