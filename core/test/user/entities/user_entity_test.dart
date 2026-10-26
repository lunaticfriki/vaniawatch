import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    group('create', () {
      test('keeps the given values', () {
        final id = UserIdMother.random();
        final name = UserNameMother.random();
        final email = UserEmailMother.random();
        final createdAt = CreatedAtMother.random();

        final user = User.create(
          id: id,
          name: name,
          email: email,
          createdAt: createdAt,
        );

        expect(user.id, id);
        expect(user.name, name);
        expect(user.email, email);
        expect(user.createdAt, createdAt);
      });

      test('starts with the update moment equal to the creation moment', () {
        final createdAt = CreatedAtMother.random();

        final user = UserMother.random(createdAt: createdAt);

        expect(user.updatedAt, UpdatedAt.fromCreatedAt(createdAt));
      });
    });

    group('restore', () {
      test('keeps the given update moment', () {
        final createdAt = CreatedAtMother.random();
        final updatedAt = UpdatedAtMother.afterCreation(createdAt);

        final user = UserMother.restored(
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

        expect(user.createdAt, createdAt);
        expect(user.updatedAt, updatedAt);
      });

      test('rejects an update moment before the creation moment', () {
        final createdAt = CreatedAtMother.random();

        expect(
          () => UserMother.restored(
            createdAt: createdAt,
            updatedAt: UpdatedAtMother.beforeCreation(createdAt),
          ),
          throwsA(isA<InvalidUpdatedAtError>()),
        );
      });
    });

    group('rename', () {
      test('changes the name and the update moment', () {
        final user = UserMother.random();
        final name = UserNameMother.random();
        final at = UpdatedAtMother.after(user.updatedAt);

        user.rename(name, at: at);

        expect(user.name, name);
        expect(user.updatedAt, at);
      });

      test('rejects a moment before the last update', () {
        final user = UserMother.restored();
        final name = user.name;

        expect(
          () => user.rename(
            UserNameMother.random(),
            at: UpdatedAtMother.before(user.updatedAt),
          ),
          throwsA(isA<InvalidUpdatedAtError>()),
        );
        expect(user.name, name);
      });
    });

    group('changeEmail', () {
      test('changes the email and the update moment', () {
        final user = UserMother.random();
        final email = UserEmailMother.random();
        final at = UpdatedAtMother.after(user.updatedAt);

        user.changeEmail(email, at: at);

        expect(user.email, email);
        expect(user.updatedAt, at);
      });

      test('rejects a moment before the last update', () {
        final user = UserMother.restored();
        final email = user.email;

        expect(
          () => user.changeEmail(
            UserEmailMother.random(),
            at: UpdatedAtMother.before(user.updatedAt),
          ),
          throwsA(isA<InvalidUpdatedAtError>()),
        );
        expect(user.email, email);
      });
    });

    group('equality', () {
      test('is equal to a user with the same id', () {
        final id = UserIdMother.random();

        expect(UserMother.random(id: id), UserMother.random(id: id));
        expect(
          UserMother.random(id: id).hashCode,
          UserMother.random(id: id).hashCode,
        );
      });

      test('is not equal to a user with a different id', () {
        expect(UserMother.random(), isNot(UserMother.random()));
      });
    });

    group('empty', () {
      test('is empty', () {
        expect(UserMother.empty().isEmpty, isTrue);
      });

      test('a created user is not empty', () {
        expect(UserMother.random().isEmpty, isFalse);
      });
    });
  });
}
