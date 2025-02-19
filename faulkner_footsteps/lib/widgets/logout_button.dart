import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:faulkner_footsteps/app_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.logout,
        color: Color.fromARGB(255, 255, 243, 228),
      ),
      onPressed: () async {
        // Show confirmation dialog
        final bool? shouldLogout = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 238, 214, 196),
              title: Text(
                'Logout',
                style: GoogleFonts.ultra(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 72, 52, 52),
                  ),
                ),
              ),
              content: Text(
                'Are you sure you want to logout?',
                style: GoogleFonts.rakkas(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 72, 52, 52),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.rakkas(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 72, 52, 52),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Logout',
                    style: GoogleFonts.rakkas(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 72, 52, 52),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );

        if (shouldLogout == true) {
          await FirebaseAuth.instance.signOut();
          if (context.mounted) {
            // Navigate to login page and clear the navigation stack
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.loginPage,
              (route) => false,
            );
          }
        }
      },
    );
  }
}
