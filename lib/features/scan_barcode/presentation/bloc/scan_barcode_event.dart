part of 'scan_barcode_bloc.dart';

abstract class ScanBarcodeEvent extends Equatable {
  const ScanBarcodeEvent();

  @override
  List<Object> get props => [];
}

class GetProductItemFromScan extends ScanBarcodeEvent {
  final ProductItem productItem;

  GetProductItemFromScan({required this.productItem});

  @override
  List<Object> get props => [productItem];
}
