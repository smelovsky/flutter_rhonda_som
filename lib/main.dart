import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rhonda_som/ui/core/bloc_observer.dart';
import 'package:flutter_rhonda_som/ui/rhonda_som_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {

  Bloc.observer = AppBlocObserver();
  runApp(ProviderScope(child: RhondaSomApp()));
}


