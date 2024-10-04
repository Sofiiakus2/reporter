import 'package:reporter/services/user_service.dart';

class StatisticService{

  static Future<double> countTodayProgress () async{
    Map<String, bool> planForToday = await UserService.getPlanToDo();
    int counter = 0;

    planForToday.forEach((key, value){
      if(value==true) counter++;

    });

    return (counter/planForToday.length);
  }
}