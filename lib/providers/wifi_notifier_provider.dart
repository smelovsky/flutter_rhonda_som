import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WiFiNotifier extends ChangeNotifier {

}

final wifiProvider =
ChangeNotifierProvider<WiFiNotifier>((ref) {
  return WiFiNotifier();
});


