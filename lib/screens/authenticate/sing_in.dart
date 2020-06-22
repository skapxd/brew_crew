import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class SingIn extends StatefulWidget {

  final Function toggleView;
  SingIn({ this.toggleView });

  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool obscureText = true;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Iniciar secion en Starbucks'),
        // actions: <Widget>[

        //   FlatButton.icon(
        //     icon: Icon( Icons.person),
        //     label: Text('Register'),
        //     onPressed: () {
        //       widget.toggleView(); 
        //     }, 
        //   )
        // ],
      ),
      body: SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.symmetric(vertical:  20, horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[

                SizedBox( height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email',),
                  validator: (val) => val.isEmpty ? 'Enter an email' : null,
                  onChanged:  (value) {

                    setState(() {
                      email = value;
                    });
                  },
                  
                ),

                SizedBox( height: 20.0,),
                Container(
                  width: double.infinity * 0.5,
                  child: TextFormField(
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
                      dynamic result = await _auth.signInWithEmainAndPassword(email: email, password: password);

                      // dynamic result  = await _auth.registerWithEmainAndPassword(email: email, password: password);
                      if (result == null) {
                        setState(() {
                          error = 'could not sign in whit those credentials';
                          loading = false;
                        });
                      }
                    } 

                  }
                ),

                SizedBox(height: 12,),

                _singIn(),

                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                )
              ],
            )
          )
        ),
      ),
    );
  }

  Widget _singIn( ) {

    return InkWell(
      onTap: () => widget.toggleView(),
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          // color: Color.fromRGBO(239 , 184, 16, 0.2),
          color: Colors.orange,
          borderRadius: BorderRadius.circular(5)
        ),

        child: Center(
          child: Text('Registrarse', style: TextStyle( color: Colors.black, fontWeight: FontWeight.bold ),)
        )
        // color: Color.fromRGBO(239 , 184, 16, 0.5),
        
      ),
    );
  }
}