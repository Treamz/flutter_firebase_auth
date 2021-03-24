import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AuthEventStarted extends AuthEvent {}

class AuthEventLoggedIn extends AuthEvent {}
class AuthEventLoggedOut extends AuthEvent {}