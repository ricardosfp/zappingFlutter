import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:zapping_flutter/data/services/database/drift_article_table.dart';

part 'drift_database.g.dart';

@DriftDatabase(tables: [ArticleTable])
final class AppDatabase extends _$AppDatabase {
  static const _databaseName = "database";

  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: _databaseName);
  }
}
