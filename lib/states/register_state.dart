import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool isValidEmail;
  final bool isValidPassword;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isValidEmailAndPassword => isValidEmail && isValidPassword;

  RegisterState(
      {@required this.isValidEmail,
        @required this.isValidPassword,
        @required this.isSubmitting,
        @required this.isSuccess,
        @required this.isFailure});

  factory RegisterState.inital() {
    return RegisterState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }

  factory RegisterState.loading() {
    return RegisterState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false);
  }

  factory RegisterState.failure() {
    return RegisterState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true);
  }

  factory RegisterState.success() {
    return RegisterState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false);
  }

  RegisterState cloneWith(
      {bool isValidEmail,
        bool isValidPassword,
        bool isSubmitting,
        bool isSuccess,
        bool isFailure}) {
    return RegisterState(
        isValidEmail: isValidEmail ?? this.isValidPassword, // isValidEmail == null => isValidEmail unchanged !
        isValidPassword: isValidPassword ?? this.isValidPassword,
        isSubmitting: isSubmitting ?? this.isSuccess,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }


  RegisterState cloneAndUpdate({
    bool isValidEmail,
    bool isValidPassword
  }) {
    return cloneWith(
        isValidEmail: isValidEmail,
        isValidPassword: isValidPassword
    );
  }
}
