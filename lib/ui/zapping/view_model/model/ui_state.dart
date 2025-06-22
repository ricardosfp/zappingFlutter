// this can be made generic
import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:equatable_annotations/equatable_annotations.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:zapping_flutter/domain/match/model/my_match.dart';

part 'ui_state.g.dart';

sealed class UiState extends Equatable {
  const UiState();
}

@generateProps
final class UiIdle extends UiState {
  @override
  List<Object?> get props => _$props;
}

@generateProps
final class UiLoading extends UiState {
  @override
  List<Object?> get props => _$props;
}

@generateProps
final class UiDataReady extends UiState {
  // unmodifiable map made up of unmodifiable lists
  final IMap<DateTime, IList<MyMatch>> dayMap;

  // LinkedHashMap to guarantee insertion-order
  UiDataReady(LinkedHashMap<DateTime, List<MyMatch>> dayMap) : dayMap = _initializeMap(dayMap);

  static IMap<DateTime, IList<MyMatch>> _initializeMap(LinkedHashMap<DateTime, List<MyMatch>> map) {
    // make the lists unmodifiable
    final newMap = map.map((key, value) {
      return MapEntry(key, IList(value));
    });

    return IMap(newMap);
  }

  @override
  List<Object?> get props => _$props;
}

@generateProps
final class UiError extends UiState {
  @override
  List<Object?> get props => _$props;
}
