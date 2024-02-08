import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends ChangeNotifier {
  bool  isTestMode = false;
  String dataSourceTest = 'https://media.w3.org/2010/05/sintel/trailer.mp4';
  String dataSourceRhondaSom = 'rtmp://192.168.42.1:1935/v4l2/video0';
}

final settingsProvider =
ChangeNotifierProvider<SettingsNotifier>((ref) {
  return SettingsNotifier();
});