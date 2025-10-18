import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nostr_video_uploader/models/video_metadata.dart';

/// Extracts metadata from video bytes including duration, dimensions, and thumbnail
Future<VideoMetadata> getVideoMetadata(Uint8List videoBytes) async {
  // Initialize media player with video controller
  final player = Player();
  // ignore: unused_local_variable
  final controller = VideoController(player); // Helps initialize video pipeline

  try {
    // Open the video from memory
    final media = await Media.memory(videoBytes);
    await player.open(media);
    player.setVolume(0);

    // Wait a bit for the player to load the video
    await Future.delayed(const Duration(seconds: 1));

    // Try to get metadata from player state
    // If not available, wait for streams
    Duration duration = player.state.duration;
    int? width = player.state.width;
    int? height = player.state.height;

    if (duration == Duration.zero || width == null || height == null) {
      await Future.wait([
        if (duration == Duration.zero)
          player.stream.duration.firstWhere((d) => d != Duration.zero),
        if (width == null || width == 0)
          player.stream.width.firstWhere((w) => w != null && w > 0),
        if (height == null || height == 0)
          player.stream.height.firstWhere((h) => h != null && h > 0),
      ]).timeout(
        const Duration(seconds: 10),
        onTimeout: () =>
            throw Exception('Timeout while loading video metadata'),
      );

      // Re-read from state after waiting
      duration = player.state.duration;
      width = player.state.width;
      height = player.state.height;
    }

    // Extract thumbnail (seek to 1 second or 10% of duration)
    Uint8List? thumbnail;
    try {
      final seekPosition = duration > const Duration(seconds: 2)
          ? const Duration(seconds: 1)
          : Duration(milliseconds: (duration.inMilliseconds * 0.1).toInt());

      await player.seek(seekPosition);
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Wait for frame to load

      thumbnail = await player.screenshot();
    } catch (e) {
      debugPrint('Error extracting thumbnail: $e');
    }

    return VideoMetadata(
      duration: duration,
      width: width ?? 0,
      height: height ?? 0,
      thumbnail: thumbnail,
    );
  } finally {
    // Dispose player
    await player.dispose();
  }
}
