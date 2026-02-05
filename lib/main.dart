import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:ndk/ndk.dart';
import 'package:ndk_flutter/ndk_flutter.dart';
import 'package:nostr_video_uploader/l10n/app_localizations.dart';
import 'package:nostr_video_uploader/repository.dart';
import 'package:nostr_video_uploader/uploader/uploader_screen.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ndk_flutter/l10n/app_localizations.dart' as ndk_flutter;

// TODO add drag and drop
// TODO add optional relay
// TODO add client tag
// TODO later add more warning
// TODO add a cache

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  if (!kIsWeb && GetPlatform.isDesktop) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions);
  }

  final ndk = Ndk.defaultConfig();
  final ndkFlutter = NdkFlutter(ndk: ndk);
  await ndkFlutter.restoreAccountsState();

  Get.put(ndk);
  Get.put(ndkFlutter);
  Get.put(Repository());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)!.nostVideoUploader,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ndk_flutter.AppLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: UploaderScreen(),
      builder: (context, child) {
        if (!kIsWeb && GetPlatform.isDesktop) {
          return DragToResizeArea(
            child: Stack(
              children: [
                child!,
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 32,
                    child: Row(
                      children: [
                        Expanded(child: DragToMoveArea(child: Container())),
                        SizedBox(
                          width: 154,
                          child: WindowCaption(
                            brightness: Theme.of(context).brightness,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return child!;
      },
    );
  }
}
