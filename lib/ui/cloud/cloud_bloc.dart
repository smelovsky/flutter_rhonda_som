import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../retrofit/example.dart';

part 'cloud_event.dart';
part 'cloud_state.dart';

class CloudBloc extends Bloc<CloudEvent, CloudState> {

  late List<Task> listTask;
  var dio = Dio();

  CloudBloc() : super(CloudState.initial()) {

    on<ConnectTestCloudEvent>((event, emit) async {

      emit(state.copyWithStateAndResult(
        viewState: CloudViewState.inprogress,
        result: "",
      ));

      if (await _test(event.host)) {

        String str = "";
        listTask.forEach((element) {
          str += "${element.name}, ";
        });

        if (str.length > 500) {
          str = str.substring(0, 500) + "..." ;
        }

        print("on<TestCloudEvent> DONE");

        emit(state.copyWithState(viewState: CloudViewState.success));

        emit(state.copyWithStateAndResult(
          viewState: CloudViewState.success,
          result: str,
        ));

      } else {
        print("on<TestCloudEvent> ERROR (${state.viewState})");

        if (state.viewState != CloudViewState.aborted) {
          emit(state.copyWithState(viewState: CloudViewState.failed));
        }

      }
    });
    on<AbortTestCloudEvent>((event, emit) {
      emit(state.copyWithState(viewState: CloudViewState.aborted));
      dio.close();
    });

    on<LoginCloudEvent>((event, emit) {

    });

  }


  @override
  Future<void> close() {
    dio.close();
    return super.close();
  }

  void onHandleError() {
    print("onHandleError");
  }

  Future<bool> _test(String host) async {

    try {
      dio = Dio(); // Provide a dio instance
      dio.options.headers['Demo-Header'] = 'demo header'; // config your dio headers globally

      //dio.options.baseUrl = host;
      final client = RestClient(dio, baseUrl: host);

      await client.getTasks().then((it) {

        listTask = it;

      });

    } catch (err) {
      print("connect error ${err}");
      return false;
    }

    return true;
  }

}