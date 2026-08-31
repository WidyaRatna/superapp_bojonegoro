import 'package:flutter/material.dart';
import '../pajak_screen.dart';


class AdminPajakScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminPajakScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return PajakScreen(
      isDarkMode: isDarkMode,
      onToggleDarkMode: onToggleDarkMode,
      isAdmin: true,
    );
  }
}
