import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/infrastructure/acl/watch_mapper.dart';

import '../../application/watch_draft_mother.dart';
import 'watch_json_mother.dart';

void main() {
  group('WatchMapper', () {
    test('restores a watch from the api json, owned by the caller', () {
      final owner = UserIdMother.random();
      final source = WatchMother.restored(owner: owner);

      final watch = WatchMapper.toDomain(
        WatchJsonMother.fromWatch(source),
        owner: owner,
      );

      expect(watch.id, source.id);
      expect(watch.owner, owner);
      expect(watch.name, source.name);
      expect(watch.description, source.description);
      expect(watch.brand, source.brand);
      expect(watch.type, source.type);
      expect(watch.category, source.category);
      expect(watch.tags, source.tags);
      expect(watch.complications, source.complications);
      expect(watch.imageUrl, source.imageUrl);
      expect(watch.createdAt.value, source.createdAt.value.toUtc());
      expect(watch.updatedAt.value, source.updatedAt.value.toUtc());
    });

    test('restores a watch without image from a null image url', () {
      final json = WatchJsonMother.fromWatch(WatchMother.withoutImage());

      final watch = WatchMapper.toDomain(json, owner: UserIdMother.random());

      expect(watch.imageUrl.isEmpty, isTrue);
    });

    test('rejects json that breaks a domain rule', () {
      final json = {...WatchJsonMother.random(), 'type': 'sundial'};

      expect(
        () => WatchMapper.toDomain(json, owner: UserIdMother.random()),
        throwsA(isA<InvalidWatchTypeError>()),
      );
    });

    test('writes a draft as the api create payload', () {
      final draft = WatchDraftMother.withImage();

      expect(WatchMapper.toJson(draft), {
        'name': draft.name.value,
        'brand': draft.brand.value,
        'type': draft.type.value,
        'category': draft.category.value,
        'description': draft.description.value,
        'tags': draft.tags.values.map((tag) => tag.value).toList(),
        'complications': draft.complications,
        'imageUrl': draft.imageUrl.value,
      });
    });

    test('writes an empty image url for a draft without image', () {
      expect(WatchMapper.toJson(WatchDraftMother.random())['imageUrl'], '');
    });
  });
}
