import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:ndk/domain_layer/entities/nip_01_event.dart';
import 'package:nip19/nip19.dart';
import 'package:nostr_video_uploader/l10n/app_localizations.dart';
import 'package:nostr_video_uploader/models/video_metadata.dart';
import 'package:nostr_video_uploader/repository.dart';
import 'package:nostr_video_uploader/utils/get_video_metadata.dart';
import 'package:nostr_video_uploader/utils/nevent.dart';
import 'package:nostr_video_uploader/utils/text_parser.dart';
import 'package:path/path.dart' as p;

class UploaderController extends GetxController {
  static UploaderController get to => Get.find();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagsController = TextEditingController();
  RxSet<String> tags = RxSet<String>({});
  final linksController = TextEditingController();
  RxSet<String> links = RxSet<String>({});
  final participantsController = TextEditingController();
  RxSet<String> participants = RxSet<String>({});
  Rx<DateTime> firstTimePublished = Rx<DateTime>(DateTime.now());

  Rx<bool> isPickingVideo = false.obs;
  Rx<Uint8List?> video = Rx<Uint8List?>(null);
  late VideoMetadata videoMetadata;
  String videoExtention = "mp4";
  String videoBasename = "";

  Rx<bool> isPickingThumbnail = false.obs;
  Rx<Uint8List?> thumbnail = Rx<Uint8List?>(null);
  String thumbnailExtention = "jpeg";
  String thumbnailBasename = "";

  Rx<bool> isShortVideo = false.obs;
  Rx<bool> isNSFW = false.obs;

  Rx<bool> isAccountsExpanded = false.obs;
  Rx<int> uploadState = 0.obs;

  Nevent? rawNevent;
  Rx<String?> nevent = Rx<String?>(null);

  void selectVideo() async {
    isPickingVideo.value = true;
    final l10n = AppLocalizations.of(Get.context!)!;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: l10n.selectVideoTitle,
      type: FileType.video,
    );
    isPickingVideo.value = false;

    if (result == null) return;
    if (result.files.isEmpty) return;

    videoBasename = result.files.first.name;
    titleController.text = p.basenameWithoutExtension(videoBasename);
    tags.addAll(extractLinksAndHashtags(titleController.text).hashtags);
    videoExtention = p.extension(videoBasename).split(".").join("");

    if (kIsWeb) {
      video.value = result.files.first.bytes;
    } else {
      File file = File(result.files.single.path!);
      video.value = await file.readAsBytes();
    }

    videoMetadata = await getVideoMetadata(video.value!);
    print(videoMetadata.duration);
    print(videoMetadata.height);
    print(videoMetadata.width);
    print(videoMetadata.thumbnail == null);

