
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;

  T? get valueOrNull => switch (this) {
        Success(value: final value) => value,
        Failure() => null,
      };

  Exception? get errorOrNull => switch (this) {
        Success() => null,
        Failure(error: final error) => error,
      };

  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success(value: final value) => Success(transform(value)),
      Failure(error: final error) => Failure(error),
    };
  }

  /// Execute callback based on result
  R when<R>({
    required R Function(T value) success,
    required R Function(Exception error) failure,
  }) {
    return switch (this) {
      Success(value: final value) => success(value),
      Failure(error: final error) => failure(error),
    };
  }

  T getOrThrow() {
    return switch (this) {
      Success(value: final value) => value,
      Failure(error: final error) => throw error,
    };
  }

  T getOrElse(T defaultValue) {
    return switch (this) {
      Success(value: final value) => value,
      Failure() => defaultValue,
    };
  }
}

class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  String toString() => 'Success($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Failure result
class Failure<T> extends Result<T> {
  final Exception error;

  const Failure(this.error);

  @override
  String toString() => 'Failure($error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> && error == other.error;

  @override
  int get hashCode => error.hashCode;
}

extension FutureResultExtension<T> on Future<Result<T>> {
  Future<Result<R>> mapAsync<R>(Future<R> Function(T value) transform) async {
    final result = await this;
    return switch (result) {
      Success(value: final value) => Success(await transform(value)),
      Failure(error: final error) => Failure(error),
    };
  }
}

Result<T> runCatching<T>(T Function() block) {
  try {
    return Success(block());
  } on Exception catch (e) {
    return Failure(e);
  } catch (e) {
    return Failure(Exception(e.toString()));
  }
}

Future<Result<T>> runCatchingAsync<T>(Future<T> Function() block) async {
  try {
    return Success(await block());
  } on Exception catch (e) {
    return Failure(e);
  } catch (e) {
    return Failure(Exception(e.toString()));
  }
}