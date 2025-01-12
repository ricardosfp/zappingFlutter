// this can be made generic
import 'dart:collection';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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
  final IMap<DateTime, IList<MyMatch>> dayMap;

  // LinkedHashMap to guarantee insertion-order
  UiDataReady(LinkedHashMap<DateTime, Iterable<MyMatch>> dayMap) : dayMap = _initializeMap(dayMap);

  static IMap<DateTime, IList<MyMatch>> _initializeMap(LinkedHashMap<DateTime, Iterable<MyMatch>> map) {
    // make the lists unmodifiable
    final newMap = map.map((key, value) {
      return MapEntry(key, IList(value));
    });

    return IMap(newMap);
  }
}

final class UiError implements UiState {
  static const UiError _instance = UiError._();

  const UiError._();

  factory UiError() => _instance;
}
