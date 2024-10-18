import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Stream<List<Map<String, dynamic>>> getPlanToDoStream(DateTime day) async* {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      yield* FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

          if (data != null && data.containsKey('planToDo')) {
            List<dynamic> planToDoArray = data['planToDo'];

            List<Map<String, dynamic>> tasksForToday = [];

            for (var plan in planToDoArray) {
              if (plan.containsKey('date')) {
                DateTime storedDate = DateTime.parse(plan['date']);

                if (storedDate.year == day.year &&
                    storedDate.month == day.month &&
                    storedDate.day == day.day &&
                    plan.containsKey('tasks')) {
                  Map<String, dynamic> tasks = plan['tasks'];
                  tasksForToday.add({
                    'task': tasks['task'],
                    'description': tasks['description'],
                    'completed': tasks['completed'],
                  });
                }
              }
            }

            return tasksForToday;
          }
        }
        return [];
      });
    } else {
      yield [];
    }
  }

  static Future<List<Map<String, dynamic>>> getPlanToDo(DateTime targetDate) async {
    try {
      User? currentUser = _auth.currentUser;
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('planToDo')) {
          List<dynamic> planToDoArray = data['planToDo'];
          List<Map<String, dynamic>> tasksForTargetDate = [];

          for (var plan in planToDoArray) {
            if (plan.containsKey('date')) {
              DateTime storedDate = DateTime.parse(plan['date']);

              if (storedDate.year == targetDate.year &&
                  storedDate.month == targetDate.month &&
                  storedDate.day == targetDate.day &&
                  plan.containsKey('tasks')) {
                Map<String, dynamic> tasks = plan['tasks'];
                tasksForTargetDate.add({
                  'task': tasks['task'],
                  'description': tasks['description'],
                  'completed': tasks['completed'],
                });
              }
            }
          }

          return tasksForTargetDate; // Повертаємо список задач для вказаної дати
        }
        return [];
      } else {
        throw Exception("User document does not exist");
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> setPlanToDo(String task, String description, DateTime day) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {

      Map<String, dynamic> newPlan = {
        'date': day.toIso8601String(),
        'tasks': {
          'task': task,
          'description': description,
          'completed': false,
        },
      };

      try {
        // Отримуємо поточний масив планів
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        List<dynamic> planToDoArray = [];

        if (userDoc.exists) {
          Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

          if (data != null && data.containsKey('planToDo')) {
            planToDoArray = List<dynamic>.from(data['planToDo']);
          }
        }

        // Додаємо новий план до масиву
        planToDoArray.add(newPlan);

        // Оновлюємо документ користувача з новим масивом планів
        await _firestore.collection('users').doc(currentUser.uid).update({
          'planToDo': planToDoArray,
        });
      } catch (e) {
        rethrow;
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

  static Future<void> updateTaskStatus(String title, bool isCompleted) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        DocumentReference userDoc = _firestore.collection('users').doc(currentUser.uid);

        await _firestore.runTransaction((transaction) async {
          DocumentSnapshot userSnapshot = await transaction.get(userDoc);

          if (userSnapshot.exists) {
            Map<String, dynamic>? planToDoData = userSnapshot.data() as Map<String, dynamic>?;

            if (planToDoData != null && planToDoData.containsKey('planToDo')) {
              List<dynamic> listPlan = planToDoData['planToDo'];

              for(var item in listPlan){
                Map<String, dynamic> task = item['tasks'];
                if(task['task'] == title){
                  task['completed'] = isCompleted;

                }
              }
              transaction.update(userDoc, {
                'planToDo': listPlan,
              });


            }
          }
        });
      } catch (e) {
        rethrow;
      }
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
        rethrow;
      }
    }
  }
}
