import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/admin/admin_login_screen.dart';
import 'views/admin/admin_main_screen.dart';
import 'views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const SuperAppBojonegoro());
}

class SuperAppBojonegoro extends StatefulWidget {
  const SuperAppBojonegoro({super.key});

  @override
  State<SuperAppBojonegoro> createState() => _SuperAppBojonegoroState();
}

class _SuperAppBojonegoroState extends State<SuperAppBojonegoro> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = _themeMode == ThemeMode.dark;

    return MaterialApp(
      title: 'Super App Kabupaten Bojonegoro',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      // Light Theme Definition
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D62F1),
          brightness: Brightness.light,
          primary: const Color(0xFF0D62F1),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
      // Dark Theme Definition
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D62F1),
          brightness: Brightness.dark,
          primary: const Color(0xFF3B82F6),
          surface: const Color(0xFF0B0F19),
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
      home: SplashScreen(
        isDarkMode: isDarkMode,
        onToggleDarkMode: _toggleTheme,
      ),
      routes: {
        '/admin-login': (context) => AdminLoginScreen(
              isDarkMode: isDarkMode,
              onToggleDarkMode: _toggleTheme,
            ),
        '/admin-dashboard': (context) => AdminMainScreen(
              isDarkMode: isDarkMode,
              onToggleDarkMode: _toggleTheme,
            ),
      },
    );
  }
}
