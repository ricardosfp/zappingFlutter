import 'package:flutter/widgets.dart';
import 'package:zapping_flutter/data/repository/implementation/zapping_repository_impl.dart';
import 'package:zapping_flutter/domain/match/match_parser_impl.dart';
import 'package:zapping_flutter/domain/model/my_match.dart';
import 'package:zapping_flutter/main.dart';

class ZappingProvider extends ChangeNotifier {
  // todo this should be injected
  late final _zappingRepository = ZappingRepositoryImpl();
  late final _matchParser = MatchParserImpl();

  Iterable<MyMatch> _matches = const [];

  List<MyMatch> get matches {
    return List<MyMatch>.unmodifiable(_matches);
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
