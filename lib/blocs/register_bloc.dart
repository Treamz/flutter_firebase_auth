import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/events/login_event.dart';
import 'package:flutter_firebase/events/register_event.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:flutter_firebase/states/login_state.dart';
import 'package:flutter_firebase/states/register_state.dart';
import 'package:flutter_firebase/validators/validators.dart';
import 'package:rxdart/rxdart.dart';
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RegisterState.inital());

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(Stream<RegisterEvent> registerEvents, transitionFunction) {
    // TODO: implement transformEvents
    final debounceStream = registerEvents.where((loginEvent) {
      return (loginEvent is LoginEventEmailChanged || loginEvent is LoginEventPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300)); // 300 ms for each event
    final nonDebounceStream = registerEvents.where((loginEvent) {
      return (loginEvent is! LoginEventEmailChanged || loginEvent is! LoginEventPasswordChanged);
    });
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFunction);
  }
  @override
  Stream<RegisterState> mapEventToState(RegisterEvent registerEvent) async* {
    // TODO: implement mapEventToState
    if (registerEvent is RegisterEventEmailChanged) {
      yield state.cloneAndUpdate(
          isValidEmail: Validators.isValidEmail(registerEvent.email));
    } else if (registerEvent is RegisterEventPasswordChanged) {
      yield state.cloneAndUpdate(
          isValidPassword: Validators.isValidPassword(registerEvent.password));
    } else if (registerEvent is RegisterEventPressed) {
      yield RegisterState.loading();
      try {
        await _userRepository.createUserWithEmailAndPassword(registerEvent.email, registerEvent.password);
        yield RegisterState.success();
      } catch (ex) {
        print(ex.toString());
        yield RegisterState.failure();
      }
    }
  }
}
