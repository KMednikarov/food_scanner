import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_item.dart';
import '../repositories/product_item_repository.dart';

class GetProductItem implements UseCase<ProductItem, Params> {
  final ProductItemRepository repository;

  GetProductItem({required this.repository});

  @override
  Future<Either<Failure, ProductItem>> call(Params params) async {
    return await repository.getProductItem(params.barcode);
  }
}

class Params extends Equatable {
  final String barcode;

  Params({required this.barcode});

  @override
  List<Object?> get props => [
        barcode,
      ];
}
