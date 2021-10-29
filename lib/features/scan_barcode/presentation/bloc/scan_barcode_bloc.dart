import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_scanner/features/scan_barcode/domain/entities/product_item.dart';

part 'scan_barcode_event.dart';
part 'scan_barcode_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class ScanBarcodeBloc extends Bloc<ScanBarcodeEvent, ScanBarcodeState> {
  final GetProductItemFromScan getProductItemFromScan;
  ScanBarcodeBloc({
    required GetProductItemFromScan productScan,
  })  : getProductItemFromScan = productScan,
        super(Initial());

  @override
  Stream<ScanBarcodeState> mapEventToState(
    ScanBarcodeEvent event,
  ) async* {
    if (event is GetProductItemFromScan) {
      yield Error(message: SERVER_FAILURE_MESSAGE);
    }
  }
}
