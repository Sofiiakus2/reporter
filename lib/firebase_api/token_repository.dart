import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TokenRepository{

  static Future<void> saveTokenToUserCollection(String token) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentReference userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid);

        await userDoc.update({
          'token': token,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> getTokenFromUser(String id) async {
    try {
      final doc =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
      return doc.data()!['token'];
    } catch (e) {
      throw Exception('Getting token ERROR: $e');
    }
  }
}