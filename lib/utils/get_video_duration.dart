import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';

Future<Duration> getVideoDuration(Uint8List bytes) async {
  Player? player;

  try {
    // Create player and open media from memory
    player = Player();
    await player.open(await Media.memory(bytes));

    // Wait for duration to be available
    await player.stream.duration
        .firstWhere((duration) => duration > Duration.zero);

    final duration = player.state.duration;

    return duration;
  } catch (e) {
    throw Exception('Error getting video duration: $e');
  } finally {
    // Clean up
    await player?.dispose();
  }
}
