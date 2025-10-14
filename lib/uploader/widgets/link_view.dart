import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LinkView extends StatelessWidget {
  final String title;
  final String url;

  const LinkView({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: SelectableText(url),
      trailing: IconButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: url));
        },
        icon: Icon(Icons.copy),
      ),
    );
  }
}
