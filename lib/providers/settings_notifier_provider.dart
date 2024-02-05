import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends ChangeNotifier {
  bool  isTestMode = true;
}

final settingsProvider =
ChangeNotifierProvider<SettingsNotifier>((ref) {
  return SettingsNotifier();
});