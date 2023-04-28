import 'package:podify/auth/signup.dart';
import 'package:podify/screens/navbar.dart';
import 'package:podify/auth/login.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routerSettings) {
  switch (routerSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
          settings: routerSettings,
          builder: (_) {
            return const LoginScreen();
          });
    case NavBar.routeName:
      return MaterialPageRoute(
          settings: routerSettings,
          builder: (_) {
            return const NavBar();
          });
    case SignupScreen.routeName:
      return MaterialPageRoute(
          settings: routerSettings,
          builder: (_) {
            return const SignupScreen();
          });
    default:
      return MaterialPageRoute(
          settings: routerSettings,
          builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text("404"),
              ),
            );
          });
  }
}