    if (videoMetadata.thumbnail != null) {
      thumbnail.value = videoMetadata.thumbnail;
    }
  }

  void selectThumbnail() async {
    isPickingThumbnail.value = true;
    final l10n = AppLocalizations.of(Get.context!)!;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: l10n.selectThumbnailTitle,
      type: FileType.image,
    );
    isPickingThumbnail.value = false;

    if (result == null) return;
    if (result.files.isEmpty) return;

    thumbnailBasename = result.files.first.name;
    thumbnailExtention = p.extension(thumbnailBasename).split(".").join("");

    if (kIsWeb) {
      thumbnail.value = result.files.first.bytes;
      return;
    }

    File file = File(result.files.single.path!);
    thumbnail.value = await file.readAsBytes();
  }

  void titleFieldFocusChanged(bool hasFocus) {
    if (hasFocus) return;
    tags.addAll(extractLinksAndHashtags(titleController.text).hashtags);
  }

  void descriptionFieldFocusChanged(bool hasFocus) {
    if (hasFocus) return;
    final extraction = extractLinksAndHashtags(descriptionController.text);
    tags.addAll(extraction.hashtags);
    links.addAll(extraction.links);
  }

  void tagsFieldChanged(String value) {
    if (!tagsController.text.contains(" ")) return;
    addTags();
  }

  void addTags() {
    tagsController.text
        .split(" ")
        .where((part) => part.isNotEmpty)
        .forEach((tag) => tags.add(tag));

    tagsController.clear();
  }

  void addLink() {
    links.add(linksController.text.trim());
    linksController.clear();
  }

  void participantFieldChanged(String value) {
    try {
      final pubkey = Nip19.npubToHex(value.trim());
      participants.add(pubkey);
      participantsController.clear();
    } catch (e) {
      //
    }
  }

  void selectFirstTimePublished() async {
    final date = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (date == null) return;

    firstTimePublished.value = date;
  }

  void upload() async {
    final ndk = Repository.ndk;

    uploadState.value = 1;

    final userBlossoms = await ndk.blossomUserServerList.getUserServerList(
      pubkeys: [ndk.accounts.getPublicKey()!],
    );
    final defaultBlossoms = [
      "https://blossom.yakihonne.com",
      "https://blossom-01.uid.ovh",
      "https://blossom.primal.net",
    ];
    final blossoms = userBlossoms ?? defaultBlossoms;

    uploadState.value = 2;

    final videoContentType = lookupMimeType(videoBasename);

    final videoUploadResponse = await ndk.blossom.uploadBlob(
      data: video.value!,
      serverUrls: blossoms,
      contentType: videoContentType,
    );

    final successVideoUploadResponses = videoUploadResponse.where(
      (res) => res.success,
    );

    if (successVideoUploadResponses.isEmpty) {
      // TODO show error
      return;
    }

    final videoSha256 = successVideoUploadResponses.first.descriptor!.sha256;

    final videoUrls = blossoms.map((url) {
      final normalizedUrl = url.endsWith("/") ? url : "$url/";
      return "$normalizedUrl$videoSha256.$videoExtention";
    });

    final imeta = [
      "imeta",
      "dim ${videoMetadata.width}x${videoMetadata.height}",
      "url ${videoUrls.first}",
      "x $videoSha256",
      "m $videoContentType",
    ];

    if (thumbnail.value != null) {
      uploadState.value = 3;

      final thumbnailUploadResponse = await ndk.blossom.uploadBlob(
        data: thumbnail.value!,
        serverUrls: blossoms,
        contentType: lookupMimeType(thumbnailBasename),
      );

      final successThumbnailUploadResponses = thumbnailUploadResponse.where(
        (res) => res.success,
      );

      final thumbnailSha256 =
          successThumbnailUploadResponses.first.descriptor!.sha256;
      imeta.addAll(
        blossoms.map((url) {
          final normalizedUrl = url.endsWith("/") ? url : "$url/";
          return "image $normalizedUrl$thumbnailSha256.$thumbnailExtention";
        }),
      );
    }

    imeta.addAll(videoUrls.skip(1).map((url) => "fallback $url"));

    final description = descriptionController.text.trim();

    final eventTags = [
      ["title", titleController.text.trim()],
      [
        "published_at",
        "${firstTimePublished.value.millisecondsSinceEpoch ~/ 1000}",
      ],
      ["alt", description],

      imeta,

      ["duration", videoMetadata.duration.inSeconds.toString()],
    ];

    eventTags.addIf(isNSFW, ["content-warning", "nsfw"]);
    eventTags.addAll(participants.map((pubkey) => ["p", pubkey]));
    eventTags.addAll(tags.map((tag) => ["t", tag]));
    eventTags.addAll(links.map((link) => ["r", link]));

    final nostrEvent = Nip01Event(
      pubKey: ndk.accounts.getPublicKey()!,
      kind: isShortVideo.value ? 22 : 21,
      tags: eventTags,
      content: description,
    );

    uploadState.value = 4;

    final broadcastRes = ndk.broadcast.broadcast(nostrEvent: nostrEvent);

    final relayBroadcastResponses = await broadcastRes.broadcastDoneFuture;

    rawNevent = Nevent(
      eventId: nostrEvent.id,
      author: nostrEvent.pubKey,
      kind: nostrEvent.kind,
      relays: relayBroadcastResponses
          .where((res) => res.broadcastSuccessful)
          .map((res) => res.relayUrl)
          .toList(),
    );
    nevent.value = NeventCodec.encode(rawNevent!);

    uploadState.value = 5;
  }

  void reset() {
    titleController.clear();
    descriptionController.clear();
    tagsController.clear();
    tags.clear();
    firstTimePublished.value = DateTime.now();
    video.value = null;
    thumbnail.value = null;
    videoExtention = "mp4";
    videoBasename = "";
    thumbnailExtention = "jpeg";
    thumbnailBasename = "";
    isShortVideo.value = false;
    isNSFW.value = false;
    uploadState.value = 0;
    rawNevent = null;
    nevent.value = null;
  }
}
