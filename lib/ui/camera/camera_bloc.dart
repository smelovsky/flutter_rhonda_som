import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

import '../../proto/packers/packers_mapper.dart';
import '../../proto/rhsom/still.pbenum.dart';
import 'model/message.dart';


part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  Socket? _socket;
  StreamSubscription? _socketStreamSub;
  ConnectionTask<Socket>? _socketConnectionTask;

  CameraBloc() : super(CameraState.initial()) {

    on<MessageReceived>((event, emit) {
      print("on<MessageReceived> ${event.message.message}");
      emit(state.copyWithNewMessage(message: event.message));
    });

    on<Connect>((event, emit) {
      print("on<Connect> ${event.host}");

      emit(state.copyWithNewMessage(message: MessageCamera(
        message: "connect",
        timestamp: DateTime.now(),
        sender: Sender.Client,
      )));

      _connect(event);
    });

    on<SendMessage>((event, emit) {

      print("on<SendMessage> ${event.message}");

      emit(state.copyWithNewMessage(message: MessageCamera(
        message: event.message,
        timestamp: DateTime.now(),
        sender: Sender.Client,
      )));

      _sendMessage(event);

    });

    on<Disconnect>((event, emit) {
      print("on<Disconnect>");
      _disconnect();

      emit(state.copyWithConnectionState(connectionState: SocketConnectionState.None));
    });

    on<ErrorOccured>((event, emit) {
      print("on<ErrorOccured>");
      _error();
      emit(state.copyWithConnectionState(connectionState: SocketConnectionState.Failed));
    });

  }

  @override
  Future<void> close() {

    print("CLOSE socket");

    _socketStreamSub?.cancel();
    _socket?.close();
    return super.close();
  }

  void onHandleError() {
    print("onHandleError");
  }

  void _sendMessage(SendMessage event) async {

    print("${event.message}");

    if (event.message == 'get state') {
      final typeUrl = "CameraExt.GetState";
      final packersMapper = PackersMapper.map[typeUrl];
      if (packersMapper != null) {
        final cmdBuf = packersMapper.pack(GetStateApp());
        final buf = MessagePacker.pack(typeUrl, cmdBuf);
        Stream<List<int>> stream() async* { yield buf; }
        _socket?.addStream(stream());
      }
    } else if (event.message == 'get video settings') {
      final typeUrl = "CameraExt.Capture.Video.GetSettings";
      final packersMapper = PackersMapper.map[typeUrl];
      if (packersMapper != null) {
        final cmdBuf = packersMapper.pack(GetVideoSettingsApp());
        final buf = MessagePacker.pack(typeUrl, cmdBuf);
        Stream<List<int>> stream() async* { yield buf; }
        _socket?.addStream(stream());
      }
    } else if (event.message == 'stop streaming') {
      final typeUrl = "Camera.Streaming.Stop";
      final packersMapper = PackersMapper.map[typeUrl];
      if (packersMapper != null) {
        final cmdBuf = packersMapper.pack(StreamingStopApp());
        final buf = MessagePacker.pack(typeUrl, cmdBuf);
        Stream<List<int>> stream() async* {
          yield buf;
        }
        _socket?.addStream(stream());
      }
    } else if (event.message == 'start streaming') {
      final typeUrl = "Camera.Streaming.Start";
      final packersMapper = PackersMapper.map[typeUrl];
      if (packersMapper != null) {
        final cmdBuf = packersMapper.pack(StreamingStartApp());
        final buf = MessagePacker.pack(typeUrl, cmdBuf);
        Stream<List<int>> stream() async* {
          yield buf;
        }
        _socket?.addStream(stream());
      }
    } else if (event.message == 'start capture') {
      final typeUrl = "Camera.Capture.Still.CaptureStill";
      final packersMapper = PackersMapper.map[typeUrl];
      if (packersMapper != null) {
        final cmdBuf = packersMapper.pack(CaptureStillApp(mode: CaptureStill_Mode.CAPTURE_SINGLE));
        final buf = MessagePacker.pack(typeUrl, cmdBuf);
        Stream<List<int>> stream() async* {
          yield buf;
        }
        _socket?.addStream(stream());
      }
    } else if (event.message == 'get still settings') {
      final typeUrl = "CameraExt.Capture.Still.GetSettings";
      final packersMapper = PackersMapper.map[typeUrl];
      print("${packersMapper}");
      if (packersMapper != null) {
        final cmdBuf = packersMapper.pack(GetStillSettingsApp());
        final buf = MessagePacker.pack(typeUrl, cmdBuf);
        Stream<List<int>> stream() async* {
          yield buf;
        }
        _socket?.addStream(stream());
      }
    }

    print(" sendMessage DONE");
  }

  void _connect(Connect event) async {

    emit(state.copyWithConnectionState(connectionState: SocketConnectionState.Connecting));

    try {
      _socketConnectionTask = await Socket.startConnect(event.host, event.port);

      _socket = await _socketConnectionTask!.socket.timeout(Duration(seconds: 5));

      _socketStreamSub = _socket!.asBroadcastStream().listen((event) {

        print("event ${event.toString()}");

        var txt = "";

        var buf = event.sublist(8);

        final messageApp = MessagePacker.unpuck(buf);

        if (messageApp != null) {
          if (messageApp.runtimeType == InitialSynApp) {
            txt = "connected";
          } else if (messageApp.runtimeType == GetStateResponseApp) {
            final message = messageApp as  GetStateResponseApp;
            txt = "${message.state}";
          }  else if (messageApp.runtimeType == GetVideoSettingsResponseApp) {
            final message = messageApp as  GetVideoSettingsResponseApp;
            txt = "${message.mode}, ${message.codec}";
          } else if (messageApp.runtimeType == StreamingStopResponseApp) {
            final message = messageApp as StreamingStopResponseApp;
            txt = "${message.ret}";
          } else if (messageApp.runtimeType == StreamingStartResponseApp) {
            final message = messageApp as StreamingStartResponseApp;
            txt = "${message.ret}";
          } else if (messageApp.runtimeType == CaptureStillObjectCompleteApp) {
            final message = messageApp as CaptureStillObjectCompleteApp;
            txt = "${message.name}, ${message.objectType}";
          } else if (messageApp.runtimeType == GetStillSettingsResponseApp) {
            final message = messageApp as GetStillSettingsResponseApp;
            txt = "${message.resolution}, Compression ratio: ${message.compressionRatio}";
          }

          add(
              MessageReceived(
                  message: MessageCamera(
                    message: txt,
                    timestamp: DateTime.now(),
                    sender: Sender.Server,
                  )
              )
          );

        } else {
          print("unsupported buf: ${buf}");
        }


      });

      _socket!.handleError((onHandleError) {
        print("ErrorOccured");
        add(ErrorOccured());
      });

      print("SocketConnectionState.Connected");
      emit(state.copyWithConnectionState(connectionState: SocketConnectionState.Connected));
    } catch (err) {
      if (err.runtimeType == TimeoutException) {
        print("SocketConnectionState.Failed (Timeout) ");
      } else {
        print("SocketConnectionState.Failed (${err.toString()})");
      }

      emit(state.copyWithConnectionState(connectionState: SocketConnectionState.Failed));
    }

  }

  void _disconnect() async {
    try {
      _socketConnectionTask?.cancel();
      await _socketStreamSub?.cancel();
      await _socket?.close();
    } catch (ex) {
    print(ex);
    }
  }

  void _error() async {
    try {
      await _socketStreamSub?.cancel();
      await _socket?.close();
    } catch (ex) {
    print(ex);
    }
  }

}