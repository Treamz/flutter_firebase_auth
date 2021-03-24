import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/blocs/login_bloc.dart';
import 'package:flutter_firebase/events/login_event.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleLoginButton extends StatelessWidget {
  // VoidCallback _onPressed;
  //
  // GoogleLoginButton({Key key, VoidCallback onPressed})
  //     : _onPressed = onPressed,
  //       super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 45,
      child: RaisedButton.icon(
        icon: Icon(FontAwesomeIcons.google,color: Colors.white, size: 17,),
        color: Colors.redAccent,
        onPressed: () {
          BlocProvider.of<LoginBloc>(context).add(LoginEventWithGooglePressed());
        },
        label: Text('Sign in with Google', style: TextStyle(color: Colors.white, fontSize: 16),),
      ),
    );
  }
}
