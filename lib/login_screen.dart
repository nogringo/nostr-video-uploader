import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/domain_layer/usecases/bunkers/models/nostr_connect.dart';
import 'package:nostr_video_uploader/l10n/app_localizations.dart';
import 'package:nostr_video_uploader/repository.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.login)),
      body: Align(
        alignment: Alignment(0, -0.33),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(right: 12, left: 12, bottom: kToolbarHeight),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: NLogin(
                ndk: Repository.ndk,
                enablePubkeyLogin: false,
                nostrConnect: NostrConnect(
                  appName: AppLocalizations.of(context)!.videoUploader,
                  relays: ['wss://relay.nsec.app', 'wss://offchain.pub'],
                ),
                onLoggedIn: () {
                  Repository.to.update();
                  Get.back();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
