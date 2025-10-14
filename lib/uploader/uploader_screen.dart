import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nostr_video_uploader/login_screen.dart';
import 'package:nostr_video_uploader/repository.dart';
import 'package:nostr_video_uploader/uploader/layouts/large_layout.dart';
import 'package:nostr_video_uploader/uploader/layouts/small_layout.dart';
import 'package:nostr_video_uploader/uploader/uploader_controller.dart';

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
          if (UploaderController.to.video.value == null) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SizedBox(
                  width: 400,
                  child: FilledButton(
                    onPressed: UploaderController.to.isPickingVideo.value
                        ? null
                        : UploaderController.to.selectVideo,
                    child: Text("Select Video"),
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(),
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
