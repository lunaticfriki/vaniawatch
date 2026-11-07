import 'package:core/core.dart';

final class WatchDraft {
  const WatchDraft._({
    required this.name,
    required this.brand,
    required this.type,
    required this.category,
    required this.description,
    required this.tags,
    required this.complications,
    required this.imageUrl,
  });

  factory WatchDraft.create({
    required String name,
    required String brand,
    required String type,
    required String category,
    required String description,
    required List<String> tags,
    required List<String> complications,
  }) {
    final errors = <DomainError>[];
    T? attempt<T>(T Function() build) {
      try {
        return build();
      } on DomainError catch (error) {
        errors.add(error);
        return null;
      }
    }

    final validName = attempt(() => WatchName.create(name));
    final validBrand = attempt(() => WatchBrand.create(brand));
    final validType = attempt(() => WatchType.create(type));
    final validCategory = attempt(() => WatchCategory.create(category));
    final validDescription = attempt(
      () => WatchDescription.create(description),
    );
    final validTags = [
      for (final tag in tags) attempt(() => WatchTag.create(tag)),
    ];
    final validTagSet = validTags.contains(null)
        ? null
        : attempt(() => WatchTags.create(validTags.nonNulls.toList()));

    if (errors.isNotEmpty) {
      throw WatchDraftRejectedException(errors);
    }
    return WatchDraft._(
      name: validName!,
      brand: validBrand!,
      type: validType!,
      category: validCategory!,
      description: validDescription!,
      tags: validTagSet!,
      complications: List.unmodifiable(complications),
      imageUrl: WatchImageUrl.empty(),
    );
  }

  static final List<String> types = List.unmodifiable([
    WatchType.analog().value,
    WatchType.digital().value,
    WatchType.anaDigi().value,
  ]);

  static final List<String> categories = List.unmodifiable([
    WatchCategory.mechanical().value,
    WatchCategory.quartz().value,
  ]);

  final WatchName name;
  final WatchBrand brand;
  final WatchType type;
  final WatchCategory category;
  final WatchDescription description;
  final WatchTags tags;
  final List<String> complications;
  final WatchImageUrl imageUrl;

  WatchDraft withImage(WatchImageUrl imageUrl) => WatchDraft._(
    name: name,
    brand: brand,
    type: type,
    category: category,
    description: description,
    tags: tags,
    complications: complications,
    imageUrl: imageUrl,
  );
}

final class WatchDraftRejectedException implements Exception {
  WatchDraftRejectedException(List<DomainError> errors)
    : errors = List.unmodifiable(errors);

  final List<DomainError> errors;

  @override
  String toString() => 'The watch is invalid: ${errors.join('; ')}';
}
