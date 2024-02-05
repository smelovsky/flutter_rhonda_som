import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_notifier_provider.dart';
import 'app_settings.dart';


class SettingsScreen extends StatelessWidget {
  WidgetRef ref;

  SettingsScreen(this.ref, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListTile(
            title: const Text('Dark theme'),
            trailing: CupertinoSwitch(
              value: isDark,
              onChanged: (value) {
                AppSettings.themeIsLight.value = !value;
              },
            ),
          ),
          ListTile(
            title: const Text('Player test mode'),
            trailing: CupertinoSwitch(
              value: ref.watch(settingsProvider).isTestMode,
              onChanged: (value) {
                ref.refresh(settingsProvider).isTestMode = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
