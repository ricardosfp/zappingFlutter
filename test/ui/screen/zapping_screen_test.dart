@Skip("not working")
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:zapping_flutter/infrastructure/di/di.dart';
import 'package:zapping_flutter/ui/screen/zapping_screen.dart';
import 'package:zapping_flutter/ui/view_model/zapping/model/ui_state.dart';
import 'package:zapping_flutter/ui/view_model/zapping/zapping_provider.dart';

import 'zapping_screen_test.mocks.dart';

class _ZappingProvider extends ZappingProvider {
  @override
  UiState get uiState => UiLoading();

  @override
  void getMatches() {
    // _uiState = UiDataReady(_dayMap);
    // notifyListeners();
  }
}

@GenerateMocks([ZappingProvider])
void main() {
  setUpAll(() async {
    configureDependencies();
  });

  // repeat this for each one of the UiState
  testWidgets("Zapping Screen has an app bar", skip: true, (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ZappingScreen(
      zappingProvider: MockZappingProvider(),
    )));
  });
}
