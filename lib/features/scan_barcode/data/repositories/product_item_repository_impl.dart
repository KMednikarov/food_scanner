import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/platform/network_info.dart';
import '../datasources/product_item_local_data_source.dart';
import '../datasources/product_item_remote_data_source.dart';
import '../../domain/entities/product_item.dart';
import '../../domain/repositories/product_item_repository.dart';

class ProductItemRepositoryImpl implements ProductItemRepository {
  ProductItemRemoteDataSource remoteDataSource;
  ProductItemLocalDataSource localDataSource;
  NetworkInfo networkInfo;

  ProductItemRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductItem>> getProductItem(String barcode) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getProduct(barcode);
        localDataSource.cacheProduct(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localResult = await localDataSource.getProduct(barcode);
        return Right(localResult);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
