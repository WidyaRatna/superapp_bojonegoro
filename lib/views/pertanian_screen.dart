import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
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
    final isDark = widget.isDarkMode;
    final double topPadding = MediaQuery.of(context).padding.top;

    // Color Palette
    final primaryGreen = isDark ? const Color(0xFF22C55E) : const Color(0xFF16834A);
    final darkGreen = isDark ? const Color(0xFF0D4726) : const Color(0xFF12663A);
    final softGreen = isDark ? const Color(0xFF0F2E1E) : const Color(0xFFEAF5EE);
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F9F8);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textMain = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF172033);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF667085);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE3E8E5);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Height ~130px, distinctive pattern)
            Stack(
              children: [
                Container(
                  height: 130 + (topPadding > 0 ? topPadding : 16),
                  width: double.infinity,
                  color: darkGreen,
                  child: CustomPaint(
                    painter: _HeaderPatternPainter(
                      color: Colors.white.withAlpha(12),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Container(
                    height: 110,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'Layanan Pertanian',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'DKPP Kab. Bojonegoro',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFD1FAE5),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.onToggleDarkMode != null)
                              IconButton(
                                icon: Icon(
                                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                onPressed: widget.onToggleDarkMode,
                                tooltip: 'Ganti Tema',
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Main Content Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Informasi Dinas (Profil singkat instansi - Editorial layout)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.agriculture_outlined,
                            color: primaryGreen,
                            size: 22,
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
                                  fontWeight: FontWeight.w600,
                                  color: textMain,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Jl. Ahmad Yani No. 24, Bojonegoro',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () => _openWebUrl('https://dinpertan.bojonegorokab.go.id/'),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'dinpertan.bojonegorokab.go.id',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w500,
                                        color: primaryGreen,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_outward_rounded,
                                      color: primaryGreen,
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. Featured Service: Pupuk Bersubsidi
                  Text(
                    'Layanan Utama',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: softGreen,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF166534) : const Color(0xFFC2E7D0),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: primaryGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pupuk Bersubsidi',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: textMain,
                                    ),
                                  ),
                                  Text(
                                    'Layanan Utama DKPP',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: primaryGreen,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Informasi e-RDKK 2025–2026, status alokasi penerima pupuk bersubsidi, syarat kelayakan, serta tata cara penebusan resmi di KPL.',
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.45,
                            color: textMain.withAlpha(220),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: _openPupukBersubsidi,
                          borderRadius: BorderRadius.circular(8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Buka layanan',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: primaryGreen,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: primaryGreen,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Secondary Service: Pengaduan Pertanian
                  Text(
                    'Pengaduan & Aspirasi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  InkWell(
                    onTap: _openPengaduanPertanian,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Pengaduan Pertanian',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: textMain,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: textSecondary,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sampaikan aspirasi, keluhan kendala distribusi pupuk, serangan hama tanaman, atau laporan perbaikan irigasi pertanian Bojonegoro.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 5. Informasi & Fitur Tambahan (List Menu style with dividers)
                  Text(
                    'Informasi & Fitur Tambahan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: Column(
                      children: [
                        _buildListItem(
                          context: context,
                          isDark: isDark,
                          title: 'Harga Komoditas',
                          subtitle: 'Pantau harga gabah & beras di Bojonegoro',
                          icon: Icons.analytics_outlined,
                          textMain: textMain,
                          textSecondary: textSecondary,
                          onTap: () => _openWebUrl('https://disdag-online.bojonegorokab.go.id/trend/tabel'),
                        ),
                        Divider(height: 1, thickness: 1, color: borderColor),
                        _buildListItem(
                          context: context,
                          isDark: isDark,
                          title: 'Informasi Pertanian',
                          subtitle: 'Informasi dan berita pertanian Bojonegoro',
                          icon: Icons.newspaper_outlined,
                          textMain: textMain,
                          textSecondary: textSecondary,
                          onTap: () => _openWebUrl('https://dinpertan.bojonegorokab.go.id/'),
                        ),
                        Divider(height: 1, thickness: 1, color: borderColor),
                        _buildListItem(
                          context: context,
                          isDark: isDark,
                          title: 'Jadwal & Informasi',
                          subtitle: 'Informasi kegiatan & program DKPP',
                          icon: Icons.calendar_today_outlined,
                          textMain: textMain,
                          textSecondary: textSecondary,
                          onTap: () => _openWebUrl('https://dinpertan.bojonegorokab.go.id/'),
                        ),
                      ],
                    ),
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

  Widget _buildListItem({
    required BuildContext context,
    required bool isDark,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color textMain,
    required Color textSecondary,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
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
                      fontWeight: FontWeight.w600,
                      color: textMain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderPatternPainter extends CustomPainter {
  final Color color;
  _HeaderPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (double i = -size.height; i < size.width + size.height; i += 24) {
      path.moveTo(i, 0);
      path.lineTo(i + size.height, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
