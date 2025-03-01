import 'package:flutter/material.dart';
import 'package:my_accountant/src/services/auth_service.dart';

import 'src/app.dart';
import 'src/controller/settings_controller.dart';
import 'src/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  AuthService authService = AuthService();
  bool authenticated = await authService.isAuthenticated();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(
    settingsController: settingsController,
    authenticated: authenticated,
  ));
}
