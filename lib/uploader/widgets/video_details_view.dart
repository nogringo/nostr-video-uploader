import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nostr_video_uploader/uploader/uploader_controller.dart';
import 'package:intl/intl.dart';

class VideoDetailsView extends StatelessWidget {
  const VideoDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Title", style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 4),
        TextField(
          controller: UploaderController.to.titleController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        SizedBox(height: 16),
        Text("Description", style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 4),
        TextField(
          controller: UploaderController.to.descriptionController,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        SizedBox(height: 16),
        Text("Tags", style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 4),
        TextField(
          controller: UploaderController.to.tagsController,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: UploaderController.to.addTags,
                icon: Icon(Icons.add),
              ),
            ),
          ),
          onChanged: UploaderController.to.tagsFieldChanged,
        ),
        Obx(() {
          if (UploaderController.to.tags.isEmpty) {
            return Container();
          }

          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              runSpacing: 8,
              spacing: 8,
              children: UploaderController.to.tags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      shape: StadiumBorder(),
                      onDeleted: () => UploaderController.to.tags.remove(tag),
                    ),
                  )
                  .toList(),
            ),
          );
        }),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Thumbnail",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Obx(() {
              return FilledButton.icon(
                onPressed: UploaderController.to.isPickingThumbnail.value
                    ? null
                    : UploaderController.to.selectThumbnail,
                label: Text("Select Thumbnail"),
                icon: Icon(Icons.image),
              );
            }),
          ],
        ),
        Obx(() {
          if (UploaderController.to.thumbnail.value == null) {
            return SizedBox(height: 16);
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(UploaderController.to.thumbnail.value!),
            ),
          );
        }),

        Obx(() {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "First time the video was published",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              DateFormat.yMMMMd().format(
                UploaderController.to.firstTimePublished.value,
              ),
            ),
            trailing: FilledButton.icon(
              onPressed: UploaderController.to.selectFirstTimePublished,
              label: Text("Select Date"),
              icon: Icon(Icons.calendar_month),
            ),
          );
        }),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Short Video", style: Theme.of(context).textTheme.titleMedium),
            Obx(() {
              return Switch(
                value: UploaderController.to.isShortVideo.value,
                onChanged: (value) {
                  UploaderController.to.isShortVideo.value = value;
                },
              );
            }),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("NSFW", style: Theme.of(context).textTheme.titleMedium),
            Obx(() {
              return Switch(
                value: UploaderController.to.isNSFW.value,
                onChanged: (value) {
                  UploaderController.to.isNSFW.value = value;
                },
              );
            }),
          ],
        ),
        SizedBox(height: 16),
        Obx(() {
          return FilledButton(
            onPressed: UploaderController.to.uploadState.value == 0
                ? UploaderController.to.upload
                : null,
            child: Text(
              [
                "Upload",
                "Fetching your blossoms servers",
                "Uploading video",
                "Uploading thumbnail",
                "Sending nostr event",
                "Done",
              ][UploaderController.to.uploadState.value],
            ),
          );
        }),
        SizedBox(height: 8),
        TextButton(
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: Text("Discard Changes"),
                content: Text("Your changes will be lost."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Back"),
                  ),
                  FilledButton(
                    onPressed: () {
                      UploaderController.to.reset();
                      Get.back();
                    },
                    child: Text("Reset"),
                  ),
                ],
              ),
            );
          },
          child: Text("Reset"),
        ),
      ],
    );
  }
}
