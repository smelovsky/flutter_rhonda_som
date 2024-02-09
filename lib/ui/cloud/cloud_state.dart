part of 'cloud_bloc.dart';

enum CloudViewState {
  initial,
  success,
  inprogress,
  aborted,
  failed,
}

@immutable
class CloudState {
  final CloudViewState viewState;
  final String result;


  CloudState({
    required this.viewState,
    required this.result,
  });

  factory CloudState.initial() {
    return CloudState(
      viewState: CloudViewState.initial,
      result: "",
    );
  }

  CloudState copyWithState({
    required CloudViewState viewState,
  }) {
    return CloudState(
      viewState: viewState,
      result: this.result,
    );
  }

  CloudState copyWithStateAndResult({
    required CloudViewState viewState,
    required String result,
  }) {
    return CloudState(
      viewState: viewState,
      result: result,
    );
  }

}