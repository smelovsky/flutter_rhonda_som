import '../rhsom/core.pb.dart';
import '../rhsom/notify.pb.dart';
import '../rhsom/state.pb.dart';
import '../rhsom/still.pb.dart';
import '../rhsom/streaming.pb.dart' as streaming;
import '../rhsom/video_ext.pb.dart'  as video_ext;
import '../rhsom/still_ext.pb.dart'  as still_ext;
import '../rhsom/still.pb.dart' as still;

abstract class PayloadPacker {
  String typeUrl = "";
  MessageApp unpack(List<int> data);
  List<int> pack(MessageApp message);
}

class PackersMapper {

  static final packers = [
    PayloadPacker,
  ];

  static Map<String, PayloadPacker> map = {
    InitialSynPacker().typeUrl: InitialSynPacker(),
    GetStatePacker().typeUrl: GetStatePacker(),
    GetStateResponsePacker().typeUrl: GetStateResponsePacker(),
    GetVideoSettingsPacker().typeUrl: GetVideoSettingsPacker(),
    GetVideoSettingsResponsePacker().typeUrl: GetVideoSettingsResponsePacker(),
    StreamingStopPacker().typeUrl: StreamingStopPacker(),
    StreamingStopResponsePacker().typeUrl: StreamingStopResponsePacker(),
    StreamingStartPacker().typeUrl: StreamingStartPacker(),
    StreamingStartResponsePacker().typeUrl: StreamingStartResponsePacker(),
    CaptureStillPacker().typeUrl: CaptureStillPacker(),
    CaptureStillObjectCompletePacker().typeUrl: CaptureStillObjectCompletePacker(),
    GetStillSettingsPacker().typeUrl: GetStillSettingsPacker(),
    GetStillSettingsResponsePacker().typeUrl: GetStillSettingsResponsePacker(),

  };

}

////////////////////////////////////////////////////////////////////////////////

class MessagePacker {

  static List<int> pack(String typeUrl, List<int> cmdBuf) {

    Message message = Message(
      destinationId: 0,
      messageId: 0,
      //userData: [0],
      typeUrl: typeUrl,
      sourceId: 0,
    );

    List<int> buf = message.writeToBuffer();
    buf[buf.length-2] = 0x2a; // '*'

    List<int> header = [0xCC, 0xCC, 0xCC, 0xCC, 0x00, 0x00, 0x00, buf.length];
    buf = header + buf;

    //print("buf <${buf.length}>: ${buf}");

    String hexBuf = "";
    buf.forEach((element) {
      String hexString = element.toRadixString(16);
       hexBuf += "${hexString}, ";
    });

    print("${hexBuf}");

    return buf;
  }

  static MessageApp? unpuck(List<int> buf) {

    Message message = Message.fromBuffer(buf);

    MessageApp? messageApp = null;

    print("${message.typeUrl}");

    final packer = PackersMapper.map[message.typeUrl];

    print("packer: ${packer}");

    if (packer != null) {
      print("typeUrl: ${packer.typeUrl}");
      messageApp = packer.unpack(message.data);
    }

    return messageApp;
  }

}

////////////////////////////////////////////////////////////////////////////////

class InitialSynPacker extends PayloadPacker {

  InitialSynPacker(){
    super.typeUrl = "Camera.General.Notify.InitialSync";
  }

  @override
  InitialSynApp unpack(List<int> data) {

    InitialSync proto = InitialSync.fromBuffer(data);

    return InitialSynApp(
        protocolVersionMajor: proto.protocolVersionMajor,
        protocolVersionMinor: proto.protocolVersionMinor,
    );
  }

  @override
  List<int> pack(MessageApp message) {

    List<int> buf = [];

    return buf;
  }

}

class GetStatePacker extends PayloadPacker {

  GetStatePacker(){
    super.typeUrl = "CameraExt.GetState";
  }

  @override
  GetStateApp unpack(List<int> data) {
    return GetStateApp();
  }

  @override
  List<int> pack(MessageApp message) {

    GetStateApp msg = message as GetStateApp;

    List<int> buf = GetState().writeToBuffer();
    return buf;
  }

}

class GetStateResponsePacker extends PayloadPacker {

  GetStateResponsePacker(){
    super.typeUrl = "CameraExt.GetState.Response";
  }

