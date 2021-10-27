import 'package:equatable/equatable.dart';

class ProductItem extends Equatable {
  final String barcode;
  final String productName;

  ProductItem({
    required this.barcode,
    required this.productName,
  });

  @override
  List<Object?> get props => [barcode];
}
