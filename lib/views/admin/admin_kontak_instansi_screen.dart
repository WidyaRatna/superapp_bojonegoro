import 'package:flutter/material.dart';
import '../kontak_instansi_screen.dart';

/// Halaman Admin Kontak Instansi Pemkab Bojonegoro
/// 100% Identik dengan Halaman User (KontakInstansiScreen)
/// Dilengkapi fitur Admin (isAdmin: true) untuk Menambah, Mengedit, dan Menghapus kontak instansi.
class AdminKontakInstansiScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminKontakInstansiScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return KontakInstansiScreen(
      isDarkMode: isDarkMode,
      onToggleDarkMode: onToggleDarkMode,
      isAdmin: true,
    );
  }
}
