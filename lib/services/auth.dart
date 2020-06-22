import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {

    return user != null ? User( uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    
    return _auth.onAuthStateChanged
      // .map(( FirebaseUser user ) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sing in anom
  Future singInAnom() async {
    try {

      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);

    } catch(e){

      print(e.toString());
      return null;

    }
  }

  // sing in with email & password
  Future signInWithEmainAndPassword({ String email, String password }) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmainAndPassword({ String email, String password }) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserDate(sugars: '0', name: 'new crew member', strength: 100);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sing out
  Future signOut() async {

    try{
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}