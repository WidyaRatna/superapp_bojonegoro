import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../widgets/superapp_header.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pupuk_bersubsidi_screen.dart';
import 'pengaduan_pertanian_screen.dart';

class PertanianScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const PertanianScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<PertanianScreen> createState() => _PertanianScreenState();
}

class _PertanianScreenState extends State<PertanianScreen> {
  // Helper for opening web URLs with error handling
  Future<void> _openWebUrl(String urlStr) async {
    var formattedUrl = urlStr.trim();
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }
    final Uri uri = Uri.parse(formattedUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', formattedUrl]);
        return;
      } catch (_) {}
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membuka portal $urlStr...'),
          backgroundColor: const Color(0xFF16834A),
        ),
      );
    }
  }

  void _openPupukBersubsidi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PupukBersubsidiScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openPengaduanPertanian() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengaduanPertanianScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    const primaryGreen = Color(0xFF16834A);
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final pertanianGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D4726), Color(0xFF15803D)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF12663A), Color(0xFF16834A)],
          );

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Layanan Pertanian',
            subtitle: 'DKPP Kabupaten Bojonegoro',
            gradient: pertanianGradient,
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Compact Info Box: Dinas Ketahanan Pangan & Pertanian
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 1.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryGreen.withAlpha(isDark ? 35 : 15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: primaryGreen.withAlpha(30), width: 1.0),
                          ),
                          child: const Icon(
                            Icons.agriculture_rounded,
                            color: primaryGreen,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dinas Ketahanan Pangan & Pertanian',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Jl. Ahmad Yani No. 24, Bojonegoro',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _openWebUrl('https://dinperta.bojonegorokab.go.id/'),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'dinperta',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: primaryGreen,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.arrow_outward_rounded,
                                color: primaryGreen,
                                size: 13,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Featured Service: Pupuk Bersubsidi (White card with Green accent - Kependudukan style)
                  Text(
                    'Layanan Utama Pertanian',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Informasi alokasi & tata cara penebusan pupuk bersubsidi:',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: primaryGreen.withAlpha(isDark ? 25 : 10),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: _openPupukBersubsidi,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Icon Box Container (Soft Green Pastel)
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: primaryGreen.withAlpha(isDark ? 40 : 18),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: primaryGreen.withAlpha(30), width: 1.0),
                                ),
                                child: const Icon(
                                  Icons.inventory_2_outlined,
                                  color: primaryGreen,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Center Content Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Badge Label
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: primaryGreen.withAlpha(isDark ? 35 : 15),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: primaryGreen.withAlpha(30), width: 1.0),
                                      ),
                                      child: const Text(
                                        'LAYANAN UTAMA DKPP',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: primaryGreen,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Pupuk Bersubsidi',
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Informasi e-RDKK 2025–2026, status alokasi penerima pupuk bersubsidi, syarat kelayakan, serta tata cara penebusan resmi di KPL.',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Subtle Compact Circular Arrow Button (28px circle, 14px icon)
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: primaryGreen.withAlpha(isDark ? 35 : 15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: primaryGreen.withAlpha(30),
                                    width: 1.0,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: primaryGreen,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 3. Secondary Service: Pengaduan Pertanian (Retained)
                  Text(
                    'Pengaduan & Aspirasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Layanan penyampaian aspirasi & keluhan pertanian Bojonegoro:',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withAlpha(isDark ? 25 : 10),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: _openPengaduanPertanian,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Soft Blue Icon Box
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0284C7).withAlpha(isDark ? 40 : 18),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF0284C7).withAlpha(30), width: 1.0),
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  color: Color(0xFF0284C7),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0284C7).withAlpha(isDark ? 35 : 15),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: const Color(0xFF0284C7).withAlpha(30), width: 1.0),
                                      ),
                                      child: const Text(
                                        'PENGADUAN PERTANIAN',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0284C7),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Pengaduan Pertanian',
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Sampaikan aspirasi, keluhan kendala distribusi pupuk, serangan hama tanaman, atau laporan perbaikan irigasi pertanian Bojonegoro.',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Subtle Compact Circular Arrow Button (28px circle, 14px icon)
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0284C7).withAlpha(isDark ? 35 : 15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF0284C7).withAlpha(30),
                                    width: 1.0,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Color(0xFF0284C7),
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 4. Informasi & Fitur Tambahan (List Menu style retained with dividers)
                  Text(
                    'Informasi & Fitur Tambahan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Portal resmi & data komoditas pangan Bojonegoro:',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 1.0),
                    ),
                    child: Column(
                      children: [
                        _buildListItem(
                          context: context,
                          isDark: isDark,
                          title: 'Harga Komoditas',
                          subtitle: 'Pantau harga gabah & beras di Bojonegoro',
                          icon: Icons.analytics_outlined,
                          onTap: () => _openWebUrl('https://disdag-online.bojonegorokab.go.id/trend/tabel'),
                        ),
                        Divider(height: 1, thickness: 1, color: borderColor),
                        _buildListItem(
                          context: context,
                          isDark: isDark,
                          title: 'Informasi Pertanian',
                          subtitle: 'Informasi dan berita pertanian Bojonegoro',
                          icon: Icons.newspaper_outlined,
                          onTap: () => _openWebUrl('https://dinperta.bojonegorokab.go.id/'),
                        ),
                        Divider(height: 1, thickness: 1, color: borderColor),
                        _buildListItem(
                          context: context,
                          isDark: isDark,
                          title: 'Jadwal & Informasi',
                          subtitle: 'Informasi kegiatan & program DKPP',
                          icon: Icons.calendar_today_outlined,
                          onTap: () => _openWebUrl('https://dinperta.bojonegorokab.go.id/'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required BuildContext context,
    required bool isDark,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
