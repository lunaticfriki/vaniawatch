final class CreatedAt {
  const CreatedAt._(this.value);

  factory CreatedAt.create(DateTime value) => CreatedAt._(value.toUtc());

  factory CreatedAt.now() => CreatedAt._(DateTime.now().toUtc());

  factory CreatedAt.empty() =>
      CreatedAt._(DateTime.fromMillisecondsSinceEpoch(0, isUtc: true));

  final DateTime value;

  bool get isEmpty => value.millisecondsSinceEpoch == 0;

  @override
  bool operator ==(Object other) => other is CreatedAt && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toIso8601String();
}
