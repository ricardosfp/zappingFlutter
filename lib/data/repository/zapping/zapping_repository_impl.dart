import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/data/repository/zapping/data_source/zapping_data_source_remote.dart';
import 'package:zapping_flutter/data/repository/zapping/model/get_articles_result.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/data/repository/zapping/zapping_repository.dart';
import 'package:zapping_flutter/infrastructure/result.dart';

@LazySingleton(as: ZappingRepository)
final class ZappingRepositoryImpl implements ZappingRepository {
  final ZappingDataSourceRemote _remoteSource;

  ZappingRepositoryImpl(this._remoteSource);

  @override
  Future<GetArticlesResult> getArticles() async {
    try {
      final result = await _remoteSource.getArticles();

      switch (result) {
        case Success<List<MyArticle>>():
          return GetArticlesSuccess(result.value);
        case Error<List<MyArticle>>():
          return GetArticlesError();
      }
    } catch (_, _) {
      return GetArticlesError();
    }
  }
}
