import 'package:zapping_flutter/data/repository/model/my_article.dart';
import 'package:zapping_flutter/domain/match/match_parse_result.dart';

abstract interface class MatchParser {
  MatchParseResult parse(MyArticle article);
}
