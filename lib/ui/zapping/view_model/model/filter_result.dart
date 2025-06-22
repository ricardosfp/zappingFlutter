import 'package:equatable/equatable.dart';
import 'package:equatable_annotations/equatable_annotations.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:zapping_flutter/domain/match/model/my_match.dart';

part 'filter_result.g.dart';

sealed class FilterResult extends Equatable {
  const FilterResult();
}

@generateProps
final class FilterSuccess extends FilterResult {
  final IMap<DateTime, IList<MyMatch>> filteredMap;

  FilterSuccess(Map<DateTime, List<MyMatch>> filteredMap)
    : filteredMap = _initializeMap(filteredMap);

  const FilterSuccess.fromImmutable(this.filteredMap);

  static IMap<DateTime, IList<MyMatch>> _initializeMap(Map<DateTime, List<MyMatch>> map) {
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
final class FilterError extends FilterResult {
  @override
  List<Object?> get props => _$props;
}
