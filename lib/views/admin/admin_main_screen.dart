import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../models/service_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../all_services_screen.dart';
import '../emergency_screen.dart';
import '../profile_screen.dart';
import 'admin_dashboard_overview_screen.dart';
import 'admin_emergency_screen.dart';
import 'admin_kependudukan_screen.dart';
import 'admin_kontak_instansi_screen.dart';
import 'admin_lapor_screen.dart';
import 'admin_layanan_sosial_screen.dart';
import 'admin_login_screen.dart';
import 'admin_loker_screen.dart';
import 'admin_pariwisata_screen.dart';
import 'admin_pendidikan_screen.dart';
import 'admin_pertanian_screen.dart';
import 'admin_pajak_screen.dart';
import 'admin_perhubungan_screen.dart';
import 'admin_news_screen.dart';
import '../kesehatan_screen.dart';

/// Admin Main Screen - Uses EXACT SAME SuperApp App Layout & Bottom Navigation Bar as User HomeScreen
class AdminMainScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const AdminMainScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    // Security Route Guard: Enforce Admin Role Check on Screen Initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = AuthService();
      if (!auth.isLoggedIn || !auth.isAdmin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akses Ditolak: Anda harus login sebagai Admin untuk mengakses Portal Admin.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminLoginScreen(
              isDarkMode: widget.isDarkMode,
              onToggleDarkMode: widget.onToggleDarkMode,
            ),
          ),
        );
      }
    });
  }

  Future<void> _openExternalUrl(String urlStr) async {
    final Uri url = Uri.parse(urlStr);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!kIsWeb) {
      try {
        if (Platform.isWindows) {
          await Process.run('cmd', ['/c', 'start', '', urlStr]);
          return;
        }
      } catch (_) {}
    }
  }

  void _navigateToAdminService(ServiceCategory service) {
    Widget targetScreen;
    final id = service.id.toLowerCase();
    final title = service.title.toLowerCase();

    if (id == 'umkm' || id == 'pangan' || title.contains('pangan')) {
      _openExternalUrl('https://disdag-online.bojonegorokab.go.id/trend/tabel');
      return;
    } else if (id == 'cctv' || title.contains('cctv')) {
      _openExternalUrl('https://bojonegorokab.go.id/gis-cctv/0');
      return;
    } else if (id == 'kependudukan' || title.contains('kependudukan')) {
      targetScreen = AdminKependudukanScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else if (id == 'kesehatan' || title.contains('kesehatan')) {
      targetScreen = KesehatanScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else if (id == 'pendidikan' || title.contains('pendidikan')) {
      targetScreen = AdminPendidikanScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else if (id == 'perpajakan' || id == 'pajak' || title.contains('pajak')) {
      targetScreen = AdminPajakScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else if (id == 'pertanian' || title.contains('tani')) {
      targetScreen = AdminPertanianScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else if (id == 'pariwisata' || title.contains('wisata')) {
      targetScreen = AdminPariwisataScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else if (id == 'pengaduan' || title.contains('pengaduan') || title.contains('lapor')) {
      targetScreen = AdminLaporScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else if (id == 'kontak_instansi' || title.contains('instansi')) {
      targetScreen = AdminKontakInstansiScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else if (id == 'emergency' || title.contains('darurat')) {
      targetScreen = AdminEmergencyScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else if (id == 'loker' || title.contains('loker') || title.contains('kerja')) {
      targetScreen = AdminLokerScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else if (id == 'layanan_sosial' || title.contains('sosial')) {
      targetScreen = AdminLayananSosialScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else if (id == 'perhubungan' || title.contains('perhubungan') || title.contains('hubung')) {
      targetScreen = AdminPerhubunganScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else if (id == 'portal_berita' || id == 'berita' || title.contains('berita') || title.contains('news')) {
      targetScreen = AdminNewsScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    } else {
      targetScreen = AdminKependudukanScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  Widget _buildBodyContent() {
    switch (_currentNavIndex) {
      case 0:
        return AdminDashboardOverviewScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        );
      case 1:
        return AllServicesScreen(
          allServices: sampleServices,
          isDarkMode: widget.isDarkMode,
          onServiceTap: _navigateToAdminService,
          onToggleDarkMode: widget.onToggleDarkMode,
        );
      case 2:
        return EmergencyScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        );
      case 3:
        return ProfileScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        );
      default:
        return AdminDashboardOverviewScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    if (!authService.isLoggedIn || !authService.isAdmin) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF0D62F1)),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Main Body Content matching current tab index
          _buildBodyContent(),

          // Floating Curved Bottom Navigation Bar (Identical to User UI)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentNavIndex,
              onTapTab: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
              },
              onCenterQrTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminLaporScreen()),
                );
              },
              isDarkMode: isDark,
            ),
          ),
        ],
      ),
    );
  }
}
