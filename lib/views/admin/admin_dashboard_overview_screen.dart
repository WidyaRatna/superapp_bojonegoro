import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/news_model.dart';
import '../../models/service_model.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/news_section.dart';
import '../../widgets/popular_services.dart';
import '../../widgets/top_header.dart';
import '../all_services_screen.dart';
import '../notification_screen.dart';
import '../profile_screen.dart';
import 'admin_emergency_screen.dart';
import 'admin_kependudukan_screen.dart';
import 'admin_kontak_instansi_screen.dart';
import 'admin_lapor_screen.dart';
import 'admin_layanan_sosial_screen.dart';
import 'admin_loker_screen.dart';
import 'admin_news_screen.dart';
import 'admin_pariwisata_screen.dart';
import 'admin_pendidikan_screen.dart';
import 'admin_pertanian_screen.dart';
import '../kesehatan_screen.dart';
import 'admin_pajak_screen.dart';

/// Admin Dashboard Overview Screen - 100% REUSES SuperApp User Home UI Layout
class AdminDashboardOverviewScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminDashboardOverviewScreen({
    super.key,
    this.onNavigateTab,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<AdminDashboardOverviewScreen> createState() => _AdminDashboardOverviewScreenState();
}

class _AdminDashboardOverviewScreenState extends State<AdminDashboardOverviewScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _weatherTemp = '25.1°C';
  final String _weatherCondition = 'Cerah';
  final String _windSpeed = '5.8 km/h';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        onToggleDarkMode: widget.onToggleDarkMode ?? () {},
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

  void _openAdminNews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminNewsScreen()),
    );
  }

  void _openAllServices() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllServicesScreen(
          allServices: sampleServices,
          isDarkMode: widget.isDarkMode,
          onServiceTap: _navigateToAdminService,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    final mainIds = ['kependudukan', 'kesehatan', 'pendidikan', 'perpajakan'];
    final mainServices = <ServiceCategory>[];
    for (final id in mainIds) {
      final found = sampleServices.firstWhere(
        (s) => s.id == id,
        orElse: () => ServiceCategory(
          id: id,
          title: id,
          icon: Icons.design_services_rounded,
          color: const Color(0xFF0284C7),
          subServices: [],
        ),
      );
      mainServices.add(found);
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. TopHeader User Component (with Admin Greeting & Mode Pill)
            TopHeaderWidget(
              searchController: _searchController,
              onSearchChanged: (val) {},
              onNotificationTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(isDarkMode: isDark),
                  ),
                );
              },
              onProfileTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      isDarkMode: widget.isDarkMode,
                      onToggleDarkMode: widget.onToggleDarkMode ?? () {},
                    ),
                  ),
                );
              },
              onQrTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminLaporScreen()),
                );
              },
              isDarkMode: isDark,
              onToggleTheme: widget.onToggleDarkMode ?? () {},
              temperature: _weatherTemp,
              weatherCondition: _weatherCondition,
              windSpeed: _windSpeed,
              onWeatherTap: () {},
            ),

            // 2. Admin Badge Strip below header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D62F1).withAlpha(isDark ? 40 : 18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF0D62F1).withAlpha(isDark ? 80 : 40),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFF0D62F1), size: 20),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Portal Administrator Pemkab Bojonegoro — Kelola Konten & Layanan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D62F1),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'ADMIN',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Banner Carousel User Component
            const SizedBox(height: 8),
            BannerCarouselWidget(
              onViewServicesTap: _openAllServices,
            ),
            const SizedBox(height: 20),

            // 4. Layanan Populer Grid (User PopularServicesWidget with Admin Mode Pill)
            PopularServicesWidget(
              services: mainServices,
              onServiceTap: _navigateToAdminService,
              onViewAllTap: _openAllServices,
              isDarkMode: isDark,
              isAdminMode: true,
            ),
            const SizedBox(height: 24),

            // 5. Informasi Terbaru Feed Section (User NewsSectionWidget with Admin Action)
            NewsSectionWidget(
              newsList: sampleNews,
              onNewsTap: (news) => _openAdminNews(),
              onViewAllNewsTap: _openAdminNews,
              isDarkMode: isDark,
            ),

            // Bottom Spacing
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
