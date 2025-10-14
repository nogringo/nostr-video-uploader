import 'dart:typed_data';

class VideoMetadata {
  final Duration duration;
  final int width;
  final int height;
  final Uint8List? thumbnail;

  VideoMetadata({
    required this.duration,
    required this.width,
    required this.height,
    this.thumbnail,
  });
}