  @override
  GetStateResponseApp unpack(List<int> data) {

    GetState_Response proto = GetState_Response.fromBuffer(data);

    return GetStateResponseApp(
      //status: proto.ret,
      state: proto.state,
      recorderActive: proto.recorderActive,
      streamActive: proto.streamActive,
      uvcActive: proto.uvcActive,
    );
  }

  @override
  List<int> pack(MessageApp message) {
    List<int> buf = [];
    return buf;
  }

}

class GetVideoSettingsPacker extends PayloadPacker {

  GetVideoSettingsPacker(){
    super.typeUrl = "CameraExt.Capture.Video.GetSettings";
  }

  @override
  GetVideoSettingsApp unpack(List<int> data) {
    return GetVideoSettingsApp();
  }

  @override
  List<int> pack(MessageApp message) {

    GetVideoSettingsApp msg = message as GetVideoSettingsApp;

    List<int> buf = video_ext.GetSettings().writeToBuffer();
    return buf;
  }

}

class GetVideoSettingsResponsePacker extends PayloadPacker {

  GetVideoSettingsResponsePacker(){
    super.typeUrl = "CameraExt.Capture.Video.GetSettings.Response";
  }

  @override
  GetVideoSettingsResponseApp unpack(List<int> data) {

    video_ext.GetSettings_Response proto = video_ext.GetSettings_Response.fromBuffer(data);

    return GetVideoSettingsResponseApp(
        ret: proto.ret,
        mode: proto.config.mode,
        codec: proto.config.codec,
        bitrate: proto.config.bitrate,
    );
  }

  @override
  List<int> pack(MessageApp message) {
    List<int> buf = [];
    return buf;
  }

}

class GetStillSettingsPacker extends PayloadPacker {

  GetStillSettingsPacker(){
    super.typeUrl = "CameraExt.Capture.Still.GetSettings";
  }

  @override
  GetStillSettingsApp unpack(List<int> data) {
    return GetStillSettingsApp();
  }

  @override
  List<int> pack(MessageApp message) {

    GetStillSettingsApp msg = message as GetStillSettingsApp;

    List<int> buf = still_ext.GetSettings().writeToBuffer();
    return buf;
  }

}

class GetStillSettingsResponsePacker extends PayloadPacker {

  GetStillSettingsResponsePacker(){
    super.typeUrl = "CameraExt.Capture.Still.GetSettings.Response";
  }

  @override
  GetStillSettingsResponseApp unpack(List<int> data) {

    still_ext.GetSettings_Response proto = still_ext.GetSettings_Response.fromBuffer(data);


    return GetStillSettingsResponseApp(
      ret: proto.ret,
      resolution: proto.config.resolution,
      compressionRatio: proto.config.compressionRatio,
    );
  }

  @override
  List<int> pack(MessageApp message) {
    List<int> buf = [];
    return buf;
  }

}

class StreamingStopPacker extends PayloadPacker {

  StreamingStopPacker(){
    super.typeUrl = "Camera.Streaming.Stop";
  }

  @override
  StreamingStopApp unpack(List<int> data) {
    return StreamingStopApp();
  }

  @override
  List<int> pack(MessageApp message) {
    StreamingStopApp msg = message as StreamingStopApp;
    List<int> buf = [];
    return buf;
  }

}

class StreamingStopResponsePacker extends PayloadPacker {

  StreamingStopResponsePacker(){
    super.typeUrl = "Camera.Streaming.Stop.Response";
  }

  @override
  StreamingStopResponseApp unpack(List<int> data) {
    streaming.Stop_Response proto = streaming.Stop_Response.fromBuffer(data);
    return StreamingStopResponseApp(
      ret: proto.ret,
    );
  }

  @override
  List<int> pack(MessageApp message) {
    StreamingStopResponseApp msg = message as StreamingStopResponseApp;
    List<int> buf = [];
    return buf;
  }

}

class StreamingStartPacker extends PayloadPacker {

  StreamingStartPacker(){
    super.typeUrl = "Camera.Streaming.Start";
  }

  @override
  StreamingStartApp unpack(List<int> data) {
    return StreamingStartApp();
  }

  @override
  List<int> pack(MessageApp message) {
    StreamingStartApp msg = message as StreamingStartApp;
    List<int> buf = [];
    return buf;
  }

}

class StreamingStartResponsePacker extends PayloadPacker {

  StreamingStartResponsePacker(){
    super.typeUrl = "Camera.Streaming.Start.Response";
  }

  @override
  StreamingStartResponseApp unpack(List<int> data) {
    streaming.Start_Response proto = streaming.Start_Response.fromBuffer(data);
    return StreamingStartResponseApp(
      ret: proto.ret,
    );
  }

