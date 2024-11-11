

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/progress_task_screen.dart';
import '../controllers/bottom_navbar_controller.dart';
import '../widgets/task_manager_app_bar.dart';
import 'canceled_task_screen.dart';
import 'completed_task_screen.dart';
import 'new_task_screen.dart';

class MainBottomNavBarScreen extends StatelessWidget {

  static const String name = "/home";
 MainBottomNavBarScreen({super.key});



 final controller = Get.find<BottomNavBarController>();

  static  List<Widget> _screens = [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CanceledTaskScreen(),
    ProgressTaskScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskManagerAppBar( ),
      body: Obx(() => _screens[controller.selectedIndex]),
      bottomNavigationBar:Obx(() => NavigationBar(
        selectedIndex: controller.selectedIndex,
        onDestinationSelected: (int index) {

            controller.selectedIndex = index; // Update selected index

        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.new_label), label: "New"),
          NavigationDestination(icon: Icon(Icons.check_box), label: "Completed"),
          NavigationDestination(icon: Icon(Icons.close), label: "Cancel"),
          NavigationDestination(icon: Icon(Icons.access_time_filled_outlined), label: "Progress"),
        ],
      )),
    );
  }
}


