import 'package:flutter/material.dart';
import 'package:reporter/home/main_progres_view.dart';
import 'package:reporter/home/tasks_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 70),
            child: Column(
              children: [
                MainProgresView(),
                SizedBox(height: 70,),
                Text('Задачi на сьогоднi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TasksListView(day: DateTime.now(),),
                SizedBox(height: kBottomNavigationBarHeight/2)
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}
