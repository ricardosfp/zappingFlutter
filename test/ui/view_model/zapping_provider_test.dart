import 'package:flutter_test/flutter_test.dart';
import 'package:zapping_flutter/di/di.dart';
import 'package:zapping_flutter/ui/view_model/zapping/model/ui_state.dart';
import 'package:zapping_flutter/ui/view_model/zapping/zapping_provider.dart';

void main() {
  late ZappingProvider zappingProvider;

  setUpAll(() {
    configureDependencies();
  });

  setUp(() {
    zappingProvider = ZappingProvider();
  });

  test("check initial values", () {
    expect(zappingProvider.uiState, isA<UiLoading>());
  });
}
