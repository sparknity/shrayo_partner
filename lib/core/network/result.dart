import 'failure.dart';

/// A generic sealed class representing either a Success ([Success]) with data [T]
/// or a Error ([ErrorResult]) with a [Failure].
sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(Failure failure) = ErrorResult<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ErrorResult<T>;

  T? get dataOrNull => switch (this) {
        Success(data: final d) => d,
        ErrorResult() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success() => null,
        ErrorResult(failure: final f) => f,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success(data: final d) => success(d),
      ErrorResult(failure: final f) => failure(f),
    };
  }
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

final class ErrorResult<T> extends Result<T> {
  final Failure failure;
  const ErrorResult(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorResult<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
