import 'package:firebase_auth/firebase_auth.dart';
import 'package:reporter/models/user_model.dart';
import 'package:reporter/services/user_service.dart';

class StatisticService{

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<double> countMyTodayProgress () async{
    User? currentUser = _auth.currentUser;
    Map<String, bool> planForToday = await UserService.getPlanToDo(currentUser!.uid);
    int counter = 0;

    planForToday.forEach((key, value){
      if(value==true) counter++;

    });
    if(counter == 0){
      return 0;
    }else{
      return (counter/planForToday.length);
    }

  }

  static Future<double> countMyMonthProgress() async {
    double progress = 0.0;

    Stream<UserModel?> userDataStream = UserService().getUserData();

    await for (UserModel? userModel in userDataStream) {
      if (userModel != null) {
        int countOfTasks = userModel.countOfTasks!;
        int countOfDoneTasks = userModel.countOfDoneTasks!;

         if (countOfTasks > 0) {
           progress = (countOfDoneTasks / countOfTasks);
         }
      }

      break;
    }



    return progress;
  }

  static Future<double> countAllUsersTodayProgressExceptCurrent() async {
    int globalCountOfTasks = 0;
    int globalCountOfDoneTasks = 0;
    User? currentUser = _auth.currentUser;

    Stream<List<UserModel?>> allUsersStream = UserService().getAllUsersData();

    await for (List<UserModel?> userList in allUsersStream) {
      for (UserModel? userModel in userList) {
        if (userModel != null && userModel.id != currentUser?.uid) {
          Map<String, bool> planForToday = await UserService.getPlanToDo(userModel.id!);
          globalCountOfTasks += planForToday.length;
          planForToday.forEach((key, value){
            if(value==true) globalCountOfDoneTasks++;
          });
        }
      }
      if(globalCountOfTasks == 0){
        return 0;
      }else{
        return (globalCountOfDoneTasks/globalCountOfTasks);
      }
    }

    return 0;

  }

  static Future<double> countAllUsersProgressExceptCurrent() async {
    double totalProgress = 0.0;
    int totalCountOfTasks = 0;
    int totalCountOfDoneTasks = 0;
    User? currentUser = _auth.currentUser;

    Stream<List<UserModel?>> allUsersStream = UserService().getAllUsersData();

    await for (List<UserModel?> userList in allUsersStream) {
      for (UserModel? userModel in userList) {
        if (userModel != null && userModel.id != currentUser?.uid) {
          totalCountOfTasks += userModel.countOfTasks ?? 0;
          totalCountOfDoneTasks += userModel.countOfDoneTasks ?? 0;
        }
      }

      break;
    }

    if (totalCountOfTasks > 0) {
      totalProgress = (totalCountOfDoneTasks / totalCountOfTasks) ;
    }

    return totalProgress;
  }


  static Future<double> countAllUsersTodayProgressByDepartmentExceptCurrent() async {
    int globalCountOfTasks = 0;
    int globalCountOfDoneTasks = 0;
    User? currentUser = _auth.currentUser;
    String department = await UserService().getUserDepartment();

    Stream<List<UserModel?>> allUsersStream = UserService().getAllUsersData();

    await for (List<UserModel?> userList in allUsersStream) {
      for (UserModel? userModel in userList) {
        if (userModel != null && userModel.id != currentUser?.uid && userModel.department == department) {
          print(userModel.name);
          Map<String, bool> planForToday = await UserService.getPlanToDo(userModel.id!);
          globalCountOfTasks += planForToday.length;
          planForToday.forEach((key, value){
            if(value==true) globalCountOfDoneTasks++;
          });
        }
      }
      if(globalCountOfTasks == 0){
        return 0;
      }else{
        return (globalCountOfDoneTasks/globalCountOfTasks);
      }
    }

    return 0;

  }

  static Future<double> countAllUsersProgressByDepartmentExceptCurrent() async {
    double totalProgress = 0.0;
    int totalCountOfTasks = 0;
    int totalCountOfDoneTasks = 0;
    User? currentUser = _auth.currentUser;
    String department = await UserService().getUserDepartment();

    Stream<List<UserModel?>> allUsersStream = UserService().getAllUsersData();

    await for (List<UserModel?> userList in allUsersStream) {
      for (UserModel? userModel in userList) {
        if (userModel != null && userModel.id != currentUser?.uid && userModel.department == department) {
          totalCountOfTasks += userModel.countOfTasks ?? 0;
          totalCountOfDoneTasks += userModel.countOfDoneTasks ?? 0;
        }
      }

      break;
    }

    if (totalCountOfTasks > 0) {
      totalProgress = (totalCountOfDoneTasks / totalCountOfTasks) ;
    }

    return totalProgress;
  }




}