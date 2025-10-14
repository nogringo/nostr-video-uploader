import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';

void setNumericLocale() {
  if (!Platform.isLinux) return;

  try {
    // In debug mode, load from linux folder. In release, load from lib folder (bundle)
    final libPath = kDebugMode ? 'linux/libset_locale.so' : 'lib/libset_locale.so';
    final lib = DynamicLibrary.open(libPath);

    // Get the setNumericLocaleToC function
    final setNumericLocaleToC = lib.lookupFunction<
        Void Function(),
        void Function()>('setNumericLocaleToC');

    // Call it to set LC_NUMERIC to C
    setNumericLocaleToC();
  } catch (e) {
    // Ignore if setlocale fails - silently continue
  }
}
