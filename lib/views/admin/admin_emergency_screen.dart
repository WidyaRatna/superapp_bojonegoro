import 'package:flutter/material.dart';
import '../emergency_screen.dart';

/// Halaman Admin Layanan Kontak Darurat Pemkab Bojonegoro
/// 100% Identik dengan Halaman User (EmergencyScreen)
/// Dilengkapi fitur Admin (isAdmin: true) untuk Layanan Darurat 24 Jam.
class AdminEmergencyScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminEmergencyScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return EmergencyScreen(
      isDarkMode: isDarkMode,
      onToggleDarkMode: onToggleDarkMode ?? () {},
      isAdmin: true,
    );
  }
}
