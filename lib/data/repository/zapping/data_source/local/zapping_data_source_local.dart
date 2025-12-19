import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/infrastructure/result.dart';

abstract interface class ZappingDataSourceLocal {
  /// Gets [MyArticle] from a local data source, ordered from earliest to latest. Only considers
  /// matches that occur on or after [thisDateOrAfter].
  Future<Result<List<MyArticle>>> getArticles({required DateTime thisDateOrAfter});

  /// Saves [MyArticle] into a local data source.
  Future<void> saveArticles(List<MyArticle> articles);
}
