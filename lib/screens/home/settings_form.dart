import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  SettingForm({Key key}) : super(key: key);

  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  
  // form values
  String _currentName;
  String _currentSugars;
  int _currentStremgth;
  
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          UserData userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[

                Text(
                  'Update your brew settings.',
                  style: TextStyle(fontSize: 18),
                ),

                SizedBox(height: 20,),

                TextFormField(
                  initialValue: userData.name,
                  decoration: textDecoration(text: 'name'),
                  validator: (val) => val.isEmpty ? 'Please enter name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),

                SizedBox(height: 20,),

                //  dropdown
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentSugars ?? userData.sugars,
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars')
                    );
                  }).toList(), 
                  onChanged: (val) => setState(() => _currentSugars = val)
                ),

                // slider
                Slider(
                  value: (_currentStremgth ?? userData.strength).toDouble() , 
                  activeColor: Colors.brown[_currentStremgth ?? userData.strength],
                  inactiveColor: Colors.brown[_currentStremgth ?? userData.strength],
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (val) => setState(() => _currentStremgth = val.round())
                ),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await DatabaseService(uid: user.uid).updateUserDate(
                        sugars:   _currentSugars   ?? userData.sugars, 
                        name:     _currentName     ?? userData.name, 
                        strength: _currentStremgth ?? userData.strength
                      );
                      Navigator.pop(context);
                    }
                  }
                )
              ],
            )
          );
        }else {
          return Loading();
        }
        
      }
    );
  }
}