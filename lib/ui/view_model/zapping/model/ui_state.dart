// this can be made generic
import 'dart:collection';

import 'package:zapping_flutter/domain/match/model/my_match.dart';

sealed class UiState {}

final class UiIdle implements UiState {
  static final UiIdle _instance = UiIdle._();

  const UiIdle._();

  factory UiIdle() => _instance;
}

final class UiLoading implements UiState {
  static final UiLoading _instance = UiLoading._();

  const UiLoading._();

  factory UiLoading() => _instance;
}

final class UiDataReady implements UiState {
  // unmodifiable map made up of unmodifiable lists
  final Map<DateTime, List<MyMatch>> dayMap;

  UiDataReady(LinkedHashMap<DateTime, List<MyMatch>> dayMapParameter) : dayMap = _initializeMap(dayMapParameter);

  static Map<DateTime, List<MyMatch>> _initializeMap(LinkedHashMap<DateTime, List<MyMatch>> map) {
    // make the lists unmodifiable
    for (final key in map.keys) {
      map.update(key, (value) {
        return List.unmodifiable(value);
      });
    }

    return Map.unmodifiable(map);
  }
}

final class UiError implements UiState {
  static const UiError _instance = UiError._();

  const UiError._();

  factory UiError() => _instance;
}
