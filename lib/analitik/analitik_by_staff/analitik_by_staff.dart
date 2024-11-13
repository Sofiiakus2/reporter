import 'package:flutter/material.dart';
import 'package:reporter/analitik/analitik_by_staff/staff_card.dart';
import 'package:reporter/models/user_model.dart';
import 'package:reporter/services/report_service.dart';


class AnalitikByStaff extends StatefulWidget {
  const AnalitikByStaff({super.key, required this.day, required this.role});
  final DateTime day;
  final String role;

  @override
  State<AnalitikByStaff> createState() => _AnalitikByStaffState();
}

class _AnalitikByStaffState extends State<AnalitikByStaff> {
  Stream<List<UserModel>>? _funk;

  @override
  void initState() {
    super.initState();
    if(widget.role == 'admin'){
      _funk = ReportService.getReportsForAdminStream();
    }else {
      _funk = ReportService.getReportsForSameDepartmentStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: _funk,
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<UserModel> staffList = snapshot.data ?? [];

          if (staffList.isEmpty) {
            return Text('Не знайдено користувачів', style: Theme.of(context).textTheme.bodySmall);
          }

          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: staffList.length,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    StaffCard(user: staffList[index], day: widget.day,),
                    SizedBox(height: 25,)
                  ],
                );
              }
          );
        }
    );
  }
}
