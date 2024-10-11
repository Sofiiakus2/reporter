import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubadminService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> makeNewWorker(String userId, String department)async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      await userRef.update({
        'department': department,
      });
    } catch (e) {
      Exception('Error making user manager: $e');
    }
  }

  static Future<void> deleteWorker(String userId)async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      await userRef.update({
        'department': '',
      });
    } catch (e) {
      Exception('Error making user manager: $e');
    }
  }

}