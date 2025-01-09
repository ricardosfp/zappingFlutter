import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';

sealed class GetArticlesResult {}

class GetArticlesSuccess implements GetArticlesResult {
  final List<MyArticle> articles;

  GetArticlesSuccess(List<MyArticle> articlesParameter) : articles = List.unmodifiable(articlesParameter);
}

sealed class GetArticlesError extends GetArticlesResult {}

final class GetArticlesHttpError implements GetArticlesError {
  static const GetArticlesHttpError _instance = GetArticlesHttpError._();

  const GetArticlesHttpError._();

  factory GetArticlesHttpError() => _instance;
}

final class GetArticlesParseError implements GetArticlesError {
  static const GetArticlesParseError _instance = GetArticlesParseError._();

  const GetArticlesParseError._();

  factory GetArticlesParseError() => _instance;
}

final class GetArticlesOtherExceptionError implements GetArticlesError {
  final Exception exception;

  const GetArticlesOtherExceptionError(this.exception);
}
