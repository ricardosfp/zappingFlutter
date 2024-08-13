import 'package:zapping_flutter/data/repository/model/my_article.dart';

abstract interface class ZappingRepository {
  Future<List<MyArticle>> getMatches(String url);
}
