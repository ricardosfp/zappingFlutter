import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/infrastructure/result.dart';

abstract interface class ZappingDataSourceLocal {
  /// Gets [MyArticle] from a local data source, ordered from earliest to latest.
  Future<Result<List<MyArticle>>> getArticles();

  /// Saves [MyArticle] into a local data source.
  Future<void> saveArticles(List<MyArticle> articles);
}
