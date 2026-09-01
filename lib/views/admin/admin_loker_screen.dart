import 'package:flutter/material.dart';
import '../loker_screen.dart';

/// Halaman Admin Lowongan Pekerjaan Pemkab Bojonegoro
/// 100% Identik dengan Halaman User (LokerScreen)
/// Dilengkapi fitur Admin (isAdmin: true) untuk Verifikasi, Menambah, Mengedit, dan Menghapus loker.
class AdminLokerScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminLokerScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return LokerScreen(
      isDarkMode: isDarkMode,
      onToggleDarkMode: onToggleDarkMode,
      isAdmin: true,
    );
  }
}
