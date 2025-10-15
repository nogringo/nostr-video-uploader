import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nostr_video_uploader/l10n/app_localizations.dart';
import 'package:nostr_video_uploader/uploader/uploader_controller.dart';
import 'package:nostr_video_uploader/uploader/widgets/link_view.dart';

class LinksView extends StatelessWidget {
  const LinksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sharingLinks),
        actions: [
          FilledButton(
            onPressed: UploaderController.to.reset,
            child: Text(AppLocalizations.of(context)!.newUpload),
          ),
          SizedBox(width: 12),
          if (!kIsWeb && GetPlatform.isDesktop) SizedBox(width: 154),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LinkView(
              title: AppLocalizations.of(context)!.nevent,
              url: "nostr:${UploaderController.to.nevent.value}",
            ),
            LinkView(
              title: AppLocalizations.of(context)!.njump,
              url: "https://njump.me/${UploaderController.to.nevent.value}",
            ),
            LinkView(
              title: AppLocalizations.of(context)!.yakihonne,
              url:
                  "https://yakihonne.com/video/${UploaderController.to.nevent.value}",
            ),
            LinkView(
              title: AppLocalizations.of(context)!.plebs,
              url:
                  "https://plebs.app/#/video/${UploaderController.to.rawNevent!.eventId}",
            ),
            SizedBox(height: kToolbarHeight),
          ],
        ),
      ),
    );
  }
}
