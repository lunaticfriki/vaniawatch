final class CloudinaryConfig {
  const CloudinaryConfig._({
    required this.cloudName,
    required this.uploadPreset,
  });

  factory CloudinaryConfig.create({
    required String cloudName,
    required String uploadPreset,
  }) => CloudinaryConfig._(
    cloudName: cloudName.trim(),
    uploadPreset: uploadPreset.trim(),
  );

  factory CloudinaryConfig.fromEnvironment() => CloudinaryConfig.create(
    cloudName: _cloudName,
    uploadPreset: _uploadPreset,
  );

  static const String _cloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
  );
  static const String _uploadPreset = String.fromEnvironment(
    'CLOUDINARY_UPLOAD_PRESET',
  );

  final String cloudName;
  final String uploadPreset;

  bool get isConfigured => cloudName.isNotEmpty && uploadPreset.isNotEmpty;

  Uri get uploadUri =>
      Uri.https('api.cloudinary.com', '/v1_1/$cloudName/image/upload');
}
