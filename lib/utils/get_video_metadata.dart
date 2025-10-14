import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nostr_video_uploader/models/video_metadata.dart';

Future<VideoMetadata> getVideoMetadata(Uint8List bytes) async {
  Player? player;
  VideoController? controller;

  try {
    // Create player and video controller (controller must be kept alive for screenshots)
    player = Player();
    controller = VideoController(player);
    // ignore: unused_local_variable
    final _ = controller; // Keep controller alive for screenshot functionality
    await player.setVolume(0);
    await player.open(await Media.memory(bytes));

    // Wait for duration to be available
    await player.stream.duration.firstWhere(
      (duration) => duration > Duration.zero,
    );

    // Wait for tracks to be available
    await player.stream.tracks.firstWhere((tracks) => tracks.video.length > 2);

    final duration = player.state.duration;

    // Get dimensions from video track metadata
    final tracks = player.state.tracks;
    final videoTrack = tracks.video.firstWhere(
      (track) => track.w != null && track.h != null,
      orElse: () => tracks.video.first,
    );

    final width = videoTrack.w ?? 0;
    final height = videoTrack.h ?? 0;

    // Seek to 1 second (or start if video is shorter)
    final seekPosition = duration.inSeconds > 1
        ? Duration(seconds: 1)
        : Duration.zero;

    await player.seek(seekPosition);

    // Wait a bit for the frame to load
    await Future.delayed(Duration(milliseconds: 500));

    // Capture screenshot as Uint8List
    Uint8List? thumbnailBytes;
    try {
      thumbnailBytes = await player.screenshot();
      if (kDebugMode) {
        print('Screenshot result: ${thumbnailBytes?.length ?? "null"} bytes');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Screenshot error: $e');
      }
    }

    return VideoMetadata(
      duration: duration,
      width: width,
      height: height,
      thumbnail: thumbnailBytes,
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    throw Exception('Error getting video metadata: $e');
  } finally {
    // Clean up (VideoController will be cleaned up with player)
    await player?.dispose();
  }
}
