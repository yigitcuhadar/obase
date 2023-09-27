import 'package:flutter/material.dart';

// flutter pub run easy_localization:generate -O lib/core/lang -f keys -o locale_keys.g.dart --source-dir ./assets/lang
class LangManager {
  LangManager._init();
  static LangManager? _instance;
  static LangManager get instance {
    _instance ??= LangManager._init();
    return _instance!;
  }

  Locale enLocale = const Locale('en');
  Locale trLocale = const Locale('tr');

  List<Locale> get supportedLocales => [enLocale, trLocale];
  Locale get fallbackLocale => enLocale;
}
