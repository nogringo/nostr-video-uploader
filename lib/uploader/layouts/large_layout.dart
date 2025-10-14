import 'package:flutter/material.dart';
import 'package:nostr_video_uploader/uploader/widgets/accounts_view.dart';
import 'package:nostr_video_uploader/uploader/widgets/video_details_view.dart';

class LargeLayout extends StatelessWidget {
  const LargeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, -0.33),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: kToolbarHeight),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountsView(direction: Axis.vertical),
                SizedBox(width: 16),
                Expanded(child: VideoDetailsView()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
