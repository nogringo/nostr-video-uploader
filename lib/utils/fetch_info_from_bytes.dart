import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:nostr_video_uploader/models/media_info.dart';

Future<void> fetchInfoFromMemory(Uint8List videoBytes) async {
  // 1️⃣ Initialise a fresh player (no UI needed here).
  final player = Player();

  // 2️⃣ Open the in‑memory media.
  //    Media.memory tells media_kit to treat the byte buffer as a file.

  final media = await Media.memory(videoBytes);

  print(media.end);

  // await player.open(media);

  // await player.screenshot();

  // // 3️⃣ Helper futures that complete once the respective streams emit a non‑null value.
  // Future<Size> waitForSize() async {
  //   return await player.videoSizeStream
  //       .firstWhere((sz) => sz != null) as Size;
  // }

  // Future<Duration> waitForDuration() async {
  //   return await player.durationStream
  //       .firstWhere((d) => d != null) as Duration;
  // }

  // // 4️⃣ Run both futures in parallel.
  // final results = await Future.wait([waitForSize(), waitForDuration()]);
  // final Size size = results[0] as Size;
  // final Duration duration = results[1] as Duration;

  // // 5️⃣ Clean up the player.
  // await player.dispose();

  // // 6️⃣ Return the gathered info.
  // return MediaInfo(size: size, duration: duration);
}
