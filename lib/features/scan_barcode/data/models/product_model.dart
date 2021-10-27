import 'package:food_scanner/features/scan_barcode/domain/entities/product_item.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ProductModel extends ProductItem {
  ProductModel({required String barcode, required String productName})
      : super(barcode: barcode, productName: productName);

  factory ProductModel.fromProductResult(ProductResult productResult) {
    final String? barcode = productResult.barcode;
    final String? productName = productResult.product!.productName;

    return ProductModel(barcode: barcode!, productName: productName!);
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      barcode: json['code'],
      productName: json['product_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'product_name': productName,
    };
  }
}
