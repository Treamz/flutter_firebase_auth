import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/events/login_event.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:flutter_firebase/states/login_state.dart';
import 'package:flutter_firebase/validators/validators.dart';
import 'package:rxdart/rxdart.dart';
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.inital());

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(Stream<LoginEvent> loginEvents, transitionFunction) {
    // TODO: implement transformEvents
    final debounceStream = loginEvents.where((loginEvent) {
        return (loginEvent is LoginEventEmailChanged || loginEvent is LoginEventPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300)); // 300 ms for each event
    final nonDebounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is! LoginEventEmailChanged || loginEvent is! LoginEventPasswordChanged);
    });
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFunction);
  }
  @override
  Stream<LoginState> mapEventToState(LoginEvent loginEvent) async* {
    final loginState = state;
    // TODO: implement mapEventToState
    if (loginEvent is LoginEventEmailChanged) {
      yield loginState.cloneAndUpdate(
          isValidEmail: Validators.isValidEmail(loginEvent.email));
    } else if (loginEvent is LoginEventPasswordChanged) {
      yield loginState.cloneAndUpdate(
          isValidPassword: Validators.isValidPassword(loginEvent.password));
    } else if (loginEvent is LoginEventWithGooglePressed) {
      try {
        await _userRepository.signWithGoogle();
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    } else if (loginEvent is LoginEventWithEmailAndPasswordPressed) {
     try {
       await _userRepository.signInWithEmailAndPassword(loginEvent.email, loginEvent.password);
       yield LoginState.success();
     } catch(_) {
       yield LoginState.failure();
     }
    }
  }
}
