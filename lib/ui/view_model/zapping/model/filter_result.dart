import 'package:zapping_flutter/domain/match/model/my_match.dart';

sealed class FilterResult {}

final class FilterSuccess implements FilterResult {
  final Map<DateTime, List<MyMatch>> filteredMap;

  FilterSuccess(Map<DateTime, List<MyMatch>> mapParameter) : filteredMap = _initializeMap(mapParameter);

  static Map<DateTime, List<MyMatch>> _initializeMap(Map<DateTime, List<MyMatch>> map) {
    // make the lists unmodifiable
    for (final key in map.keys) {
      map.update(key, (value) {
        return List.unmodifiable(value);
      });
    }

    return Map.unmodifiable(map);
  }
}

final class FilterError implements FilterResult {
  static final FilterError _instance = FilterError._();

  FilterError._();

  factory FilterError() => _instance;
}
