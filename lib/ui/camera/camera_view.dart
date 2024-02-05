import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/validators.dart';
import 'camera_bloc.dart';
import 'model/message.dart';


class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraBloc? _tcpBloc;
  TextEditingController? _hostEditingController;
  TextEditingController? _portEditingController;
  TextEditingController? _chatTextEditingController;
  ScrollController?  _scrollController;

  @override
  void dispose(){

    _hostEditingController?.dispose();
    _portEditingController?.dispose();
     _chatTextEditingController?.dispose();
    _scrollController?.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tcpBloc =  BlocProvider.of<CameraBloc>(context);

    _hostEditingController = TextEditingController(text: '192.168.42.1');
    _portEditingController = TextEditingController(text: '2020');
    _scrollController = ScrollController(initialScrollOffset: 0);

  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CameraBloc, CameraState>(
        bloc: _tcpBloc,
        listener: (BuildContext context, CameraState tcpState) {
          if (tcpState.connectionState == SocketConnectionState.Connected) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar();
          } else if (tcpState.connectionState == SocketConnectionState.Failed) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Connection failed"), Icon(Icons.error)],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (context, tcpState) {

          if (tcpState.connectionState == SocketConnectionState.None || tcpState.connectionState == SocketConnectionState.Failed) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              child: ListView(
                children: [
                  TextFormField(
                    controller: _hostEditingController,
                    autovalidateMode : AutovalidateMode.always,
                    validator: (str) => isValidHost(str) ? null : 'Invalid hostname',
                    decoration: InputDecoration(
                      helperText: 'The ip address or hostname of the TCP server',
                      hintText: 'Enter the address here, e. g. 10.0.2.2',
                    ),
                  ),
                  TextFormField(
                    controller: _portEditingController,
                    autovalidateMode : AutovalidateMode.always,
                    validator: (str) => isValidPort(str) ? null : 'Invalid port',
                    decoration: InputDecoration(
                      helperText: 'The port the TCP server is listening on',
                      hintText: 'Enter the port here, e. g. 8000',
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Connect'),
                    onPressed: isValidHost(_hostEditingController!.text) && isValidPort(_portEditingController!.text)
                        ? () {
                      _tcpBloc!.add(
                          Connect(
                              host: _hostEditingController!.text,
                              port: int.parse(_portEditingController!.text)
                          )
                      );
                    }
                        : null,
                  )
                ],
              ),
            );
          } else if (tcpState.connectionState == SocketConnectionState.Connecting) {
            return Center(
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text('Connecting...'),
                  ElevatedButton(
                    child: Text('Abort'),
                    onPressed: () {
                      _tcpBloc!.add(Disconnect());
                    },
                  )
                ],
              ),
            );
          } else if (tcpState.connectionState == SocketConnectionState.Connected) {

            if (_scrollController!.hasClients) {
              double? maxScroll = _scrollController?.position.maxScrollExtent;
              final pos = 200  + maxScroll!; // TODO remove hard code '200'
              _scrollController?.jumpTo(pos);
            }

            return Column(
              children: [
                Expanded(
                  child: Container(
                    child: ListView.builder(
                        itemCount: tcpState.messages.length,
                        controller: _scrollController,
                        reverse: false,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, idx) {
                          MessageCamera m = tcpState.messages[idx];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Bubble(
                              child: Text(m.message),
                              alignment: m.sender == Sender.Client ? Alignment.centerRight : Alignment.centerLeft,
                            ),
                          );


                        }
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      ElevatedButton(
                        child: Text('Video settings'),
                        onPressed: () {
                          _tcpBloc!.add(SendMessage(message:'get video settings'));
                        },
                      ),
                      ElevatedButton(
                        child: Text('Still settingss'),
                        onPressed: () {
                          _tcpBloc!.add(SendMessage(message:'get still settings'));
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text('Start streaming'),
                        onPressed: () {
                          _tcpBloc!.add(SendMessage(message:'start streaming'));
                        },
                      ),
                      ElevatedButton(
                        child: Text('Stop streaming'),
                        onPressed: () {
                          _tcpBloc!.add(SendMessage(message:'stop streaming'));
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text('Get state'),
                        onPressed: () {
                          _tcpBloc!.add(SendMessage(message:'get state'));
                        },
                      ),
                      ElevatedButton(
                        child: Text('Still Capture'),
                        onPressed: () {
                          _tcpBloc!.add(SendMessage(message:'start capture'));
                        },
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: Text('Disconnect'),
                  onPressed: () {
                    _tcpBloc!.add(Disconnect());
                  },
                ),
              ],
            );

          } else {
            return Container();
          }
        },
      );
    //);
  }
}