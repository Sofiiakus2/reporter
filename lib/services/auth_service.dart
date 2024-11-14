import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reporter/models/user_model.dart';
import 'package:reporter/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static void saveLoginState(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', userId);
  }

  static void saveRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }

  static Future<String?> getRole() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('role');
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
        'role': user.role,
        'department': '',
        'position':'',
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
      await UserService.checkAndSaveRole();

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
      await prefs.remove('role');
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> changePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await user.updatePassword(newPassword);
        await _auth.signOut();
        await _auth.signInWithEmailAndPassword(email: user.email!, password: newPassword);
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Користувач не знайдений або не увійшов у систему.',
        );
      }
    } catch (e) {
      print('Помилка при зміні паролю: $e');
      throw e;
    }
  }

}