part of 'scan_barcode_bloc.dart';

abstract class ScanBarcodeState extends Equatable {
  const ScanBarcodeState();

  @override
  List<Object> get props => [];
}

class Initial extends ScanBarcodeState {}

class Loading extends ScanBarcodeState {}

class Found extends ScanBarcodeState {
  final ProductItem productItem;

  Found({required this.productItem});

  @override
  List<Object> get props => [productItem];
}

class Error extends ScanBarcodeState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
