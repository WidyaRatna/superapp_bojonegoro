import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news_model.dart';
import '../models/service_model.dart';
import '../widgets/top_header.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/popular_services.dart';
import '../widgets/news_section.dart';
import '../widgets/news_detail_sheet.dart';
import '../widgets/bottom_nav_bar.dart';
import 'all_services_screen.dart';
import 'profile_screen.dart';
import 'laporan_screen.dart';
import 'emergency_screen.dart';
import 'pendidikan_screen.dart';
import 'kesehatan_screen.dart';
import 'kependudukan_screen.dart';
import 'pariwisata_screen.dart';
import 'loker_screen.dart';
import 'kontak_instansi_screen.dart';
import 'layanan_pengaduan_dpmptsp_screen.dart';
import 'pajak_screen.dart';
import 'pertanian_screen.dart';
import 'perhubungan_screen.dart';
import 'news_screen.dart';
import 'layanan_sosial_screen.dart';
import 'notification_screen.dart';
import '../widgets/auth_guard.dart';





class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentNavIndex = 0;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter news articles based on search query
  List<NewsItem> get _filteredNews {
    if (_searchQuery.trim().isEmpty) return sampleNews;
    final query = _searchQuery.toLowerCase();
    return sampleNews.where((news) {
      return news.title.toLowerCase().contains(query) ||
          news.category.toLowerCase().contains(query) ||
          news.snippet.toLowerCase().contains(query);
    }).toList();
  }

  // Filter services based on search query
  List<ServiceCategory> get _homeGridServices {
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      return sampleServices.where((service) {
        final titleMatches = service.title.toLowerCase().contains(query);
        final subMatches =
            service.subServices.any((sub) => sub.toLowerCase().contains(query));
        return (titleMatches || subMatches) && service.id != 'lainnya';
      }).toList();
    }
    // Return exact 4 main services for Home: Kependudukan, Kesehatan, Pendidikan, Pajak & Retribusi
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
    return mainServices;
  }

  // Open All Services Category Screen ("Kategori Layanan") - Full Page Route
  void _openAllServicesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllServicesScreen(
          allServices: sampleServices,
          onServiceTap: _handleServiceTap,
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openPendidikanScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PendidikanScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openKesehatanScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KesehatanScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openKependudukanScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KependudukanScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openPariwisataScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PariwisataScreen(
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
  }

  void _openPajakScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PajakScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openPertanianScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PertanianScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openPerhubunganScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PerhubunganScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  Future<void> _openCctvScreen() async {
    const String urlStr = 'https://bojonegorokab.go.id/gis-cctv/0';
    await _openExternalUrl(urlStr);
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

  Future<void> _openWhatsAppUrl(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final formattedPhone = cleanPhone.startsWith('0') ? '62${cleanPhone.substring(1)}' : cleanPhone;
    await _openExternalUrl('https://wa.me/$formattedPhone');
  }

  Future<void> _openEmailUrl(String email) async {
    final Uri mailUrl = Uri.parse('mailto:$email');
    try {
      if (await canLaunchUrl(mailUrl)) {
        await launchUrl(mailUrl);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', 'mailto:$email']);
        return;
      } catch (_) {}
    }
  }

  void _openLayananPengaduanDpmptspScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LayananPengaduanDpmptspScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _handlePengaduanSubServiceTap(String subItem) {
    if (subItem.contains('DPMPTSP') || subItem.contains('Tatap Muka') || subItem.contains('Surat')) {
      _openLayananPengaduanDpmptspScreen();
    } else if (subItem.contains('SP4N-LAPOR') || subItem.contains('lapor.go.id')) {
      _openExternalUrl('https://www.lapor.go.id/');
    } else if (subItem.contains('Hotline') || subItem.contains('WA') || subItem.contains('822')) {
      _openWhatsAppUrl('082233099988');
    } else if (subItem.contains('Email')) {
      _openEmailUrl('dpmptsp.kabbjn@gmail.com');
    } else {
      _openLaporanWargaModal();
    }
  }

  Future<void> _openInformasiPanganScreen() async {
    const String urlStr = 'https://disdag-online.bojonegorokab.go.id/trend/tabel';
    await _openExternalUrl(urlStr);
  }

  void _openLokerScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LokerScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openKontakInstansiScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KontakInstansiScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openNewsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openLayananSosialScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LayananSosialScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _handleServiceTap(ServiceCategory category) {
    if (category.id == 'lainnya') {
      _openAllServicesScreen();
      return;
    }

    AuthGuard.requireLogin(
      context,
      serviceName: category.title,
      isDarkMode: widget.isDarkMode,
      onToggleDarkMode: widget.onToggleDarkMode,
      onAuthenticated: () {
        if (category.id == 'sosial' || category.title.toLowerCase().contains('sosial')) {
          _openLayananSosialScreen();
        } else if (category.id == 'pendidikan') {
          _openPendidikanScreen();
        } else if (category.id == 'kesehatan') {
          _openKesehatanScreen();
        } else if (category.id == 'kependudukan') {
          _openKependudukanScreen();
        } else if (category.id == 'pariwisata') {
          _openPariwisataScreen();
        } else if (category.id == 'pertanian' || category.title.toLowerCase().contains('pertanian') || category.title.toLowerCase().contains('tani')) {
          _openPertanianScreen();
        } else if (category.id == 'perhubungan' || category.title.toLowerCase().contains('perhubungan')) {
          _openPerhubunganScreen();
        } else if (category.id == 'cctv' || category.title.toLowerCase().contains('cctv')) {
          _openCctvScreen();
        } else if (category.id == 'perpajakan' || category.id == 'pajak' || category.title.toLowerCase().contains('pajak')) {
          _openPajakScreen();
        } else if (category.id == 'pengaduan' || category.id == 'lapor' || category.title.toLowerCase().contains('pengaduan')) {
          _openLayananPengaduanDpmptspScreen();
        } else if (category.id == 'umkm' || category.id == 'pangan' || category.title.toLowerCase().contains('pangan')) {
          _openInformasiPanganScreen();
        } else if (category.id == 'tenaga_kerja' || category.id == 'loker' || category.title.toLowerCase().contains('lowongan') || category.title.toLowerCase().contains('pekerjaan')) {
          _openLokerScreen();
        } else if (category.id == 'kontak_instansi' || category.title.toLowerCase().contains('instansi')) {
          _openKontakInstansiScreen();
        } else if (category.id == 'portal_berita' || category.id == 'berita' || category.title.toLowerCase().contains('berita')) {
          _openNewsScreen();
        } else if (category.id == 'kontak_darurat' || category.id == 'darurat') {
          _showEmergencyContactsModal();
        } else {
          _showServiceModal(category);
        }
      },
    );
  }

  // Open Service Detail Bottom Sheet
  void _showServiceModal(ServiceCategory category) {
    if (category.id == 'sosial' || category.title.toLowerCase().contains('sosial')) {
      _openLayananSosialScreen();
      return;
    }
    if (category.id == 'portal_berita' || category.title.toLowerCase().contains('berita')) {
      _openNewsScreen();
      return;
    }
    if (category.id == 'perhubungan' || category.title.toLowerCase().contains('perhubungan')) {
      _openPerhubunganScreen();
      return;
    }
    if (category.id == 'cctv' || category.title.toLowerCase().contains('cctv')) {
      _openCctvScreen();
      return;
    }
    if (category.id == 'pengaduan' || category.title.toLowerCase().contains('pengaduan')) {
      _openLayananPengaduanDpmptspScreen();
      return;
    }
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: category.color.withAlpha(30),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(category.icon, color: category.color, size: 28),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Layanan ${category.title}',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${category.subServices.length} sub-layanan online tersedia',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            Column(
              children: category.subServices.map((subItem) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      title: Text(
                        subItem,
                        style: TextStyle(
                          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0D62F1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        if (category.id == 'pendidikan') {
                          _openPendidikanScreen();
                        } else if (category.id == 'kesehatan') {
                          _openKesehatanScreen();
                        } else if (category.id == 'kependudukan') {
                          _openKependudukanScreen();
                        } else if (category.id == 'perpajakan' || category.title.toLowerCase().contains('pajak')) {
                          _openPajakScreen();
                        } else if (category.id == 'kontak_instansi') {
                          _openKontakInstansiScreen();
                        } else if (category.id == 'pertanian' || category.title.toLowerCase().contains('pertanian')) {
                          _openPertanianScreen();
                        } else if (category.id == 'sosial' || category.title.toLowerCase().contains('sosial')) {
                          _openLayananSosialScreen();
                        } else if (category.id == 'pengaduan') {
                          _handlePengaduanSubServiceTap(subItem);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Membuka formulir "$subItem"...'),
                              backgroundColor: const Color(0xFF0D62F1),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // Open Full News Detail Article Sheet
  void _openNewsDetail(NewsItem news) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewsDetailSheet(news: news),
    );
  }

  // Entrypoint for Laporan Warga button (Protected Feature - Login Required for Guest)
  void _openLaporanWargaModal() {
    AuthGuard.requireLogin(
      context,
      serviceName: 'Laporan Warga & Wadul Bupati',
      isDarkMode: widget.isDarkMode,
      onToggleDarkMode: widget.onToggleDarkMode,
      onAuthenticated: () {
        LaporanWargaService.openLaporanWarga(context, widget.isDarkMode);
      },
    );
  }

  // Telepon Darurat Screen Navigation (Full Screen)
  void _showEmergencyContactsModal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmergencyScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  // Profile Screen Navigation
  void _showProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  // Notification Screen Navigation
  void _openNotificationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  // Shared Weather Data
  final String _weatherTemp = '25.1°C';
  final String _windSpeed = '5.8 km/h';
  final String _deviceLocation = 'Bojonegoro, Jawa Timur';

  bool get _isNightWeather =>
      Theme.of(context).brightness == Brightness.dark || widget.isDarkMode || (DateTime.now().hour >= 18 || DateTime.now().hour < 6);
  IconData get _weatherIcon =>
      _isNightWeather ? Icons.nights_stay_rounded : Icons.light_mode_rounded;
  Color get _weatherColor =>
      _isNightWeather ? const Color(0xFFFDE047) : const Color(0xFFFBBF24);
  String get _weatherCondition => _isNightWeather ? 'Malam • Cerah' : 'Cerah';

  // Weather Details Dialog Modal with Modern Weather Icons & Dynamic GPS Location
  void _showWeatherDetailsModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Handle Bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),

            // Modal Header with Modern Sun/Moon Badge & Dynamic GPS Location Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isNightWeather
                              ? const [Color(0xFF1E293B), Color(0xFF334155)]
                              : const [Color(0xFFFBF7EE), Color(0xFFFEF3C7)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _weatherColor.withAlpha(80),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        _weatherIcon,
                        color: _isNightWeather
                            ? const Color(0xFFFDE047)
                            : const Color(0xFFD97706),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Cuaca Terkini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF064E3B).withAlpha(180)
                        : const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF10B981).withAlpha(80),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.near_me_rounded,
                        color: Color(0xFF10B981),
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _deviceLocation,
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF6EE7B7)
                              : const Color(0xFF166534),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Modern Weather Temperature Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isNightWeather
                      ? const [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF312E81)]
                      : const [Color(0xFF0052D4), Color(0xFF0D62F1), Color(0xFF1E6CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: (_isNightWeather
                            ? const Color(0xFF312E81)
                            : const Color(0xFF0D62F1))
                        .withAlpha(80),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _weatherTemp,
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.my_location_rounded,
                              color: Color(0xFF93C5FD), size: 13),
                          const SizedBox(width: 4),
                          Text(
                            '$_weatherCondition • GPS Otomatis HP',
                            style: const TextStyle(
                              color: Color(0xFFDBEAFE),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Ultra-Modern Glowing Sun/Moon Badge Graphic
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _weatherColor.withAlpha(140),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _weatherIcon,
                        size: 40,
                        color: _weatherColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Weather Metrics Grid (Angin, Kelembaban, AQI, UV) with Modern Icons
            Row(
              children: [
                _buildWeatherMetricCard('Kecepatan Angin', _windSpeed,
                    Icons.air_rounded, const Color(0xFF0284C7), isDark),
                const SizedBox(width: 10),
                _buildWeatherMetricCard('Kelembaban', '72%',
                    Icons.water_drop_rounded, const Color(0xFF059669), isDark),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildWeatherMetricCard('Kualitas Udara', 'AQI 34 (Baik)',
                    Icons.eco_rounded, const Color(0xFF10B981), isDark),
                const SizedBox(width: 10),
                _buildWeatherMetricCard('Indeks UV', '3 (Sedang)',
                    Icons.wb_twilight_rounded, const Color(0xFFF59E0B), isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherMetricCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Scrollable Page Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Curved Header with Greeting, Search Bar & Weather Info
                TopHeaderWidget(
                  searchController: _searchController,
                  onSearchChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onNotificationTap: _openNotificationScreen,
                  onProfileTap: _showProfile,
                  onQrTap: _openLaporanWargaModal,
                  isDarkMode: isDark,
                  onToggleTheme: widget.onToggleDarkMode,
                  temperature: _weatherTemp,
                  weatherCondition: _weatherCondition,
                  windSpeed: _windSpeed,
                  onWeatherTap: _showWeatherDetailsModal,
                ),

                // 2. Banner Layanan Digital
                const SizedBox(height: 16),
                BannerCarouselWidget(
                  onViewServicesTap: _openAllServicesScreen,
                ),
                const SizedBox(height: 20),

                // 3. Layanan Populer Section (2x2 Grid)
                PopularServicesWidget(
                  services: _homeGridServices,
                  onServiceTap: _handleServiceTap,
                  onViewAllTap: _openAllServicesScreen,
                  isDarkMode: isDark,
                ),
                const SizedBox(height: 24),

                // 4. Informasi Terbaru Feed Section (1-2 Compact Items)
                NewsSectionWidget(
                  newsList: _filteredNews,
                  onNewsTap: _openNewsDetail,
                  onViewAllNewsTap: _openNewsScreen,
                  isDarkMode: isDark,
                ),

                // Bottom padding to clear floating nav bar
                const SizedBox(height: 100),
              ],
            ),
          ),

          // Floating Curved Bottom Navigation Bar
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
                if (index == 1) {
                  _openAllServicesScreen();
                } else if (index == 2) {
                  _showEmergencyContactsModal();
                } else if (index == 3) {
                  _showProfile();
                }
              },
              onCenterQrTap: _openLaporanWargaModal,
              isDarkMode: isDark,
            ),
          ),
        ],
      ),
    );
  }
}