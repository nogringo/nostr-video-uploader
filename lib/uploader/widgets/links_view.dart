import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nostr_video_uploader/uploader/uploader_controller.dart';
import 'package:nostr_video_uploader/uploader/widgets/link_view.dart';

class LinksView extends StatelessWidget {
  const LinksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sharing Links"),
        actions: [
          FilledButton(
            onPressed: UploaderController.to.reset,
            child: Text("New upload"),
          ),
          SizedBox(width: 12),
          if (!kIsWeb && GetPlatform.isDesktop) SizedBox(width: 154),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LinkView(
              title: "Nevent",
              url: "nostr:${UploaderController.to.nevent.value}",
            ),
            LinkView(
              title: "Njump",
              url: "https://njump.me/${UploaderController.to.nevent.value}",
            ),
            LinkView(
              title: "Yakihonne",
              url:
                  "https://yakihonne.com/video/${UploaderController.to.nevent.value}",
            ),
            LinkView(
              title: "Plebs",
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
