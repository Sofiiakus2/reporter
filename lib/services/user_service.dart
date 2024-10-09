import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:reporter/services/auth_service.dart';

import '../models/user_model.dart';

class UserService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<UserModel?> getUserData() {
    User? user =  _auth.currentUser;
    return _firestore.collection('users').doc(user?.uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        return UserModel(
          role: data?['role'],
          name: data?['name'],
          department: data?['department'],
          email: data?['email'],
          countOfTasks: data?['countOfTasks'] ?? 0,
          countOfDoneTasks: data?['countOfDoneTasks'] ?? 0,
        );
      }
      return null;
    });
  }

  Future<String> getUserDepartment() async {
    User? user = _auth.currentUser;

    if (user != null) {
      final snapshot = await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        final data = snapshot.data();
        return data?['department'] ?? '';
      }
    }

    return '';
  }


  static Future<void> checkAndSaveRole() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        final data = snapshot.data();
        AuthService.saveRole(data?['role']) ;
      }
    }

  }

  static Future<void> updateUserName(String newName) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await user.updateDisplayName(newName);
        await user.reload();

        await _firestore.collection('users').doc(user.uid).update({
          'name': newName,
        });

      } catch (e) {
        rethrow;
      }
    }
  }

  Stream<List<UserModel>> getAllUsersData() {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.id != currentUser?.uid)
          .map((doc) {
        final data = doc.data();
        return UserModel(
          id: doc.id,
          role: data['role'],
          name: data['name'],
          department: data['department'] ?? '',
          email: data['email'],
          countOfTasks: data['countOfTasks'],
          countOfDoneTasks: data['countOfDoneTasks']
        );
      }).toList();
    });
  }

  Stream<List<UserModel>> getAllWorkersStream(String department) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    print('HERE');
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'user')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.where((doc) {
        final userDepartment = doc.data()['department'];

        return doc.id != currentUser?.uid &&
            (userDepartment == null || userDepartment.isEmpty || userDepartment == department);
      }).map((doc) {
        final data = doc.data();

        return UserModel(
          id: doc.id,
          role: data['role'],
          name: data['name'],
          department: data['department'] ?? '',
          email: data['email'],
        );
      }).toList();
    });
  }





  static Future<Map<String, bool>> getPlanToDo(String userId) async {
    try   {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

          if (data != null && data.containsKey('planToDo')) {
            Map<String, dynamic> planToDoData = data['planToDo'];

            if (planToDoData.containsKey('date')) {
              DateTime storedDate = DateTime.parse(planToDoData['date']);
              DateTime today = DateTime.now();

              if (storedDate.year == today.year &&
                  storedDate.month == today.month &&
                  storedDate.day == today.day) {
                if (planToDoData.containsKey('tasks')) {
                  Map<String, bool> planToDo = Map<String, bool>.from(planToDoData['tasks']);
                  return planToDo;
                }
              }
            }
          }
          return {};
        } else {
          throw Exception("User document does not exist");
        }
      } catch (e) {
        rethrow;
      }

  }

  static Future<void> setPlanToDo(List<String> tasks) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      DateTime now = DateTime.now();
      DateTime scheduledDate;

      if (now.weekday == DateTime.friday) {
        scheduledDate = now.add(Duration(days: 3));
      } else if(now.weekday == DateTime.saturday){
        scheduledDate = now.add(Duration(days: 2));
      } else {
        scheduledDate = now.add(Duration(days: 1));
      }

      Map<String, dynamic> planToDoData = {
        'date': scheduledDate.toIso8601String(),
        'tasks': {
          for (var task in tasks) task: false,
        },
      };

      try {
        await _firestore.collection('users').doc(currentUser.uid).update({
          'planToDo': planToDoData,
        });
      } catch (e) {
        print('Error updating tasks: $e');
      }
    }
  }

  static Future<bool> areTasksScheduled() async{
    User? currentUser = _auth.currentUser;

    if (currentUser != null){
      DateTime now = DateTime.now();
      DateTime scheduledDate;

      if (now.weekday == DateTime.friday) {
        scheduledDate = now.add(Duration(days: 3));
      } else if (now.weekday == DateTime.saturday) {
        scheduledDate = now.add(Duration(days: 2));
      } else {
        scheduledDate = now.add(Duration(days: 1));
      }

      try{
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (userDoc.exists) {
          Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey('planToDo')) {
            Map<String, dynamic> planToDo = data['planToDo'];
            if (planToDo['date'] == scheduledDate.toIso8601String()) {
              return true;
            }
          }
        }
      }catch (e) {
        rethrow;
      }
    }
    return false;
  }

  static Future<void> updateTaskStatus(String task, bool isCompleted) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        DocumentReference userDoc = _firestore.collection('users').doc(currentUser.uid);

        await _firestore.runTransaction((transaction) async {
          DocumentSnapshot userSnapshot = await transaction.get(userDoc);

          if (userSnapshot.exists) {
            Map<String, dynamic>? planToDoData = userSnapshot.data() as Map<String, dynamic>?;

            if (planToDoData != null && planToDoData.containsKey('planToDo')) {
              Map<String, dynamic> tasks = planToDoData['planToDo']['tasks'];

              tasks[task] = isCompleted;

              transaction.update(userDoc, {
                'planToDo.tasks': tasks,
                'planToDo.lastModified': FieldValue.serverTimestamp(),
              });
            }
          }
        });
      } catch (e) {
        print("Error updating task status: $e");
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  static Future<void> setTotalTasksCount(int total, int done) async {
    User? userCredential = _auth.currentUser;

    if (userCredential != null) {
      try {
        DocumentReference userDoc = _firestore.collection('users').doc(userCredential.uid);

        await _firestore.runTransaction((transaction) async {
          DocumentSnapshot userSnapshot = await transaction.get(userDoc);

          if (userSnapshot.exists) {
            Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
            int existingTotal = userData?['totalTaskCount'] ?? 0;
            int existingDone = userData?['doneTaskCount'] ?? 0;

            int updatedTotal = existingTotal + total;
            int updatedDone = existingDone + done;

            transaction.update(userDoc, {
              'totalTaskCount': updatedTotal,
              'doneTaskCount': updatedDone,
              'lastModified': FieldValue.serverTimestamp(),
            });
          }
        });
      } catch (e) {
        print("Error updating task counts: $e");
      }
    } else {
      print("No user is currently signed in.");
    }
  }
}
