import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/data/repository/contract/zapping_repository.dart';
import 'package:zapping_flutter/data/repository/model/get_articles_result.dart';
import 'package:zapping_flutter/di/di.dart';
import 'package:zapping_flutter/domain/match/match_parse_result.dart';
import 'package:zapping_flutter/domain/match/match_parser.dart';
import 'package:zapping_flutter/domain/model/my_match.dart';
import 'package:zapping_flutter/infrastructure/date_utils.dart';
import 'package:zapping_flutter/main.dart';

@lazySingleton
class ZappingProvider extends ChangeNotifier {
  final ZappingRepository _zappingRepository;
  final MatchParser _matchParser;
  final DateUtils _dateUtils;

  ZappingProvider(
      {ZappingRepository? zappingRepository,
      MatchParser? matchParser,
      DateUtils? dateUtils})
      : _zappingRepository = zappingRepository ?? getIt<ZappingRepository>(),
        _matchParser = matchParser ?? getIt<MatchParser>(),
        _dateUtils = dateUtils ?? getIt<DateUtils>();

  late final LinkedHashMap<DateTime, List<MyMatch>> _dayMap = LinkedHashMap();

  // maybe it should be idle
  UiState _uiState = UiLoading();

  UiState get uiState => _uiState;

  void getMatches() async {
    _uiState = UiLoading();
    notifyListeners();

    final getArticlesResult = await _zappingRepository.getArticles(zappingUrl);

    switch (getArticlesResult) {
      case GetArticlesSuccess():
        // todo this should be done in a future Use Case, not here, to avoid calling the repository,
        //  getting a response and then calling the domain layer
        final matches = getArticlesResult.articles
            .map((article) {
              final matchParseResult = _matchParser.parse(article);

              if (matchParseResult is MatchParseSuccess) {
                return matchParseResult.match;
              }
              return null;
            })
            .nonNulls
            .toList();

        // order matches by date. Do not assume that they come ordered
        // if we order the list of matches then we do not need to order the map
        // it is simpler this way. Or else I could use a SplayTreeMap
        matches.sort((a, b) {
          return a.date.compareTo(b.date);
        });

        _dayMap.clear();

        // split matches into days
        for (var match in matches) {
          _dayMap.putIfAbsent(_dateUtils.dateAtMidnight(match.date), () {
            return [];
          }).add(match);
        }

        _uiState = UiDataReady(_dayMap);
        notifyListeners();

      case GetArticlesHttpError():
        _uiState = UiError();
        notifyListeners();
      case GetArticlesParseError():
        _uiState = UiError();
        notifyListeners();
      case GetArticlesOtherExceptionError():
        _uiState = UiError();
        notifyListeners();
    }
  }
}

// this can be made generic
sealed class UiState {}

final class UiDataReady implements UiState {
  // unmodifiable map made up of unmodifiable lists
  final Map<DateTime, List<MyMatch>> dayMap;

  UiDataReady(LinkedHashMap<DateTime, List<MyMatch>> dayMapParameter)
      : dayMap = _initializeMap(dayMapParameter);

  static Map<DateTime, List<MyMatch>> _initializeMap(
      LinkedHashMap<DateTime, List<MyMatch>> map) {
    // make the lists unmodifiable
    for (final key in map.keys) {
      map.update(key, (value) {
        return List.unmodifiable(value);
      });
    }

    return Map.unmodifiable(map);
  }
}

final class UiLoading implements UiState {
  static final UiLoading _instance = UiLoading._();

  UiLoading._();

  factory UiLoading() => _instance;
}

final class UiError implements UiState {
  static final UiError _instance = UiError._();

  UiError._();

  factory UiError() => _instance;
}
