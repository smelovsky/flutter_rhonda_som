
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class PlayerPage extends StatefulWidget {
  String dataSource = "";

  PlayerPage(this.dataSource,{super.key});

  @override
  _PlayerPageState createState() => _PlayerPageState(dataSource);
}

class _PlayerPageState extends State<PlayerPage> {
  String dataSource = "";

  _PlayerPageState(this.dataSource);

  late VlcPlayerController _videoPlayerController;

  Future<void> initializePlayer() async {}

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VlcPlayerController.network(
      dataSource,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 0, left: 1, right: 1),
        child: Align(
            alignment: Alignment.topCenter,
            child: Column(
                children: <Widget>[

                  VlcPlayer(
                    controller: _videoPlayerController,
                    aspectRatio: 16 / 9,
                    placeholder: Center(child: CircularProgressIndicator()),
                  ),

                  Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 0, left: 0, right: 0),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                ElevatedButton.icon(
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Play'),
                                  onPressed: () {
                                    _videoPlayerController.play();
                                  },
                                ),

                                ElevatedButton.icon(
                                    icon: const Icon(Icons.pause),
                                    label: const Text('Pause'),
                                    onPressed: () async {
                                      _videoPlayerController.pause();
                                    }
                                ),

                                ElevatedButton.icon(
                                    icon: const Icon(Icons.stop),
                                    label: const Text('Stop'),
                                    onPressed: () async {
                                      _videoPlayerController.stop();
                                    }
                                ),

                              ]
                          )
                      )
                  ),

                ]
            )
        )
    );
  }
}
