import 'package:zapping_flutter/data/repository/model/get_articles_result.dart';

abstract interface class ZappingRepository {
  Future<GetArticlesResult> getArticles(String url);
}
