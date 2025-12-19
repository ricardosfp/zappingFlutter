import 'package:zapping_flutter/data/repository/zapping/model/get_articles_result.dart';

abstract interface class ZappingRepository {
  /// Gets [MyArticle] ordered from earliest to latest. Only considers matches that occur on or
  /// after [thisDateOrAfter].
  Future<GetArticlesResult> getArticles({required DateTime thisDateOrAfter});
}
