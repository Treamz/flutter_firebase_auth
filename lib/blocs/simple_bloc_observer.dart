import 'package:flutter_bloc/flutter_bloc.dart';

// Allow see bloc event log
class SimpleBlocObserver extends BlocObserver{
  @override
  void onEvent(Bloc bloc, Object event) {
    // TODO: implement onEvent
    super.onEvent(bloc, event);
  }
  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    // TODO: implement onError
    super.onError(bloc, error, stackTrace);
  }
  @override
  void onTransition(Bloc bloc, Transition transition) {
    // TODO: implement onTransition
    super.onTransition(bloc, transition);
  }
}