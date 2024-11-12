

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:task_manager/ui/screens/progress_task_screen.dart';
import '../controller/bottom_navbar_provider.dart';
import '../widgets/task_manager_app_bar.dart';
import 'canceled_task_screen.dart';
import 'completed_task_screen.dart';
import 'new_task_screen.dart';

class MainBottomNavBarScreen extends StatelessWidget {

 const MainBottomNavBarScreen({super.key});





  static  final List<Widget> _screens = [
    const NewTaskScreen(),
    const CompletedTaskScreen(),
    const CanceledTaskScreen(),
    const ProgressTaskScreen()
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const TaskManagerAppBar( ),
      body: Consumer<BottomNavBarProvider>(builder: (context, value, child) {
        return _screens[value.selectedIndex];
      },),
      bottomNavigationBar: Consumer<BottomNavBarProvider>(builder: (context, value, child) {
        return NavigationBar(
          selectedIndex: value.selectedIndex,
          onDestinationSelected: (int index) {

            value.selectedIndex = index; // Update selected index

          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.new_label), label: "New"),
            NavigationDestination(icon: Icon(Icons.check_box), label: "Completed"),
            NavigationDestination(icon: Icon(Icons.close), label: "Cancel"),
            NavigationDestination(icon: Icon(Icons.access_time_filled_outlined), label: "Progress"),
          ],
        );
      },),
    );
  }
}


