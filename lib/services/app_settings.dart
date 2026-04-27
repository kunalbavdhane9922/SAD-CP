/// ============================================================
/// APP SETTINGS — Global Configuration Singleton
/// ============================================================
///
/// Stores and manages application-wide settings such as
/// alert preferences, sensitivity levels, and the currently
/// logged-in user.
/// ============================================================

import '../models/user_model.dart';

class AppSettings {
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  // ---- Alert Toggles ----
  bool soundAlerts = true;
  bool vibrationAlerts = true;
  bool darkMode = false;
  bool autoStart = false;

  // ---- Server Configuration ----
  String serverIp = '10.85.124.202';
  int serverPort = 8000;

  // ---- Detection Parameters ----
  String sensitivity = 'Medium'; // Low, Medium, High

  // ---- Currently Logged-In User ----
  UserModel? currentUser;

  /// Map human-readable sensitivity to numeric thresholds
  double get drowsinessThreshold {
    switch (sensitivity) {
      case 'High':
        return 60.0; // More sensitive (alerts earlier)
      case 'Low':
        return 85.0; // Less sensitive (alerts later)
      case 'Medium':
      default:
        return 75.0;
    }
  }

  /// Clear user data on logout
  void logout() {
    currentUser = null;
  }
}
