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

  final localArticles = [MyArticle(title: "A", date: DateTime(2025, 12, 10, 10))];
  final remoteArticles = [MyArticle(title: "B", date: DateTime(2025, 12, 10, 12))];
  final standardDate = DateTime(2025, 12, 10);

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
    test("calls the data sources with the correct parameters", () async {
      final localArticles = [MyArticle(title: "Teste A", date: DateTime(2025, 12, 8, 10))];
      final remoteArticles = [MyArticle(title: "Teste B", date: DateTime(2025, 12, 8, 12))];
      final date = DateTime(2025, 12, 18);

      when(
        remoteDataSource.getArticles(thisDateOrAfter: anyNamed("thisDateOrAfter")),
      ).thenAnswer((_) async => Success(remoteArticles));
      when(
        localDataSource.getArticles(thisDateOrAfter: anyNamed("thisDateOrAfter")),
      ).thenAnswer((_) async => Success(localArticles));

      final result = await zappingRepository.getArticles(thisDateOrAfter: date);

      expect(result, GetArticlesSuccess(localArticles));

      verifyInOrder([
        remoteDataSource.getArticles(thisDateOrAfter: date),
        localDataSource.saveArticles(remoteArticles),
        localDataSource.getArticles(thisDateOrAfter: date),
      ]);

      verifyNoMoreInteractions(localDataSource);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test("remote success, local success saves the articles and returns Success", () async {
      final date = standardDate;

      when(
        remoteDataSource.getArticles(thisDateOrAfter: anyNamed("thisDateOrAfter")),
      ).thenAnswer((_) async => Success(remoteArticles));
      when(
        localDataSource.getArticles(thisDateOrAfter: anyNamed("thisDateOrAfter")),
      ).thenAnswer((_) async => Success(localArticles));

      final result = await zappingRepository.getArticles(thisDateOrAfter: date);

      expect(result, GetArticlesSuccess(localArticles));

      verifyInOrder([
        remoteDataSource.getArticles(thisDateOrAfter: date),
        localDataSource.saveArticles(remoteArticles),
        localDataSource.getArticles(thisDateOrAfter: date),
      ]);

      verifyNoMoreInteractions(localDataSource);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test("remote success, local failure saves the articles and returns Error", () async {
      final date = standardDate;

      when(
        remoteDataSource.getArticles(thisDateOrAfter: anyNamed("thisDateOrAfter")),
      ).thenAnswer((_) async => Success(remoteArticles));
      when(
        localDataSource.getArticles(thisDateOrAfter: anyNamed("thisDateOrAfter")),
      ).thenAnswer((_) async => Error());

      final result = await zappingRepository.getArticles(thisDateOrAfter: date);

      expect(result, GetArticlesError());

      verifyInOrder([
        remoteDataSource.getArticles(thisDateOrAfter: date),
        localDataSource.saveArticles(remoteArticles),
        localDataSource.getArticles(thisDateOrAfter: date),
      ]);

      verifyNoMoreInteractions(localDataSource);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test("remote failure, local success does not save the articles and returns Success", () async {
      final date = standardDate;

      when(
        remoteDataSource.getArticles(thisDateOrAfter: anyNamed("thisDateOrAfter")),
      ).thenAnswer((_) async => Error());
      when(
        localDataSource.getArticles(thisDateOrAfter: anyNamed("thisDateOrAfter")),
      ).thenAnswer((_) async => Success(localArticles));

      final result = await zappingRepository.getArticles(thisDateOrAfter: date);

      expect(result, GetArticlesSuccess(localArticles));

      verifyInOrder([
        remoteDataSource.getArticles(thisDateOrAfter: date),
        localDataSource.getArticles(thisDateOrAfter: date),
      ]);

      verifyNoMoreInteractions(localDataSource);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test("remote failure, local failure returns error", () async {
      final date = standardDate;

      when(
        remoteDataSource.getArticles(thisDateOrAfter: anyNamed("thisDateOrAfter")),
      ).thenAnswer((_) async => Error());
      when(
        localDataSource.getArticles(thisDateOrAfter: anyNamed("thisDateOrAfter")),
      ).thenAnswer((_) async => Error());

      final result = await zappingRepository.getArticles(thisDateOrAfter: date);

      expect(result, GetArticlesError());

      verifyInOrder([
        remoteDataSource.getArticles(thisDateOrAfter: date),
        localDataSource.getArticles(thisDateOrAfter: date),
      ]);

      verifyNoMoreInteractions(localDataSource);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test("exception returns Error", () async {
      final date = standardDate;

      when(
        remoteDataSource.getArticles(thisDateOrAfter: anyNamed("thisDateOrAfter")),
      ).thenThrow(Exception());

      final result = await zappingRepository.getArticles(thisDateOrAfter: date);

      expect(result, GetArticlesError());

      verify(remoteDataSource.getArticles(thisDateOrAfter: date)).called(1);

      verifyZeroInteractions(localDataSource);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
