import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reporter/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static void saveLoginState(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', userId);
  }

  static Future<void> createUser (UserModel user)async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'id': userCredential.user?.uid,
        'email': user.email,
        'name': user.name,
      });
    }catch(e){
      rethrow;
    }
  }

  static Future<bool> signInWithEmailAndPassword(UserModel user)async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );

      saveLoginState(userCredential.user!.uid);

      return userCredential.user != null;
    } catch(e){
      rethrow;
    }
  }

  static Future<void> leaveSession()async{
    try {
      await _auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      print('User signed out successfully.');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

}