import 'package:zapping_flutter/data/repository/model/my_article.dart';
import 'package:zapping_flutter/domain/model/my_match.dart';

abstract interface class MatchParser {
  MyMatch? parse(MyArticle article);
}
