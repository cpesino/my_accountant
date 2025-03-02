import 'package:flutter/material.dart';
import 'package:my_accountant/src/controller/settings_controller.dart';
import 'package:my_accountant/src/features/auth/login_screen.dart';
import 'package:my_accountant/src/features/home/home_screen.dart';
import 'package:my_accountant/src/features/settings/settings_screen.dart';
import 'package:my_accountant/src/features/status/not_found_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(
      RouteSettings settings, bool authenticated,
      {required SettingsController settingsController}) {
    Widget screen;

    if (settings.name == '/') {
      screen = authenticated ? HomeScreen() : LoginScreen();
    } else {
      switch (settings.name) {
        case SettingsScreen.routeName:
          screen = SettingsScreen(controller: settingsController);
          break;
        case HomeScreen.routeName:
          screen = HomeScreen();
          break;
        case LoginScreen.routeName:
          screen = LoginScreen();
          break;
        default:
          screen = const NotFoundScreen();
      }
    }
    return MaterialPageRoute(builder: (_) => screen, settings: settings);
  }
}
