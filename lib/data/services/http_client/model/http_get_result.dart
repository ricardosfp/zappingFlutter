import 'package:equatable/equatable.dart';
import 'package:equatable_annotations/equatable_annotations.dart';

part 'http_get_result.g.dart';

sealed class HttpGetResult extends Equatable {
  const HttpGetResult();
}

@generateProps
final class HttpGetSuccess extends HttpGetResult {
  final String bodyAsString;

  const HttpGetSuccess(this.bodyAsString);

  @override
  List<Object?> get props => _$props;
}

sealed class HttpGetError extends HttpGetResult {
  const HttpGetError();
}

@generateProps
final class HttpGetUnsuccessfulResponse extends HttpGetError {
  final String bodyAsString;

  const HttpGetUnsuccessfulResponse(this.bodyAsString);

  @override
  List<Object?> get props => _$props;
}

@generateProps
final class HttpGetException extends HttpGetError {
  final Exception exception;

  const HttpGetException(this.exception);

  @override
  List<Object?> get props => _$props;
}
