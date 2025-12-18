import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/data/repository/zapping/data_source/local/zapping_data_source_local.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/data/services/database/drift_database.dart';
import 'package:zapping_flutter/infrastructure/result.dart';

@Injectable(as: ZappingDataSourceLocal)
class ZappingDataSourceLocalDatabase implements ZappingDataSourceLocal {
  final AppDatabase database;

  ZappingDataSourceLocalDatabase({required this.database});

  @override
  Future<Result<List<MyArticle>>> getArticles() async {
    try {
      // get the articles from the database
      final result = await database.managers.articleTable.orderBy((o) => o.date.asc()).get();

      // convert them into [MyArticle]
      final mappedResult = result
          .map((item) => MyArticle(title: item.title, date: item.date))
          .toList();

      return Success(mappedResult);
    } catch (_) {
      return Error();
    }
  }

  @override
  Future<void> saveArticles(List<MyArticle> articles) async {
    try {
      await database.managers.articleTable.bulkCreate(
        (o) => articles.map((article) => o(title: article.title, date: article.date)),
        mode: InsertMode.insertOrIgnore,
      );
    } catch (_) {}
  }
}
