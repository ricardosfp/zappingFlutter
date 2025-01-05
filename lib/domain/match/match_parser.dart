import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/domain/match/model/match_parse_result.dart';

abstract interface class MatchParser {
  MatchParseResult parse(MyArticle article);
}
