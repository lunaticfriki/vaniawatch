final class InvalidRequestError implements Exception {
  const InvalidRequestError(this.message);

  final String message;

  @override
  String toString() => message;
}
