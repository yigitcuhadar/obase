import 'package:easy_localization/easy_localization.dart';

extension StringLocalizationExtension on String {
  String get locale => this.tr();
  String localeWithArgs(List<String>? args) => this.tr(args: args);
}
