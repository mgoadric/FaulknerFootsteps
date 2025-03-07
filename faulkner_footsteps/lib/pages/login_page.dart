import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faulkner_footsteps/pages/list_page.dart';
import 'package:faulkner_footsteps/pages/admin_page.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Static variable to track admin status
  static bool isAdmin = false;

  // This checks the 'admins' collection in firebase for authorized accounts
  // The result is stored in the user's app state for later use
  Future<void> checkAndStoreAdminStatus(User user, BuildContext context) async {
    final adminDoc = await FirebaseFirestore.instance
        .collection('admins')
        .doc(user.uid)
        .get();
    // Store the admin status in a static variable
    isAdmin = adminDoc.exists;
  }

  @override
  Widget build(BuildContext context) {
    // Create a custom theme that matches your app's style
    final customTheme = ThemeData(
      primaryColor: const Color.fromARGB(255, 107, 79, 79),
      scaffoldBackgroundColor: const Color.fromARGB(255, 238, 214, 196),
      colorScheme: ColorScheme.light(
        primary: const Color.fromARGB(255, 107, 79, 79),
        secondary: const Color.fromARGB(255, 176, 133, 133),
        surface: const Color.fromARGB(255, 255, 243, 228),
        background: const Color.fromARGB(255, 238, 214, 196),
        onPrimary: const Color.fromARGB(255, 255, 243, 228),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Color.fromARGB(255, 255, 243, 228),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 176, 133, 133),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 107, 79, 79),
            width: 2.0,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 107, 79, 79),
          foregroundColor: const Color.fromARGB(255, 255, 243, 228),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 107, 79, 79),
        ),
      ),
    );

    return Theme(
      data: customTheme,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 238, 214, 196),
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator with theme colors
              return const Center(
                  child: CircularProgressIndicator(
                color: Color.fromARGB(255, 107, 79, 79),
              ));
            }

            if (!snapshot.hasData) {
              // Customize the SignInScreen to match the app's theme
              return SignInScreen(
                providers: [EmailAuthProvider()],
                headerBuilder: (context, constraints, shrinkOffset) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 30, bottom: 20),
                    child: Column(
                      children: [
                        // App title
                        Text(
                          'Faulkner Footsteps',
                          style: GoogleFonts.ultra(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 72, 52, 52),
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Optional subtitle
                        Text(
                          'Explore Historical Sites',
                          style: GoogleFonts.rakkas(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 107, 79, 79),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                subtitleBuilder: (context, action) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 4.0),
                    child: Text(
                      action == AuthAction.signIn
                          ? 'Welcome back! Please sign in to continue.'
                          : 'Welcome! Please create an account to get started.',
                      style: GoogleFonts.rakkas(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 72, 52, 52),
                          fontSize: 13,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                footerBuilder: (context, action) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Discover the rich history of Faulkner County',
                      style: GoogleFonts.rakkas(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 107, 79, 79),
                          fontSize: 12,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                sideBuilder: (context, constraints) {
                  return Container(
                    color: const Color.fromARGB(255, 238, 214, 196),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Faulkner Footsteps',
                          style: GoogleFonts.ultra(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 72, 52, 52),
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            // If we have a user, check their admin status and return to the appropriate page
            checkAndStoreAdminStatus(snapshot.data!, context);
            
            // Return the appropriate page based on admin status
            return isAdmin ? AdminListPage() : ListPage();
          },
        ),
      ),
    );
  }
}