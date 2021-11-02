import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

abstract class ProductItemRemoteDataSource {
  /// Calls Open Food Facts API to get product data by barcode.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ProductModel> getProduct(String barcode);
}

class ProductItemRemoteDataSourceImpl extends ProductItemRemoteDataSource {
  final OpenFoodAPIClient client;
  static const int STATUS_SUCCESS = 1;

  ProductItemRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductModel> getProduct(String barcode) async {
    ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode,
        language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
    ProductResult result = await OpenFoodAPIClient.getProduct(configuration);
    if (result.status == STATUS_SUCCESS) {
      return ProductModel.fromProductResult(result);
    } else {
      throw ServerException();
    }
  }
}
