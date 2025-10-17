import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nostr_video_uploader/l10n/app_localizations.dart';
import 'package:nostr_video_uploader/repository.dart';
import 'package:nostr_video_uploader/uploader/uploader_controller.dart';
import 'package:intl/intl.dart';
import 'package:nostr_widgets/nostr_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoDetailsView extends StatelessWidget {
  const VideoDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.title, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 4),
        Focus(
          onFocusChange: UploaderController.to.titleFieldFocusChanged,
          child: TextField(
            controller: UploaderController.to.titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(l10n.description, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 4),
        Focus(
          onFocusChange: UploaderController.to.descriptionFieldFocusChanged,
          child: TextField(
            controller: UploaderController.to.descriptionController,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(l10n.tags, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 4),
        TextField(
          controller: UploaderController.to.tagsController,
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
          onSubmitted: (_) => UploaderController.to.addTags,
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
        Text(l10n.links, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 4),
        TextField(
          controller: UploaderController.to.linksController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: UploaderController.to.addLink,
                icon: Icon(Icons.add),
              ),
            ),
          ),
          onSubmitted: (_) => UploaderController.to.addLink(),
        ),
        Obx(() {
          if (UploaderController.to.links.isEmpty) {
            return Container();
          }

          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              runSpacing: 8,
              spacing: 8,
              children: UploaderController.to.links
                  .map(
                    (link) => Chip(
                      label: Text(link),
                      shape: StadiumBorder(),
                      onDeleted: () => UploaderController.to.links.remove(link),
                    ),
                  )
                  .toList(),
            ),
          );
        }),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.participants,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextButton.icon(
                onPressed: () async {
                  await launchUrl(Uri.parse('https://npub.world/'));
                },
                label: Text(l10n.npubWorld),
                icon: Icon(Icons.open_in_new),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        TextField(
          controller: UploaderController.to.participantsController,
          decoration: InputDecoration(
            hintText: l10n.npub,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            suffixIcon: Padding(padding: const EdgeInsets.only(right: 4)),
          ),
          onChanged: UploaderController.to.participantFieldChanged,
        ),
        Obx(() {
          if (UploaderController.to.participants.isEmpty) {
            return Container();
          }

          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              runSpacing: 8,
              spacing: 8,
              children: UploaderController.to.participants
                  .map(
                    (participantPubkey) => Chip(
                      avatar: NPicture(
                        ndk: Repository.ndk,
                        pubkey: participantPubkey,
                      ),
                      label: NName(
                        ndk: Repository.ndk,
                        pubkey: participantPubkey,
                      ),
                      shape: StadiumBorder(),
                      onDeleted: () => UploaderController.to.participants
                          .remove(participantPubkey),
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
                l10n.thumbnail,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Obx(() {
              return FilledButton.icon(
                onPressed: UploaderController.to.isPickingThumbnail.value
                    ? null
                    : UploaderController.to.selectThumbnail,
                label: Text(l10n.selectThumbnail),
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
              l10n.firstTimeTheVideoWasPublished,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              DateFormat.yMMMMd().format(
                UploaderController.to.firstTimePublished.value,
              ),
            ),
            trailing: FilledButton.icon(
              onPressed: UploaderController.to.selectFirstTimePublished,
              label: Text(l10n.selectDate),
              icon: Icon(Icons.calendar_month),
            ),
          );
        }),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.shortVideo,
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
            Text(l10n.nsfw, style: Theme.of(context).textTheme.titleMedium),
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
        SizedBox(height: 32),
        Obx(() {
          return FilledButton(
            onPressed: UploaderController.to.uploadState.value == 0
                ? UploaderController.to.upload
                : null,
            child: Text(
              [
                l10n.upload,
                l10n.fetchingYourBlossomsServers,
                l10n.uploadingVideo,
                l10n.uploadingThumbnail,
                l10n.sendingNostrEvent,
                l10n.done,
              ][UploaderController.to.uploadState.value],
            ),
          );
        }),
        SizedBox(height: 8),
        TextButton(
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: Text(l10n.discardChanges),
                content: Text(l10n.yourChangesWillBeLost),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(l10n.back),
                  ),
                  FilledButton(
                    onPressed: () {
                      UploaderController.to.reset();
                      Get.back();
                    },
                    child: Text(l10n.reset),
                  ),
                ],
              ),
            );
          },
          child: Text(l10n.reset),
        ),
        SizedBox(height: 32),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            TextButton(
              onPressed: () async {
                await launchUrl(
                  Uri.parse(
                    'https://nosta.me/npub1kg4sdvz3l4fr99n2jdz2vdxe2mpacva87hkdetv76ywacsfq5leqquw5te',
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.madeWith),
                  SizedBox(width: 8),
                  Icon(Icons.favorite),
                  SizedBox(width: 8),
                  Text(l10n.by),
                  SizedBox(width: 8),
                  NPicture(
                    ndk: Repository.ndk,
                    pubkey:
                        "b22b06b051fd5232966a9344a634d956c3dc33a7f5ecdcad9ed11ddc4120a7f2",
                    circleAvatarRadius: 8,
                  ),
                  SizedBox(width: 8),
                  NName(
                    ndk: Repository.ndk,
                    pubkey:
                        "b22b06b051fd5232966a9344a634d956c3dc33a7f5ecdcad9ed11ddc4120a7f2",
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                await launchUrl(
                  Uri.parse(
                    'https://gitworkshop.dev/npub1kg4sdvz3l4fr99n2jdz2vdxe2mpacva87hkdetv76ywacsfq5leqquw5te/nostr-video-uploader',
                  ),
                );
              },
              label: Text(l10n.viewOnGit),
              icon: SvgPicture.asset(
                'assets/images/git.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.srcIn,
                ),
                height: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
