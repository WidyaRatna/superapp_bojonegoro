import 'package:flutter/material.dart';
import '../layanan_pengaduan_dpmptsp_screen.dart';

/// Halaman Admin Pengaduan DPMPTSP
/// 100% Identik dengan Halaman Pengaduan User (LayananPengaduanDpmptspScreen)
/// Dilengkapi hak akses admin (isAdmin: true) untuk mengedit jadwal & alur SOP.
class AdminLaporScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminLaporScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return LayananPengaduanDpmptspScreen(
      isDarkMode: isDarkMode,
      onToggleDarkMode: onToggleDarkMode,
      isAdmin: true,
      showHeader: true,
    );
  }
}
