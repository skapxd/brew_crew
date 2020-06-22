import 'package:brew_crew/screens/authenticate/register.dart';
import 'package:flutter/material.dart';

import 'sing_in.dart';

class Authenticate extends StatefulWidget {

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    
    if (showSignIn) {
      return SingIn( toggleView: toggleView );
    } else {
      return Register( toggleView: toggleView );
    }
  }
}