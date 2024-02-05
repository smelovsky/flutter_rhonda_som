part of 'camera_bloc.dart';

enum SocketConnectionState {
  Connecting,
  Disconnecting,
  Connected,
  Failed,
  None
}

@immutable
class CameraState {
  final SocketConnectionState connectionState;
  final List<MessageCamera> messages;

  CameraState({
    required this.connectionState,
    required this.messages,
  });

  factory CameraState.initial() {
    return CameraState(
        connectionState: SocketConnectionState.None,
        messages: <MessageCamera>[],
    );
  }

  CameraState copyWithConnectionState({
    required SocketConnectionState connectionState,
    List<MessageCamera>? messages,
  }) {
    return CameraState(
      connectionState: connectionState,
      messages: this.messages,
    );
  }

  CameraState copyWithNewMessage({required MessageCamera message}) {
    return CameraState(
      connectionState: this.connectionState,
      messages: List.from(this.messages)..add(message),
    );
  }
}