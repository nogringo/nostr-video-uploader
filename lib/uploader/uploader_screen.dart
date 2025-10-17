import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nostr_video_uploader/l10n/app_localizations.dart';
import 'package:nostr_video_uploader/login_screen.dart';
import 'package:nostr_video_uploader/repository.dart';
import 'package:nostr_video_uploader/uploader/layouts/large_layout.dart';
import 'package:nostr_video_uploader/uploader/layouts/small_layout.dart';
import 'package:nostr_video_uploader/uploader/uploader_controller.dart';
import 'package:nostr_video_uploader/uploader/widgets/links_view.dart';

class UploaderScreen extends StatelessWidget {
  const UploaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Repository>(
      builder: (c) {
        if (Repository.ndk.accounts.accounts.isEmpty) {
          return LoginScreen();
        }

        Get.put(UploaderController());

        return Obx(() {
          if (UploaderController.to.nevent.value != null) {
            return LinksView();
          }

          if (UploaderController.to.videoMetadata.value == null) {
            return Scaffold(
              body: Center(
                child: SizedBox(
                  width: 400,
                  child: FilledButton(
                    onPressed: UploaderController.to.isPickingVideo.value
                        ? null
                        : UploaderController.to.selectVideo,
                    child: Text(AppLocalizations.of(context)!.selectVideo),
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                final isLarge = constraints.maxWidth > 600;
                if (isLarge) return LargeLayout();
                return SmallLayout();
              },
            ),
          );
        });
      },
    );
  }
}
