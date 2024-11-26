import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faulkner_footsteps/pages/list_page.dart';
import 'package:faulkner_footsteps/pages/admin_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // This checks the 'admins' collection in firebase for authorized accounts
  // if you want 
  Future<bool> checkAdminStatus(User user) async {
    final adminDoc = await FirebaseFirestore.instance
        .collection('admins')
        .doc(user.uid)
        .get();
    // if the person logging in is in the 'admins' collection, then return true, if not false
    return adminDoc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // temp color scheme, can be made better later
      backgroundColor: const Color.fromARGB(255, 219, 196, 166),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) { // waits for connection between firebase and app, ultimately unnecessary but wanted to try it out
            return const Center(child: CircularProgressIndicator()); // adds loading circle, nice little detail
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

          return FutureBuilder<bool>(
            future: checkAdminStatus(snapshot.data!),
            builder: (context, adminSnapshot) {
              if (adminSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // this is what directs the user to a specific page depending if they are an admin or not
              return adminSnapshot.data == true ? AdminListPage() : ListPage();
            },
          );
        },
      ),
    );
  }
}