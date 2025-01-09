sealed class HttpGetResult {}

final class HttpGetSuccess implements HttpGetResult {
  final String bodyAsString;

  const HttpGetSuccess(this.bodyAsString);
}

sealed class HttpGetError extends HttpGetResult {}

final class HttpGetUnsuccessfulResponse implements HttpGetError {
  final String bodyAsString;

  const HttpGetUnsuccessfulResponse(this.bodyAsString);
}

final class HttpGetException implements HttpGetError {
  final Exception exception;

  const HttpGetException(this.exception);
}
