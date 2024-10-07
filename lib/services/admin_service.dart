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

      // Check if the user is logged in
      if (currentUser == null) {
        print("No user is currently signed in.");
        return;
      }

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

      List<String> departments = []; // Initialize the departments list

      if (userDoc.exists) {
        // Cast the data to a Map<String, dynamic> type
        final userData = userDoc.data() as Map<String, dynamic>?;

        // Check if 'departments' field exists and fetch it
        if (userData != null && userData.containsKey('departments')) {
          departments = List<String>.from(userData['departments']);
        }

        // Add new department only if it doesn't already exist
        if (!departments.contains(newDepartment)) {
          departments.add(newDepartment);

          // Update the user document with the new list of departments
          await _firestore.collection('users').doc(currentUser.uid).update({
            'departments': departments,
          });
        }
      } else {
        // If the document doesn't exist, create it with the new department
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
