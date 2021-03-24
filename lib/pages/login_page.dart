import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/blocs/auth_bloc.dart';
import 'package:flutter_firebase/blocs/login_bloc.dart';
import 'package:flutter_firebase/events/auth_event.dart';
import 'package:flutter_firebase/events/login_event.dart';
import 'package:flutter_firebase/pages/buttons/google_login_button.dart';
import 'package:flutter_firebase/pages/buttons/login_button.dart';
import 'package:flutter_firebase/pages/buttons/register_user_button.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:flutter_firebase/states/login_state.dart';

class LoginPage extends StatefulWidget {
  final UserRepository _userRepository;

  LoginPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwodController = TextEditingController();
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of(context);
    _emailController.addListener(() {
      _loginBloc.add(LoginEventEmailChanged(email: _emailController.text));
    });
    _passwodController.addListener(() {
      _loginBloc.add(LoginEventPasswordChanged(password: _passwodController.text));
    });
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwodController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState loginState) =>
      loginState.isValidEmailAndPassword & isPopulated &&
      !loginState.isSubmitting;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, loginState) {
          if (loginState.isFailure) {
            print('Login Failed');
          } else if (loginState.isSubmitting) {
            print('Loggin in');
          } else if (loginState.isSuccess) {
            BlocProvider.of<AuthBloc>(context).add(AuthEventLoggedIn());
          }
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email), labelText: 'Enter your email'),
                    keyboardType: TextInputType.emailAddress,
                    autovalidate: true,
                    validator: (_) {
                      return loginState.isValidEmail
                          ? null
                          : 'Invalid email format';
                    },
                  ),
                  TextFormField(
                    controller: _passwodController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Enter your password'),
                    autovalidate: true,
                    validator: (_) {
                      return loginState.isValidPassword
                          ? null
                          : 'Invalid password format';
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: LoginButton(
                      onPressed: isLoginButtonEnabled(loginState)
                          ? _onLoginEmailAndPassword
                          : null,
                    ),
                  ),
                  RegisterUserButton(userRepository: _userRepository,),
                  GoogleLoginButton()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onLoginEmailAndPassword() {
    _loginBloc.add(LoginEventWithEmailAndPasswordPressed(email: _emailController.text, password: _passwodController.text));
  }
}
