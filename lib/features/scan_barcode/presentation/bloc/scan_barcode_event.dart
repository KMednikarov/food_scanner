part of 'scan_barcode_bloc.dart';

abstract class ScanBarcodeEvent extends Equatable {
  const ScanBarcodeEvent();

  @override
  List<Object> get props => [];
}

class GetProductItemEvent extends ScanBarcodeEvent {
  final String barcode;

  GetProductItemEvent({required this.barcode});

  @override
  List<Object> get props => [barcode];
}
