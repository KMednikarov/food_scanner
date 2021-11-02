import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product_item.dart';
import '../../domain/usecases/get_product_item.dart';

part 'scan_barcode_event.dart';
part 'scan_barcode_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class ScanBarcodeBloc extends Bloc<ScanBarcodeEvent, ScanBarcodeState> {
  final GetProductItem getProductItem;
  ScanBarcodeBloc({
    required GetProductItem productItem,
  })  : getProductItem = productItem,
        super(Initial());

  @override
  Stream<ScanBarcodeState> mapEventToState(
    ScanBarcodeEvent event,
  ) async* {
    if (event is GetProductItemEvent) {
      yield Loading();
      final result = await getProductItem(Params(barcode: event.barcode));
      yield result.fold((fail) => Error(message: _getFailureMessage(fail)),
          (productItem) => Found(productItem: productItem));
    }
  }

  String _getFailureMessage(failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
