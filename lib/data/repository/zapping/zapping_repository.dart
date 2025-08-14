import 'package:zapping_flutter/data/repository/zapping/model/get_articles_result.dart';

abstract interface class ZappingRepository {
  Future<GetArticlesResult> getArticles();
}
