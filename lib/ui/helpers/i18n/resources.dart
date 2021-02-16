import 'package:flutter/widgets.dart';

import 'strings/strings.dart';

// ignore: avoid_classes_with_only_static_members
class R {
  static Translations string = PtBr();

  static void load(Locale locale) {
    switch (locale.toString()) {
      case 'en_US':
        string = EnUs();
        break;

      default:
        string = PtBr();
        break;
    }
  }
}
