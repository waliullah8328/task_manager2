import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/routes/route_name.dart';
import '../controller/auth_controller.dart';

import '../utils/app_colors.dart';


class TaskManagerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaskManagerAppBar({
    super.key,
    this.isProfileOpen = false,
    this.profileData,
  });

  final bool isProfileOpen;
  final Map<String, String>? profileData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isProfileOpen) {
          return;
        }
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  ProfileScreen(),
          ),
        );*/
        Get.toNamed(RouteName.profileScreen);
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Row(
          children: [
             CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,

              child:  Icon(Icons.person, size: 16), // Example placeholder icon
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   "${AuthController.userData!.firstName} ${AuthController.userData!.lastName}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                   "${AuthController.userData!.email}",
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await AuthController.clearUserData();
                /*
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) =>  SignInScreen()),
                      (route) => false,
                );
                */
                Get.offAllNamed(RouteName.loginScreen);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
