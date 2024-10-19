import 'package:http/http.dart';
import 'package:zapping_flutter/data/repository/model/my_article.dart';

sealed class GetArticlesResult {}

class GetArticlesSuccess implements GetArticlesResult {
  final List<MyArticle> articles;

  GetArticlesSuccess(List<MyArticle> articlesParameter)
      : articles = List.unmodifiable(articlesParameter);
}

sealed class GetArticlesError extends GetArticlesResult {}

final class GetArticlesHttpError implements GetArticlesError {
  // todo this exception is implementation dependent, create your own independent classes
  final ClientException exception;

  GetArticlesHttpError(this.exception);
}

final class GetArticlesParseError implements GetArticlesError {
  final Exception exception;

  GetArticlesParseError(this.exception);
}

final class GetArticlesOtherExceptionError implements GetArticlesError {
  final Exception exception;

  GetArticlesOtherExceptionError(this.exception);
}
