import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/data/repository/contract/zapping_repository.dart';
import 'package:zapping_flutter/di/di.dart';
import 'package:zapping_flutter/domain/match/match_parser.dart';
import 'package:zapping_flutter/domain/model/my_match.dart';
import 'package:zapping_flutter/main.dart';

@lazySingleton
class ZappingProvider extends ChangeNotifier {
  late final _zappingRepository = getIt<ZappingRepository>();
  late final _matchParser = getIt<MatchParser>();

  Iterable<MyMatch> _matches = const [];

  List<MyMatch> get matches {
    return List.unmodifiable(_matches);
  }

  void getMatches() async {
    final articleList = await _zappingRepository.getMatches(zappingUrl);

    final matchesWithNulls = articleList.map(
      (article) {
        return _matchParser.parse(article);
      },
    );

    _matches = matchesWithNulls.nonNulls;

    notifyListeners();
  }
}
