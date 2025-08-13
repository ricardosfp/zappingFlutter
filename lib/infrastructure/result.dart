sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);
}

final class Error<T> extends Result<T> {
  const Error();
}
