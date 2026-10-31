final class RequestUser {
  const RequestUser._(this.id);

  factory RequestUser.create(String id) => RequestUser._(id);

  static const String header = 'x-user-id';

  final String id;
}
