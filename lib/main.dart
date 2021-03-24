import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/blocs/auth_bloc.dart';
import 'package:flutter_firebase/blocs/login_bloc.dart';
import 'package:flutter_firebase/blocs/simple_bloc_observer.dart';
import 'package:flutter_firebase/events/auth_event.dart';
import 'package:flutter_firebase/pages/home_page.dart';
import 'package:flutter_firebase/pages/login_page.dart';
import 'package:flutter_firebase/pages/splash_page.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:flutter_firebase/states/auth_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _userRepository = UserRepository();
    // userRepository.createUserWithEmailAndPassword("test@gmail.com", "1337Treamz");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) {
          final authBloc = AuthBloc(userRepository: _userRepository);
          authBloc.add(AuthEventStarted());
          return authBloc;
        },
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
          if(authState is AuthStateSuccess) {
            return HomePage(); // home
          } else if(authState is AuthStateFailure) {
            return BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(userRepository: _userRepository),
              child: LoginPage(userRepository: _userRepository,), // LoginPage
            );
          }
          return SplashPage();
        },),
      )
    );
  }
}
