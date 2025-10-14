// Conditional export: use native implementation on native platforms, stub on web
export 'set_locale_native.dart' if (dart.library.html) 'set_locale_stub.dart';
