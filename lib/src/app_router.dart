import 'package:flutter/material.dart';
import 'package:my_accountant/src/controller/settings_controller.dart';
import 'package:my_accountant/src/features/auth/login_screen.dart';
import 'package:my_accountant/src/features/home/home_screen.dart';
import 'package:my_accountant/src/features/settings/settings_view.dart';
import 'package:my_accountant/src/features/status/not_found_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(
      RouteSettings settings, bool authenticated,
      {required SettingsController settingsController}) {
    Widget screen;

    if (settings.name == '/') {
      screen = authenticated ? const HomeScreen() : const LoginScreen();
    } else {
      switch (settings.name) {
        case SettingsView.routeName:
          screen = SettingsView(controller: settingsController);
          break;
        case HomeScreen.routeName:
          screen = const HomeScreen();
          break;
        case LoginScreen.routeName:
          screen = const LoginScreen();
          break;
        default:
          screen = const NotFoundScreen();
      }
    }
    return MaterialPageRoute(builder: (_) => screen, settings: settings);
  }
}
