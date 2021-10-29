import 'package:flutter_test/flutter_test.dart';
import 'package:food_scanner/core/platform/network_info.dart';

import 'package:mocktail/mocktail.dart';

void main() {
  NetworkInfoImpl networkInfo = NetworkInfoImpl();

  group('isConnected', () {
    test(
      ' - should check network connection',
      () async {
        // arrange
        final tHasConnectionFuture = true;
        // act
        // NOTICE: We're NOT awaiting the result
        final result = await networkInfo.isConnected;
        // Utilizing Dart's default referential equality.
        // Only references to the same object are equal.
        expect(result, equals(tHasConnectionFuture));
      },
    );
  });
}
