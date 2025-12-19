import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/infrastructure/result.dart';

abstract interface class ZappingDataSourceRemote {
  /// Gets [MyArticle] from a remote data source, ordered from earliest to latest. Only considers
  /// matches that occur on or after [thisDateOrAfter].
  Future<Result<List<MyArticle>>> getArticles({required DateTime thisDateOrAfter});
}
