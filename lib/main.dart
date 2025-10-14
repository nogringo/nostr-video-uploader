import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_video_uploader/repository.dart';
import 'package:nostr_video_uploader/uploader/uploader_screen.dart';
import 'package:nostr_video_uploader/utils/set_locale.dart';
import 'package:nostr_widgets/functions/functions.dart';
import 'package:nostr_widgets/l10n/app_localizations.dart' as nostr_widgets;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setNumericLocale(); // Fix locale warning for media_kit
  MediaKit.ensureInitialized();

  final ndk = Ndk.defaultConfig();
  await nRestoreAccounts(ndk);

  Get.put(ndk);
  Get.put(Repository());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [nostr_widgets.AppLocalizations.delegate],
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: UploaderScreen(),
    );
  }
}
