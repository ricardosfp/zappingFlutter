@Skip("not working")
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:zapping_flutter/infrastructure/di/di.dart';
import 'package:zapping_flutter/ui/zapping/view_model/zapping_provider.dart';
import 'package:zapping_flutter/ui/zapping/zapping_screen.dart';

import 'zapping_screen_test.mocks.dart';

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
