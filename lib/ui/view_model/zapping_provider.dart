import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/data/repository/contract/zapping_repository.dart';
import 'package:zapping_flutter/di/di.dart';
import 'package:zapping_flutter/domain/match/match_parser.dart';
import 'package:zapping_flutter/domain/model/my_match.dart';
import 'package:zapping_flutter/infrastructure/date_utils.dart';
import 'package:zapping_flutter/main.dart';

@lazySingleton
class ZappingProvider extends ChangeNotifier {
  late final _zappingRepository = getIt<ZappingRepository>();
  late final _matchParser = getIt<MatchParser>();
  late final _dateUtils = getIt<DateUtils>();

  late Iterable<MyMatch> _matches = const [];

  List<MyMatch> get matches {
    return List.unmodifiable(_matches);
  }

  late final Map<DateTime, List<MyMatch>> _dayMap = {};

  Map<DateTime, List<MyMatch>> get matchMap {
    return _dayMap;
  }

  void getMatches() async {
    final articleList = await _zappingRepository.getMatches(zappingUrl);

    final matchesWithNulls = articleList.map(
      (article) {
        return _matchParser.parse(article);
      },
    );

    _matches = matchesWithNulls.nonNulls;

    // todo order matches by date. Do not assume that they come ordered

    _dayMap.clear();
    // split matches into days
    for (var match in _matches) {
      _dayMap.putIfAbsent(_dateUtils.dateAtMidnight(match.date), () {
        return [];
      }).add(match);
    }

    notifyListeners();
  }
}
