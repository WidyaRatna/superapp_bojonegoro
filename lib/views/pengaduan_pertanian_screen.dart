import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PengaduanPertanianScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const PengaduanPertanianScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<PengaduanPertanianScreen> createState() => _PengaduanPertanianScreenState();
}

class _PengaduanPertanianScreenState extends State<PengaduanPertanianScreen> {
  static const String _aduanUrl = 'https://aduan-dkppbojonegoro.framer.website/';
  static const String _monitoringUrl =
      'https://script.google.com/macros/s/AKfycbwCiFDLY3BfLAwCYoOoG2iR2pzTMQB4FZAByA-wqayCaLO76ZNjqVgWkTcgsvILlZod/exec';

  // Helper URL launcher with Error Handling
  Future<void> _openWebUrl(String targetUrl, String actionTitle) async {
    final Uri url = Uri.parse(targetUrl.trim());
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!kIsWeb) {
      try {
        if (Platform.isWindows) {
          await Process.run('cmd', ['/c', 'start', '', targetUrl.trim()]);
          return;
        }
      } catch (_) {}
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membuka Portal $actionTitle DKPP Bojonegoro...'),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Bar
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, (topPadding > 0 ? topPadding : 16) + 4, 16, 22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? const [Color(0xFF022C22), Color(0xFF064E3B), Color(0xFF0F172A)]
                      : const [Color(0xFF047857), Color(0xFF059669), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF059669).withAlpha(50),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 4),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pengaduan Pertanian',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              Text(
                                'DKPP Kab. Bojonegoro',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (widget.onToggleDarkMode != null)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(30),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                            color: Colors.white,
                            onPressed: widget.onToggleDarkMode,
                            tooltip: 'Ganti Tema',
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Banner Card for Pengaduan Pertanian
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF059669).withAlpha(isDark ? 20 : 30),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF059669), Color(0xFF10B981)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF059669).withAlpha(40),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.rate_review_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF059669).withAlpha(20),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Aspirasi & Keluhan Petani',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF059669),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Pengaduan Pertanian',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sampaikan aspirasi, keluhan, atau laporan terkait layanan pertanian Kabupaten Bojonegoro.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Main Action Button: "Ajukan Pengaduan"
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF059669),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => _openWebUrl(_aduanUrl, 'Pengaduan'),
                            icon: const Icon(Icons.send_rounded, size: 18),
                            label: const Text(
                              'Ajukan Pengaduan',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Secondary Action Button: "Monitoring Aduan"
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isDark ? const Color(0xFF6EE7B7) : const Color(0xFF059669),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              side: BorderSide(
                                color: isDark ? const Color(0xFF059669) : const Color(0xFF10B981),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () => _openWebUrl(_monitoringUrl, 'Monitoring Aduan'),
                            icon: const Icon(Icons.track_changes_rounded, size: 18),
                            label: const Text(
                              'Monitoring Aduan',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Informasi Kategori Aduan Pertanian
                  Text(
                    'KATEGORI PENGADUAN YANG DAPAT DILAPORKAN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildCategoryCard(
                    isDark: isDark,
                    title: 'Distribusi & Kelangkaan Pupuk Bersubsidi',
                    description: 'Pelaporan ketidaksesuaian HET, kelangkaan stok KPL, atau kendala penebusan e-RDKK.',
                    icon: Icons.inventory_rounded,
                  ),

                  const SizedBox(height: 10),

                  _buildCategoryCard(
                    isDark: isDark,
                    title: 'Serangan Hama & Penyakit Tanaman (OPT)',
                    description: 'Permohonan bantuan pengendalian organisme pengganggu tanaman dari petugas POPT DKPP.',
                    icon: Icons.bug_report_rounded,
                  ),

                  const SizedBox(height: 10),

                  _buildCategoryCard(
                    isDark: isDark,
                    title: 'Saluran Irigasi & Bangunan Pertanian',
                    description: 'Laporan kerusakan jaringan irigasi desa, embung tani, atau jalan usaha tani.',
                    icon: Icons.water_drop_rounded,
                  ),

                  const SizedBox(height: 10),

                  _buildCategoryCard(
                    isDark: isDark,
                    title: 'Bantuan Alat & Mesin Pertanian (Alsintan)',
                    description: 'Aspirasi kelompok tani terkait usulan bantuan traktor, pompanisasi, atau combine harvester.',
                    icon: Icons.precision_manufacturing_rounded,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required bool isDark,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF059669), size: 22),
          const SizedBox(width: 12),
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
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
