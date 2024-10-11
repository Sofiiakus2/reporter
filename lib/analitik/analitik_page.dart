import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reporter/analitik/reports_view.dart';
import 'package:reporter/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dates.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../today_date_widget/today_widget.dart';

class AnalitikPage extends StatefulWidget {
  const AnalitikPage({super.key});

  @override
  State<AnalitikPage> createState() => _AnalitikPageState();
}

class _AnalitikPageState extends State<AnalitikPage> with SingleTickerProviderStateMixin{

  late String? role;
  late String? userId;

  Future<void> _loadData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    role = preferences.getString('role');

    FirebaseAuth _auth = FirebaseAuth.instance;
    userId = _auth.currentUser!.uid;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: FutureBuilder<String>(
              future: UserService().getUserDepartment(),
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading department'));
                }

                final department = snapshot.data ?? '';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TodayWidget(),
                    Text('Ваші результати:', style: TextStyle(fontSize: 18),),
                    ReportsView(funk: ReportService.getReportsStream(userId!), isMine: true,),
                    SizedBox(height: 30,),
                    if(role == 'subadmin' )
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pезультати команди:', style: TextStyle(fontSize: 18),),
                          ReportsView(funk: ReportService.getReportsByDepartmentsStream(department), isMine: false,),
                        ],
                      ),

                    SizedBox(height: 30,),
                    if(role == 'admin' )
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pезультати працівників:', style: TextStyle(fontSize: 18),),
                          ReportsView(funk: ReportService.getReportsForAdminStream(), isMine: false,),
                        ],
                      ),

                  ],
                );
              }
          )
        ),
      ),
    );
  }
}
