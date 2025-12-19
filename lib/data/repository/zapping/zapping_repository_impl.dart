import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/data/repository/zapping/data_source/local/zapping_data_source_local.dart';
import 'package:zapping_flutter/data/repository/zapping/data_source/remote/zapping_data_source_remote.dart';
import 'package:zapping_flutter/data/repository/zapping/model/get_articles_result.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/data/repository/zapping/zapping_repository.dart';
import 'package:zapping_flutter/infrastructure/result.dart';

@LazySingleton(as: ZappingRepository)
final class ZappingRepositoryImpl implements ZappingRepository {
  final ZappingDataSourceLocal _localSource;
  final ZappingDataSourceRemote _remoteSource;

  ZappingRepositoryImpl({
    required ZappingDataSourceLocal localSource,
    required ZappingDataSourceRemote remoteSource,
  }) : _localSource = localSource,
       _remoteSource = remoteSource;

  @override
  Future<GetArticlesResult> getArticles({required DateTime thisDateOrAfter}) async {
    try {
      // get the articles from the remote source
      final remoteResult = await _remoteSource.getArticles(thisDateOrAfter: thisDateOrAfter);

      switch (remoteResult) {
        case Success<List<MyArticle>>():
          // save the articles locally
          await _localSource.saveArticles(remoteResult.value);
        default:
      }

      // get the results from the local source and return them
      final localResult = await _localSource.getArticles(thisDateOrAfter: thisDateOrAfter);

      switch (localResult) {
        case Success<List<MyArticle>>():
          return GetArticlesSuccess(localResult.value);
        case Error<List<MyArticle>>():
          return GetArticlesError();
      }
    } catch (_, _) {
      return GetArticlesError();
    }
  }
}
