import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_item.dart';

abstract class ProductItemRepository {
  Future<Either<Failure, ProductItem>> getProductItem(String barcode);
}
