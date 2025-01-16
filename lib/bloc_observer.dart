import 'package:flutter_bloc/flutter_bloc.dart';

class MyObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('bloc change ${bloc.runtimeType} --${bloc.state.toString()} ${change
        .currentState.toString()} -> ${change.nextState.toString()}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('bloc transition ${bloc.runtimeType} -- ${transition.currentState
        .toString()} -> ${transition.nextState.toString()}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('bloc error ${bloc.runtimeType} -- ${error.toString()}');
  }
}
