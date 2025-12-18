import 'package:test/test.dart';
import 'package:zapping_flutter/infrastructure/di/di.dart';
import 'package:zapping_flutter/ui/zapping/view_model/model/ui_state.dart';
import 'package:zapping_flutter/ui/zapping/view_model/zapping_provider.dart';

void main() {
  late ZappingProvider zappingProvider;

  setUpAll(() {
    configureDependencies();
  });

  setUp(() {
    zappingProvider = ZappingProvider();
  });

  test("check initial values", skip: true, () {
    expect(zappingProvider.uiState, UiIdle());
  });
}
