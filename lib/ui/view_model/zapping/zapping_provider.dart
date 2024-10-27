import 'dart:collection';

import 'package:diacritic/diacritic.dart';
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
import 'package:zapping_flutter/ui/view_model/zapping/model/filter_result.dart';
import 'package:zapping_flutter/ui/view_model/zapping/model/ui_state.dart';

@lazySingleton
class ZappingProvider extends ChangeNotifier {
  final ZappingRepository _zappingRepository;
  final MatchParser _matchParser;
  final DateUtils _dateUtils;

  ZappingProvider({ZappingRepository? zappingRepository, MatchParser? matchParser, DateUtils? dateUtils})
      : _zappingRepository = zappingRepository ?? getIt<ZappingRepository>(),
        _matchParser = matchParser ?? getIt<MatchParser>(),
        _dateUtils = dateUtils ?? getIt<DateUtils>();

  late final LinkedHashMap<DateTime, List<MyMatch>> _dayMap = LinkedHashMap();

  UiState _uiState = UiIdle();

  UiState get uiState => _uiState;

  // todo test
  void getMatches() async {
    _uiState = UiLoading();
    notifyListeners();

    final getArticlesResult = await _zappingRepository.getArticles(zappingUrl);

    switch (getArticlesResult) {
      case GetArticlesSuccess():
        // todo this should be done in a future Use Case, not here, to avoid calling the repository,
        //  getting a response and then calling the domain layer
        // how is this part mocked in a test? it is only possible if this is put into another function
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

  // this function HAS TO return an unmodifiable map, made up from unmodifiable list values
  // there are two results possible. If the state is incorrect return error, if it is correct then do the calculations
  // todo test
  FilterResult filterList(String textToFilter) {
    final uiStateLocal = _uiState;

    // I am using a switch because I want automatic casting of UiState
    switch (uiStateLocal) {
      case UiDataReady():
        late LinkedHashMap<DateTime, List<MyMatch>> finalMap;

        if (textToFilter.isNotEmpty) {
          finalMap = LinkedHashMap();

          // traverse the original map
          uiStateLocal.dayMap.forEach((date, matchList) {
            // filter the list items that obey the selection criteria
            final finalMatchList = matchList.where((myMatch) {
              final lowerCaseQuery = removeDiacritics(textToFilter.toLowerCase());
              // either home team
              final homeTeamContainsQuery = removeDiacritics(myMatch.homeTeam.toLowerCase()).contains(lowerCaseQuery);
              // or away team
              final awayTeamContainsQuery = removeDiacritics(myMatch.awayTeam.toLowerCase()).contains(lowerCaseQuery);
              // or channel contain the query string
              final channelContainsQuery = removeDiacritics(myMatch.channel.toLowerCase()).contains(lowerCaseQuery);

              return homeTeamContainsQuery || awayTeamContainsQuery || channelContainsQuery;
            });

            // only add this list with this DateTime if the list is not empty
            if (finalMatchList.isNotEmpty) {
              finalMap[date] = finalMatchList.toList();
            }
          });

          return FilterSuccess(finalMap);
        } else {
          return FilterSuccess(uiStateLocal.dayMap);
        }
      default:
        return FilterError();
    }
  }
}
