import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:zapping_flutter/data/repository/zapping/data_source/remote/zapping_data_source_remote.dart';
import 'package:zapping_flutter/data/repository/zapping/model/get_articles_result.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/data/repository/zapping/zapping_repository_impl.dart';
import 'package:zapping_flutter/infrastructure/result.dart';

import 'zapping_repository_impl_test.mocks.dart';

@GenerateMocks([ZappingDataSourceRemote])
void main() {
  late MockZappingDataSourceRemote remoteDataSource;

  late ZappingRepositoryImpl zappingRepository;

  final articleList = ([
    MyArticle(
      title: "Al Hilal x Al-Ettifaq - 08/11 14:45 - SportTV 1",
      date: "Fri, 08 Nov 2024 14:45:00",
    ),
    MyArticle(
      title: "Al-Riyadh x Al Nassr - 08/11 17:00 - SportTV 1",
      date: "Fri, 08 Nov 2024 17:00:00",
    ),
    MyArticle(
      title: "FC Vizela x GD Chaves - 08/11 18:00 - SportTV +",
      date: "Fri, 08 Nov 2024 18:00:00",
    ),
  ]);

  setUpAll(() {
    provideDummy<Result<List<MyArticle>>>(Success([]));
  });

  setUp(() {
    remoteDataSource = MockZappingDataSourceRemote();
    zappingRepository = ZappingRepositoryImpl(remoteDataSource);
  });

  group("getArticles", () {
    test("empty remote data source response returns GetArticlesSuccess", () async {
      when(remoteDataSource.getArticles()).thenAnswer((_) async => Success([]));

      final result = await zappingRepository.getArticles();

      expect(result, GetArticlesSuccess([]));

      verify(remoteDataSource.getArticles()).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    test("non empty remote data source response returns GetArticlesSuccess", () async {
      when(remoteDataSource.getArticles()).thenAnswer((_) async => Success(articleList));

      final result = await zappingRepository.getArticles();

      expect(result, GetArticlesSuccess(articleList));

      verify(remoteDataSource.getArticles()).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    group("failure tests", () {
      test("unsuccessful remote data source response returns GetArticlesError", () async {
        when(remoteDataSource.getArticles()).thenAnswer((_) async => Error());

        final result = await zappingRepository.getArticles();

        expect(result, GetArticlesError());

        verify(remoteDataSource.getArticles()).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      });

      test("exception in the remote data source returns GetArticlesError", () async {
        when(remoteDataSource.getArticles()).thenThrow(Exception());

        final result = await zappingRepository.getArticles();

        expect(result, GetArticlesError());

        verify(remoteDataSource.getArticles()).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      });
    });
  });
}
