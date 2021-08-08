abstract class GenericState {}

class GenericInitial extends GenericState {}

class GenericLoading extends GenericState {}

class GenericCompleted<T> extends GenericState {
  final List<T> response;
  GenericCompleted(this.response);
}

class GenericError extends GenericState {
  final String message;
  final String statusCode;

  GenericError(this.message, this.statusCode);
}
