import 'package:http/http.dart';
import 'package:zapping_flutter/data/repository/model/my_article.dart';

sealed class GetArticlesResult {}

class GetArticlesSuccess implements GetArticlesResult {
  final List<MyArticle> articles;

  GetArticlesSuccess(this.articles);
}

sealed class GetArticlesError extends GetArticlesResult {}

class GetArticlesHttpError implements GetArticlesError {
  // todo this exception is implementation dependent, create your own independent classes
  final ClientException exception;

  GetArticlesHttpError(this.exception);
}

// todo this is implementation dependent, find another way
class GetArticlesParseError implements GetArticlesError {
  final ArgumentError exception;

  GetArticlesParseError(this.exception);
}

class GetArticlesOtherExceptionError implements GetArticlesError {
  final Exception exception;

  GetArticlesOtherExceptionError(this.exception);
}
