import 'package:file_selector/file_selector.dart';
import 'package:frontend/modules/watch/application/watch_image.dart';
import 'package:frontend/modules/watch/application/watch_image_picker.dart';

typedef OpenImageFile = Future<XFile?> Function(List<XTypeGroup> groups);

final class FileSelectorWatchImagePicker implements WatchImagePicker {
  const FileSelectorWatchImagePicker({this._openImage = _openFile});

  static const String fallbackFileName = 'watch-image';

  static const XTypeGroup _images = XTypeGroup(
    label: 'Images',
    extensions: ['jpg', 'jpeg', 'png', 'webp', 'gif', 'heic'],
    uniformTypeIdentifiers: ['public.image'],
  );

  final OpenImageFile _openImage;

  static Future<XFile?> _openFile(List<XTypeGroup> groups) =>
      openFile(acceptedTypeGroups: groups);

  @override
  Future<WatchImage?> pick() async {
    final file = await _openImage(const [_images]);
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) return null;
    return WatchImage.create(
      bytes: bytes,
      fileName: file.name.trim().isEmpty ? fallbackFileName : file.name,
    );
  }
}
