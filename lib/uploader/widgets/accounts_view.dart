import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nostr_video_uploader/login_screen.dart';
import 'package:nostr_video_uploader/repository.dart';
import 'package:nostr_video_uploader/uploader/uploader_controller.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

class AccountsView extends StatelessWidget {
  final Axis direction;

  const AccountsView({super.key, required this.direction});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Flex(
        direction: direction,
        spacing: 8,
        children: [
          NPicture(ndk: Repository.ndk),

          if (UploaderController.to.isAccountsExpanded.value)
            ...Repository.ndk.accounts.accounts.values
                .where(
                  (account) =>
                      account.pubkey != Repository.ndk.accounts.getPublicKey(),
                )
                .map((account) {
                  if (Repository.ndk.accounts.getPublicKey() ==
                      account.pubkey) {
                    return Container();
                  }

                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Repository.ndk.accounts.switchAccount(
                          pubkey: account.pubkey,
                        );
                        Repository.to.update();
                        UploaderController.to.isAccountsExpanded.value = false;
                      },
                      child: NPicture(
                        ndk: Repository.ndk,
                        pubkey: account.pubkey,
                      ),
                    ),
                  );
                }),

          if (UploaderController.to.isAccountsExpanded.value)
            IconButton(
              onPressed: () {
                Get.to(() => LoginScreen());
              },
              icon: Icon(Icons.add),
            ),

          IconButton(
            onPressed: () {
              UploaderController.to.isAccountsExpanded.value =
                  !UploaderController.to.isAccountsExpanded.value;
            },
            icon: Builder(
              builder: (context) {
                if (direction == Axis.vertical) {
                  return Icon(
                    UploaderController.to.isAccountsExpanded.value
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                  );
                }

                return Icon(
                  UploaderController.to.isAccountsExpanded.value
                      ? Icons.keyboard_arrow_left_rounded
                      : Icons.keyboard_arrow_right_rounded,
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
