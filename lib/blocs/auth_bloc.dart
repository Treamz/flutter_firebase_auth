import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/events/auth_event.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:flutter_firebase/states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthStateInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent authEvent) async*{
    // TODO: implement mapEventToState
   if(authEvent is AuthEventStarted) {
     final isSigned = await _userRepository.isSigned();
     if(isSigned) {
       final firebaseUser = await _userRepository.getUser();
       yield AuthStateSuccess(firebaseUser: firebaseUser);
     } else {
       yield AuthStateFailure();
     }

   } else if(authEvent is AuthEventLoggedIn) {
     yield AuthStateSuccess(firebaseUser: await _userRepository.getUser());

   } else if(authEvent is AuthEventLoggedOut) {
     _userRepository.signOut();
     yield AuthStateFailure();

   }
  }
}
