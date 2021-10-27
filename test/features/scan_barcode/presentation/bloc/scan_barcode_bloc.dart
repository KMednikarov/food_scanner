import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'scan_barcode_event.dart';
part 'scan_barcode_state.dart';

class ScanBarcodeBloc extends Bloc<ScanBarcodeEvent, ScanBarcodeState> {
  ScanBarcodeBloc() : super(ScanBarcodeInitial());
  @override
  Stream<ScanBarcodeState> mapEventToState(
    ScanBarcodeEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
