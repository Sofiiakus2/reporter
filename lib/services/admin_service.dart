import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<String>> getDepartmentsForUser() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();

      if (userDoc.exists) {
        return List<String>.from(userDoc.get('departments') ?? []);
      }
      return [];
    } catch (e) {
      print("Error fetching departments: $e");
      return [];
    }
  }

  Future<void> addDepartmentToUser(String newDepartment) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        print("No user is currently signed in.");
        return;
      }

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

      List<String> departments = [];

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('departments')) {
          departments = List<String>.from(userData['departments']);
        }

        if (!departments.contains(newDepartment)) {
          departments.add(newDepartment);

          await _firestore.collection('users').doc(currentUser.uid).update({
            'departments': departments,
          });
        }
      } else {
        await _firestore.collection('users').doc(currentUser.uid).set({
          'departments': [newDepartment],
        });
      }
    } catch (e) {
      print("Error adding department: $e");
    }
  }

  static Future<void> makeNewManager(String userId, String department)async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      await userRef.update({
        'department': department,
        'role':'subadmin'
      });
    } catch (e) {
      print('Error making user manager: $e');
    }
  }

  static Future<void> deleteManager(String userId)async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      await userRef.update({
        'department': '',
        'role':'user'
      });
    } catch (e) {
      print('Error making user manager: $e');
    }
  }
}
