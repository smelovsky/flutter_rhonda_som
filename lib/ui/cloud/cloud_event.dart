part of 'cloud_bloc.dart';

@immutable
abstract class CloudEvent {}

class LoginCloudEvent extends CloudEvent {

  final String host;
  final String email;
  final String password;

  LoginCloudEvent ({required this.host, required this.email, required this.password})
      : assert(host != null), assert(email != null), assert(password != null);

  @override
  String toString() => 'LoginCloudEvent { }';
}

class ConnectTestCloudEvent extends CloudEvent {

  String host;

  ConnectTestCloudEvent ({required this.host});

  @override
  String toString() => 'TestCloudEvent { }';
}

class AbortTestCloudEvent extends CloudEvent {
  @override
  String toString() => 'AbortCloudEvent { }';
}
