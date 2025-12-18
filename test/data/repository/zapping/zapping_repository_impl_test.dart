import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:zapping_flutter/data/repository/zapping/data_source/local/zapping_data_source_local.dart';
import 'package:zapping_flutter/data/repository/zapping/data_source/remote/zapping_data_source_remote.dart';
import 'package:zapping_flutter/data/repository/zapping/model/get_articles_result.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/data/repository/zapping/zapping_repository_impl.dart';
import 'package:zapping_flutter/infrastructure/result.dart';

import 'zapping_repository_impl_test.mocks.dart';

// todo find a way to run these tests on the local database and also on the mocked local data source

@GenerateMocks([ZappingDataSourceLocal, ZappingDataSourceRemote])
void main() {
  late MockZappingDataSourceLocal localDataSource;
  late MockZappingDataSourceRemote remoteDataSource;

  late ZappingRepositoryImpl zappingRepository;

  setUpAll(() {
    provideDummy<Result<List<MyArticle>>>(Success([]));
  });

  setUp(() {
    localDataSource = MockZappingDataSourceLocal();
    remoteDataSource = MockZappingDataSourceRemote();
    zappingRepository = ZappingRepositoryImpl(
      localSource: localDataSource,
      remoteSource: remoteDataSource,
    );
  });

  group("getArticles", () {
    test("remote success, local success saves the articles and returns Success", () async {
      final articles = [MyArticle(title: "A", date: DateTime(2025, 12, 10, 10))];

      when(remoteDataSource.getArticles()).thenAnswer((_) async => Success(articles));
      when(localDataSource.getArticles()).thenAnswer((_) async => Success(articles));

      final result = await zappingRepository.getArticles();

      expect(result, GetArticlesSuccess(articles));

      verifyInOrder([
        remoteDataSource.getArticles(),
        localDataSource.saveArticles(articles),
        localDataSource.getArticles(),
      ]);

      verifyNoMoreInteractions(localDataSource);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test("remote success, local failure saves the articles and returns Error", () async {
      final articles = [MyArticle(title: "A", date: DateTime(2025, 12, 10, 10))];

      when(remoteDataSource.getArticles()).thenAnswer((_) async => Success(articles));
      when(localDataSource.getArticles()).thenAnswer((_) async => Error());

      final result = await zappingRepository.getArticles();

      expect(result, GetArticlesError());

      verifyInOrder([
        remoteDataSource.getArticles(),
        localDataSource.saveArticles(articles),
        localDataSource.getArticles(),
      ]);

      verifyNoMoreInteractions(localDataSource);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test("remote failure, local success does not save the articles and returns Success", () async {
      final articles = [MyArticle(title: "A", date: DateTime(2025, 12, 10, 10))];

      when(remoteDataSource.getArticles()).thenAnswer((_) async => Error());
      when(localDataSource.getArticles()).thenAnswer((_) async => Success(articles));

      final result = await zappingRepository.getArticles();

      expect(result, GetArticlesSuccess(articles));

      verifyInOrder([remoteDataSource.getArticles(), localDataSource.getArticles()]);

      verifyNoMoreInteractions(localDataSource);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test("remote failure, local failure returns error", () async {
      when(remoteDataSource.getArticles()).thenAnswer((_) async => Error());
      when(localDataSource.getArticles()).thenAnswer((_) async => Error());

      final result = await zappingRepository.getArticles();

      expect(result, GetArticlesError());

      verifyInOrder([remoteDataSource.getArticles(), localDataSource.getArticles()]);

      verifyNoMoreInteractions(localDataSource);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test("exception returns Error", () async {
      when(remoteDataSource.getArticles()).thenThrow(Exception());
      when(localDataSource.getArticles()).thenAnswer((_) async => Success([]));

      final result = await zappingRepository.getArticles();

      expect(result, GetArticlesError());

      verify(remoteDataSource.getArticles()).called(1);

      verifyZeroInteractions(localDataSource);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
