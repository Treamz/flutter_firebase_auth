import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/blocs/auth_bloc.dart';
import 'package:flutter_firebase/events/auth_event.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     appBar: AppBar(
       title: Text('This is home page'),
       actions: <Widget>[
         IconButton(icon: Icon(Icons.exit_to_app), onPressed: () {
           BlocProvider.of<AuthBloc>(context).add(AuthEventLoggedOut());
         })
       ],
     ),
     body: Center(
       child: Text("This is home page", style: TextStyle(fontSize: 20),),
     ),
   );
  }

}