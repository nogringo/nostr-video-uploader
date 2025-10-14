import 'package:flutter/material.dart';
import 'package:nostr_video_uploader/uploader/widgets/accounts_view.dart';
import 'package:nostr_video_uploader/uploader/widgets/video_details_view.dart';

class SmallLayout extends StatelessWidget {
  const SmallLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: kToolbarHeight),
      children: [
        AccountsView(direction: Axis.horizontal),
        SizedBox(height: 16),
        VideoDetailsView(),
      ],
    );
  }
}
