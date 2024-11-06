import 'package:flutter/material.dart';
import 'package:faulkner_footsteps/pages/list_page.dart';
import 'package:faulkner_footsteps/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AppRouter {
  // shorthand for each page
  static const String loginPage = '/';
  static const String list = '/list';

  // cases for the router, what should happen when moving to this page
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case list:
        return MaterialPageRoute(builder: (_) => ListPage());
      default:
        return _errorRoute();
    }
  }

  // error catch, displays errors for the user
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }


  // navigation fo pages, what causes the actual moving between pages
  static Future<void> navigateTo(BuildContext context, String routeName,
      {Map<String, dynamic>? arguments}) async {
    if (FirebaseAuth.instance.currentUser == null && routeName != loginPage) {
      await Navigator.pushReplacementNamed(context, loginPage);
    } else {
      await Navigator.pushNamed(context, routeName, arguments: arguments);
    }
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}