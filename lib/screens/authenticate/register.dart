import 'package:brew_crew/screens/authenticate/sing_in.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Registrarse en Starbucks'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: () => widget.toggleView()
        ),
        // actions: <Widget>[

        //   FlatButton.icon(
        //     icon: Icon( Icons.person),
        //     label: Text('Sign In'),
        //     onPressed: () {
        //       widget.toggleView();
        //     }, 
        //   )
        // ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical:  20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[

              SizedBox( height: 20.0,),
              TextFormField(
                decoration: textDecoration(text: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged:  (value) {

                  setState(() {
                    email = value;
                  });
                },
              ),

              SizedBox( height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye), 
                        color: !obscureText ? Colors.blue : Colors.grey ,
                        onPressed: () => setState(() => obscureText = !obscureText)
                      )
                ),
                obscureText: obscureText,
                validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged:  (value) {

                  setState(() {
                    password = value;
                  });
                },
              ),

              SizedBox( height: 20.0,),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Comenzar',
                  style: TextStyle( color: Colors.white),
                ),
                onPressed: () async {

                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result  = await _auth.registerWithEmainAndPassword(email: email, password: password);
                    loading = false;

                    if (result == null) {
                      setState(() {
                        error = 'please supply a valid email';
                        loading = false;
                      });
                    }
                  } 

                }
              ),

              SizedBox(height: 12,),

              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14),
              )
            ],
          )
        )
      ),
    );
  }
}