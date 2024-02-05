import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_notifier_provider.dart';
import '../about/about_screen.dart';
import '../camera/camera_view.dart';
import '../player/player_view.dart';
import '../settings/settings_screen.dart';
import '../wifi/wifi_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 5, vsync: this);
  }
  @override
  Widget build(BuildContext context) {

    String dataSource = (ref.watch(settingsProvider).isTestMode) ?
    'https://media.w3.org/2010/05/sintel/trailer.mp4'
        :
    'rtmp://192.168.42.1:1935/v4l2/video0';

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Rhonda SoM App"),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => exit(0)
                ),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(
                //icon: Icon(Icons.wifi),
                text: "WiFi",
              ),
              Tab(
                //icon: Icon(Icons.camera),
                text: "Camera",
              ),
              Tab(
                //icon: Icon(Icons.video_call),
                text: "Player",
              ),
              Tab(
                //icon: Icon(Icons.settings),
                text: "Settings",
              ),
              Tab(
                //icon: Icon(Icons.info),
                text: "About",
              ),

            ],
          ),

        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            WifiView(),
            CameraView(),
            PlayerPage(dataSource),
            SettingsScreen(ref),
            AboutScreen(),

          ],
        )
    );

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}




