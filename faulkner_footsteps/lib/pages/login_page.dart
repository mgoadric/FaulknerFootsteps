import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faulkner_footsteps/pages/list_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // This checks the 'admins' collection in firebase for authorized accounts
  // The result is stored in the user's app state for later use
  Future<void> checkAndStoreAdminStatus(User user, BuildContext context) async {
    final adminDoc = await FirebaseFirestore.instance
        .collection('admins')
        .doc(user.uid)
        .get();

    // Store the admin status in a shared preference or similar
    // We'll just use a static variable for simplicity
    isAdmin = adminDoc.exists;
  }

  // Static variable to track admin status
  static bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // temp color scheme, can be made better later
      backgroundColor: const Color.fromARGB(255, 219, 196, 166),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // waits for connection between firebase and app, ultimately unnecessary but wanted to try it out
            return const Center(
                child:
                    CircularProgressIndicator()); // adds loading circle, nice little detail
          }

          if (!snapshot.hasData) {
            return SignInScreen(
              providers: [EmailAuthProvider()],
              headerBuilder: (context, constraints, shrinkOffset) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: AspectRatio(aspectRatio: 1),
                );
              },
            );
          }

          // If we have a user, check their admin status but always return to ListPage
          checkAndStoreAdminStatus(snapshot.data!, context);
          return ListPage();
        },
      ),
    );
  }
}
