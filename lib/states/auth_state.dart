import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AuthStateInitial extends AuthState {}

class AuthStateSuccess extends AuthState {
  final FirebaseUser firebaseUser;
  const AuthStateSuccess({this.firebaseUser});
  @override
  // TODO: implement props
  List<Object> get props => [firebaseUser];

  @override
  String toString() =>  'AuthStateSuccess, email: ${firebaseUser.email}';
}

class AuthStateFailure extends AuthState {}
