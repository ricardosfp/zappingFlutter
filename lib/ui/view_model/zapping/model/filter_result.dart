import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:zapping_flutter/domain/match/model/my_match.dart';

sealed class FilterResult {}

final class FilterSuccess implements FilterResult {
  final IMap<DateTime, IList<MyMatch>> filteredMap;

  FilterSuccess(Map<DateTime, Iterable<MyMatch>> filteredMap) : filteredMap = _initializeMap(filteredMap);

  static IMap<DateTime, IList<MyMatch>> _initializeMap(Map<DateTime, Iterable<MyMatch>> map) {
    // make the lists unmodifiable
    final newMap = map.map((key, value) {
      return MapEntry(key, IList(value));
    });

    return IMap(newMap);
  }
}

final class FilterError implements FilterResult {
  static const FilterError _instance = FilterError._();

  const FilterError._();

  factory FilterError() => _instance;
}
