import 'package:flutter/material.dart';
import 'package:faulkner_footsteps/app_router.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.person,
        color: Color.fromARGB(255, 255, 243, 228),
      ),
      onPressed: () {
        Navigator.pushNamed(context, AppRouter.profilePage);
      },
    );
  }
}