  @override
  List<int> pack(MessageApp message) {
    StreamingStartResponseApp msg = message as StreamingStartResponseApp;
    List<int> buf = [];
    return buf;
  }

}

class CaptureStillPacker extends PayloadPacker {

  CaptureStillPacker(){
    super.typeUrl = "Camera.Capture.Still.CaptureStill";
  }

  @override
  CaptureStillApp unpack(List<int> data) {
    still.CaptureStill proto = still.CaptureStill.fromBuffer(data);

    return CaptureStillApp(
      mode: proto.mode,
    );
  }

  @override
  List<int> pack(MessageApp message) {
    CaptureStillApp msg = message as CaptureStillApp;

    List<int> buf = still.CaptureStill(mode: msg.mode).writeToBuffer();

    return buf;
  }

}

class CaptureStillObjectCompletePacker extends PayloadPacker {

  CaptureStillObjectCompletePacker(){
    super.typeUrl = "Camera.Capture.Still.ObjectComplete";
  }

  @override
  CaptureStillObjectCompleteApp unpack(List<int> data) {

    ObjectComplete proto = ObjectComplete.fromBuffer(data);

    return CaptureStillObjectCompleteApp(
      objectType: proto.dcfObject.objectType,
      name: proto.dcfObject.name,

    );
  }

  @override
  List<int> pack(MessageApp message) {
    List<int> buf = [];
    return buf;
  }

}

////////////////////////////////////////////////////////////////////////////////

abstract class MessageApp {
}

class InitialSynApp extends MessageApp {
  int protocolVersionMajor = 0;
  int protocolVersionMinor = 0;

  InitialSynApp({required this.protocolVersionMajor, required this.protocolVersionMinor}) {}
}

class GetStateApp extends MessageApp {}

class GetStateResponseApp extends MessageApp {
  //ErrorCode status = ErrorCode.STATUS_SUCCESS;
  State state = State.STATE_IDLE;
  bool recorderActive = false;
  bool streamActive = false;
  bool uvcActive = false;
  GetStateResponseApp({
    //required this.status,
    required this.state,
    required this.recorderActive,
    required this.streamActive,
    required this.uvcActive,
  }) {}
}

class GetVideoSettingsApp extends MessageApp {}

class GetVideoSettingsResponseApp extends MessageApp {
  video_ext.ErrorCode ret = video_ext.ErrorCode.STATUS_UNKNOWN_ERROR;
  video_ext.Mode mode = video_ext.Mode.MODE_4KP30;
  video_ext.Codec codec = video_ext.Codec.H264;
  int bitrate = 0;

  GetVideoSettingsResponseApp({
    required this.ret,
    required this.mode,
    required this.codec,
    required this.bitrate,
  }) {}
}

class StreamingStopApp extends MessageApp {}

class StreamingStopResponseApp extends MessageApp {
  streaming.ErrorCode ret = streaming.ErrorCode.STATUS_UNKNOWN_ERROR;
  StreamingStopResponseApp({
    required this.ret,
  }) {}
}

class StreamingStartApp extends MessageApp {}

class StreamingStartResponseApp extends MessageApp {
  streaming.ErrorCode ret = streaming.ErrorCode.STATUS_UNKNOWN_ERROR;
  StreamingStartResponseApp({
    required this.ret,
  }) {}
}

class CaptureStillApp extends MessageApp {
  still.CaptureStill_Mode mode = still.CaptureStill_Mode.CAPTURE_SINGLE;

  CaptureStillApp({
    required this.mode,
  }) {}
}

class CaptureStillObjectCompleteApp extends MessageApp {
  ObjectInfo_ObjectType objectType = ObjectInfo_ObjectType.OBJECT_TYPE_UNKNOWN;
  String name = "";

  CaptureStillObjectCompleteApp({
    required this.objectType,
    required this.name,

  }) {}
}

class GetStillSettingsApp extends MessageApp {}

class GetStillSettingsResponseApp extends MessageApp {
  still_ext.ErrorCode ret = still_ext.ErrorCode.STATUS_UNKNOWN_ERROR;
  still_ext.Resolution resolution = still_ext.Resolution.RESOLUTION_12MP;
  int compressionRatio = 0;

  GetStillSettingsResponseApp({
    required this.ret,
    required this.resolution,
    required this.compressionRatio,

  }) {}
}