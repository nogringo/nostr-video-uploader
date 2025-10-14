import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nostr_video_uploader/repository.dart';
import 'package:nostr_video_uploader/utils/fetch_info_from_bytes.dart';
import 'package:nostr_video_uploader/utils/get_video_duration.dart';
import 'package:path/path.dart' as p;

class UploaderController extends GetxController {
  static UploaderController get to => Get.find();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagsController = TextEditingController();
  RxSet<String> tags = RxSet<String>({});
  Rx<DateTime> firstTimePublished = Rx<DateTime>(DateTime.now());

  Rx<bool> isPickingVideo = false.obs;
  Rx<Uint8List?> video = Rx<Uint8List?>(null);
  String videoExtention = "mp4";

  Rx<bool> isPickingThumbnail = false.obs;
  Rx<Uint8List?> thumbnail = Rx<Uint8List?>(null);
  String thumbnailExtention = "png";

  Rx<bool> isShortVideo = false.obs;
  Rx<bool> isNSFW = false.obs;

  Rx<bool> isAccountsExpanded = false.obs;
  Rx<bool> isUploading = false.obs;

  void selectVideo() async {
    isPickingVideo.value = true;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Select Video",
      type: FileType.video,
    );
    isPickingVideo.value = false;

    if (result == null) return;
    if (result.files.isEmpty) return;

    titleController.text = p.basenameWithoutExtension(result.files.first.name);
    videoExtention = p.extension(result.files.first.name).split(".").join("");

    if (kIsWeb) {
      video.value = result.files.first.bytes;
      return;
    }

    File file = File(result.files.single.path!);
    video.value = await file.readAsBytes();
  }

  void selectThumbnail() async {
    isPickingThumbnail.value = true;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Select Thumbnail",
      type: FileType.image,
    );
    isPickingThumbnail.value = false;

    if (result == null) return;
    if (result.files.isEmpty) return;

    thumbnailExtention = p.extension(result.files.first.name).split(".").join("");

    if (kIsWeb) {
      thumbnail.value = result.files.first.bytes;
      return;
    }

    File file = File(result.files.single.path!);
    thumbnail.value = await file.readAsBytes();
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

    isUploading.value = true;

    final userBlossoms = await ndk.blossomUserServerList.getUserServerList(
      pubkeys: [ndk.accounts.getPublicKey()!],
    );

    final a = await getVideoDuration(video.value!);
    print(a);

    // final videoUploadResponse = await ndk.blossom.uploadBlob(
    //   data: video.value!,
    //   serverUrls: userBlossoms ?? ["https://blossom-01.uid.ovh"],
    //   contentType: "video/$videoExtention",
    // );

    // if (thumbnail.value != null) {
    //   final thumbnailUploadResponse = await ndk.blossom.uploadBlob(
    //     data: thumbnail.value!,
    //     serverUrls: userBlossoms ?? ["https://blossom-01.uid.ovh"],
    //     contentType: "image/$thumbnailExtention",
    //   );
    // }

    final imeta = ["imeta", "dim"];
  }

  void reset() {
    titleController.clear();
    descriptionController.clear();
    video.value = null;
    thumbnail.value = null;
    isShortVideo.value = false;
    isNSFW.value = false;
  }
}
