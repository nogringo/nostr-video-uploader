import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_video_uploader/repository.dart';
import 'package:nostr_video_uploader/uploader/uploader_screen.dart';
import 'package:nostr_widgets/functions/functions.dart';
import 'package:nostr_widgets/l10n/app_localizations.dart' as nostr_widgets;
import 'package:window_manager/window_manager.dart';

// TODO add participants support
// TODO add reference links support
// TODO add more warning

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
