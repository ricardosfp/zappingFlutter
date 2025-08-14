import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/infrastructure/result.dart';

abstract interface class ZappingDataSourceRemote {
  Future<Result<List<MyArticle>>> getArticles();
}
