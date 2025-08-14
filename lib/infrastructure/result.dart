import 'package:equatable/equatable.dart';
import 'package:equatable_annotations/equatable_annotations.dart';

part 'result.g.dart';

sealed class Result<T> extends Equatable {
  const Result();
}

@generateProps
final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  List<Object?> get props => _$props;
}

@generateProps
final class Error<T> extends Result<T> {
  const Error();

  @override
  List<Object?> get props => _$props;
}
