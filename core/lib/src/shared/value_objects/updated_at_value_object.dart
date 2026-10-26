import 'package:core/src/shared/value_objects/created_at_value_object.dart';

final class UpdatedAt {
  const UpdatedAt._(this.value);

  factory UpdatedAt.create(DateTime value) => UpdatedAt._(value.toUtc());

  factory UpdatedAt.now() => UpdatedAt._(DateTime.now().toUtc());

  factory UpdatedAt.fromCreatedAt(CreatedAt createdAt) =>
      UpdatedAt._(createdAt.value);

  factory UpdatedAt.empty() =>
      UpdatedAt._(DateTime.fromMillisecondsSinceEpoch(0, isUtc: true));

  final DateTime value;

  bool get isEmpty => value.millisecondsSinceEpoch == 0;

  bool isBefore(UpdatedAt other) => value.isBefore(other.value);

  bool isBeforeCreation(CreatedAt createdAt) => value.isBefore(createdAt.value);

  @override
  bool operator ==(Object other) => other is UpdatedAt && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toIso8601String();
}
