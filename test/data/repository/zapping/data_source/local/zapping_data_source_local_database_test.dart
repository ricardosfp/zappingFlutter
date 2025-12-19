import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:zapping_flutter/data/repository/zapping/data_source/local/zapping_data_source_local_database.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/data/services/database/drift_database.dart';
import 'package:zapping_flutter/infrastructure/result.dart';

void main() {
  late AppDatabase database;

  late ZappingDataSourceLocalDatabase dataSource;

  setUp(() {
    database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        // Recommended for widget tests to avoid test errors.
        closeStreamsSynchronously: true,
      ),
    );

    dataSource = ZappingDataSourceLocalDatabase(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  group("getArticles", () {
    test("empty database returns an empty list", () async {
      final result = await dataSource.getArticles(thisDateOrAfter: DateTime(2025, 12, 10));

      expect(result, Success<List<MyArticle>>([]));
    });

    test("non empty database returns a non empty list", () async {
      final parameters = [
        (title: "A", date: DateTime(2025, 12, 17, 10)),
        (title: "B", date: DateTime(2025, 12, 17, 12)),
      ];

      // add articles to the database
      await database.managers.articleTable.bulkCreate(
        (o) => parameters.map((e) => o(title: e.title, date: e.date)),
      );

      final result = await dataSource.getArticles(thisDateOrAfter: DateTime(2025, 12, 10));

      expect(
        result,
        Success(parameters.map((e) => MyArticle(title: e.title, date: e.date)).toList()),
      );
    });

    test("only returns articles on or after the passed date", () async {
      final articlesToSave = [
        MyArticle(title: "A", date: DateTime(2025, 12, 17, 10)),
        MyArticle(title: "B", date: DateTime(2025, 12, 17, 12)),
        MyArticle(title: "C", date: DateTime(2025, 12, 17, 14)),
        MyArticle(title: "D", date: DateTime(2025, 12, 17, 16)),
      ];

      // add articles to the database
      await database.managers.articleTable.bulkCreate(
        (o) => articlesToSave.map((e) => o(title: e.title, date: e.date)),
      );

      final result = await dataSource.getArticles(thisDateOrAfter: DateTime(2025, 12, 17, 12));

      expect(
        result,
        Success([
          MyArticle(title: "B", date: DateTime(2025, 12, 17, 12)),
          MyArticle(title: "C", date: DateTime(2025, 12, 17, 14)),
          MyArticle(title: "D", date: DateTime(2025, 12, 17, 16)),
        ]),
      );
    });

    test("unordered database returns an ordered (by date) list", () async {
      final articlesToSave = [
        MyArticle(title: "D", date: DateTime(2025, 12, 17, 16)),
        MyArticle(title: "A", date: DateTime(2025, 12, 17, 10)),
        MyArticle(title: "C", date: DateTime(2025, 12, 17, 14)),
        MyArticle(title: "B", date: DateTime(2025, 12, 17, 12)),
      ];

      // add articles to the database
      await database.managers.articleTable.bulkCreate(
        (o) => articlesToSave.map((e) => o(title: e.title, date: e.date)),
      );

      final result = await dataSource.getArticles(thisDateOrAfter: DateTime(2025, 12, 10));

      final expectedResult = Success([
        MyArticle(title: "A", date: DateTime(2025, 12, 17, 10)),
        MyArticle(title: "B", date: DateTime(2025, 12, 17, 12)),
        MyArticle(title: "C", date: DateTime(2025, 12, 17, 14)),
        MyArticle(title: "D", date: DateTime(2025, 12, 17, 16)),
      ]);

      expect(result, expectedResult);
    });
  });

  group("saveArticles", () {
    test("saving an empty list does not save anything", () async {
      await dataSource.saveArticles([]);

      final articlesInDatabase = await database.managers.articleTable.get();

      expect(articlesInDatabase, []);
    });

    test("saving a non empty list saves the articles", () async {
      final articlesToSave = [
        MyArticle(title: "A", date: DateTime(2025, 12, 17, 10)),
        MyArticle(title: "B", date: DateTime(2025, 12, 17, 12)),
        MyArticle(title: "C", date: DateTime(2025, 12, 17, 14)),
        MyArticle(title: "D", date: DateTime(2025, 12, 17, 16)),
      ];
      await dataSource.saveArticles(articlesToSave);

      final articlesInDatabase = await database.managers.articleTable.get();
      final articlesConverted = articlesInDatabase.map(
        (item) => MyArticle(title: item.title, date: item.date),
      );

      expect(articlesConverted, articlesToSave);
    });

    test("saving a repeated item saves all articles except that one", () async {
      final articlesToSave = [
        MyArticle(title: "A", date: DateTime(2025, 12, 17, 10)),
        MyArticle(title: "A", date: DateTime(2025, 12, 17, 10)),
        MyArticle(title: "C", date: DateTime(2025, 12, 17, 14)),
        MyArticle(title: "D", date: DateTime(2025, 12, 17, 16)),
      ];
      await dataSource.saveArticles(articlesToSave);

      final articlesInDatabase = await database.managers.articleTable.get();
      final articlesConverted = articlesInDatabase.map(
        (item) => MyArticle(title: item.title, date: item.date),
      );

      final expectedArticles = [
        MyArticle(title: "A", date: DateTime(2025, 12, 17, 10)),
        MyArticle(title: "C", date: DateTime(2025, 12, 17, 14)),
        MyArticle(title: "D", date: DateTime(2025, 12, 17, 16)),
      ];

      expect(articlesConverted, expectedArticles);
    });
  });
}
