import 'package:flutter/material.dart';
import 'package:faulkner_footsteps/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faulkner Footsteps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRouter.loginPage,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
