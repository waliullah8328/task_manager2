import 'package:flutter/material.dart';


import '../controllers/auth_controller.dart';
import '../screens/profile_screen.dart';
import '../screens/signin_screen.dart';
import '../utils/app_colors.dart';


class TaskManagerAppBar extends StatelessWidget implements PreferredSizeWidget {
  TaskManagerAppBar({
    Key? key,
    this.isProfileOpen = false,
    this.profileData,
  }) : super(key: key);

  final bool isProfileOpen;
  final Map<String, String>? profileData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isProfileOpen) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: AuthController.userData!. Icon(Icons.person, size: 16), // Example placeholder icon
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
                   "${AuthController.userData!.email}" ?? "No email available",
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await AuthController.clearUserData();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                      (route) => false,
                );
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
