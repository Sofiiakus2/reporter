
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reporter/analitik/analitik_by_staff/analitik_by_person.dart';

import '../../models/user_model.dart';
import '../../services/statistic_service.dart';
import '../../theme.dart';

class StaffCard extends StatefulWidget {
  const StaffCard({super.key, required this.user, required this.day});
  final UserModel user;
  final DateTime day;


  @override
  State<StaffCard> createState() => _StaffCardState();
}

class _StaffCardState extends State<StaffCard> {
  double progress = 0.0;

  Future<void> getProgress() async{

    //widget.day
   progress = await StatisticService.countMyProgressForDay(widget.day, widget.user.id!);
  }

  @override
  void initState() {
    super.initState();
    //getProgress();
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    getProgress();
    return GestureDetector(
      onTap: (){
        Get.to(() => AnalitikByPerson(userId: widget.user.id!,));
      },
      child: AnimatedContainer(
        width: screenSize.width,
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xfff0f0f7),
              Color(0xfff0f1f8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(10, 10),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(-10, -8),
            ),
          ],
        ),
        duration: Duration(seconds: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: thirdColor,
                  backgroundImage: NetworkImage('https://recordcellar.ca/wp-content/uploads/2023/01/justinbieberchanges.jpg',),
                ),
                SizedBox(width: 20,),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.user.name!,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.user.department ?? 'без відділа',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: null,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  '${(progress*100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
