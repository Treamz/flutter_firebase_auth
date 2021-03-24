import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/blocs/auth_bloc.dart';
import 'package:flutter_firebase/blocs/register_bloc.dart';
import 'package:flutter_firebase/events/auth_event.dart';
import 'package:flutter_firebase/events/register_event.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:flutter_firebase/states/register_state.dart';

import 'buttons/register_button.dart';

class RegisterPage extends StatefulWidget {
  final UserRepository _userRepository;

  RegisterPage({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  UserRepository get _userRepository => widget._userRepository;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState registerState) =>
      registerState.isValidEmailAndPassword & isPopulated &&
      !registerState.isSubmitting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Page"),
      ),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userRepository),
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, registerState) {
              if (registerState.isFailure) {
                print("register failed");
              } else if (registerState.isSubmitting) {
                print("register in progress");
              } else if (registerState.isSuccess) {
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
                            icon: Icon(Icons.email),
                            labelText: 'Enter your email'),
                        keyboardType: TextInputType.emailAddress,
                        autovalidate: true,
                        validator: (_) {
                          return registerState.isValidEmail
                              ? null
                              : 'Invalid email format';
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            labelText: 'Enter your password'),
                        autovalidate: true,
                        validator: (_) {
                          return registerState.isValidPassword
                              ? null
                              : 'Invalid password format';
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: RegisterButton(onPressed: () {
                          if (isRegisterButtonEnabled(registerState)) {
                            _registerBloc.add(RegisterEventPressed(
                                email: _emailController.text,
                                password: _passwordController.text));
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
