import 'package:flutter/material.dart';
import 'screens/login_page.dart';
void main() {
  runApp(const DrowsiGuardApp());
}
class DrowsiGuardApp extends StatelessWidget {
  const DrowsiGuardApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrowsiGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0F2027),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}