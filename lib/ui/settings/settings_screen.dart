import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_notifier_provider.dart';
import 'app_settings.dart';


class SettingsScreen extends StatelessWidget {
  final WidgetRef ref;

  SettingsScreen(this.ref, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    String dataSource = (ref.watch(settingsProvider).isTestMode) ?
    ref.read(settingsProvider).dataSourceTest :
    ref.read(settingsProvider).dataSourceRhondaSom;

    String restUrl = (ref.watch(settingsProvider).isCloudTestMode) ?
    ref.read(settingsProvider).restUrlTest :
    ref.read(settingsProvider).restUrlRhondaCloud;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
        child: Column(
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
            Flexible(
              child:Text(dataSource),
            ),

            ListTile(
              title: const Text('Cloud test mode'),
              trailing: CupertinoSwitch(
                value: ref.watch(settingsProvider).isCloudTestMode,
                onChanged: (value) {
                  ref.refresh(settingsProvider).isCloudTestMode = value;
                },
              ),
            ),
            Flexible(
              child:Text(restUrl),
            ),
          ],
        )
    );

  }
}
