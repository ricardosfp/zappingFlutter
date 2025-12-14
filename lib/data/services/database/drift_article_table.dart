import 'package:drift/drift.dart';

@DataClassName("ArticleDataClass")
class ArticleTable extends Table {
  late final title = text().named("title")();
  late final date = dateTime().named("date")();

  @override
  String get tableName => 'Articles';

  @override
  Set<Column> get primaryKey => {title, date};
}
