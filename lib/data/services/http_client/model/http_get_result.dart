import 'package:autoequal/autoequal.dart';
import 'package:equatable/equatable.dart';

part 'http_get_result.g.dart';

sealed class HttpGetResult extends Equatable {
  const HttpGetResult();
}

@autoequal
final class HttpGetSuccess extends HttpGetResult {
  final String bodyAsString;

  const HttpGetSuccess(this.bodyAsString);

  @override
  List<Object?> get props => _$props;
}

sealed class HttpGetError extends HttpGetResult {
  const HttpGetError();
}

@autoequal
final class HttpGetUnsuccessfulResponse extends HttpGetError {
  final String bodyAsString;

  const HttpGetUnsuccessfulResponse(this.bodyAsString);

  @override
  List<Object?> get props => _$props;
}

@autoequal
final class HttpGetException extends HttpGetError {
  final Exception exception;

  const HttpGetException(this.exception);

  @override
  List<Object?> get props => _$props;
}
