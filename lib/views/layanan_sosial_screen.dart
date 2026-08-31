import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../widgets/superapp_header.dart';
import 'bansos_terpadu_detail_screen.dart';
import 'persyaratan_pelayanan_publik_screen.dart';
import 'news_screen.dart';
import '../widgets/auth_guard.dart';

class LayananSosialScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const LayananSosialScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<LayananSosialScreen> createState() => _LayananSosialScreenState();
}

class _LayananSosialScreenState extends State<LayananSosialScreen> {
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
        SnackBar(content: Text('Membuka website ($formattedUrl)...')),
      );
    }
  }

  void _openPermohonanRumahSinggah() {
    AuthGuard.requireLogin(
      context,
      serviceName: 'Permohonan Rekomendasi Rumah Singgah',
      isDarkMode: widget.isDarkMode,
      onToggleDarkMode: widget.onToggleDarkMode,
      onAuthenticated: () {
        _openWebUrl('https://rumahsinggahbjn.com/rumahSG.html');
      },
    );
  }

  void _openKritikSaran() {
    AuthGuard.requireLogin(
      context,
      serviceName: 'Formulir Kritik & Saran Layanan Sosial',
      isDarkMode: widget.isDarkMode,
      onToggleDarkMode: widget.onToggleDarkMode,
      onAuthenticated: () {
        _openWebUrl('https://rumahsinggahbjn.com/kritik&saran/index.html');
      },
    );
  }

  void _openBansosTerpadu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BansosTerpaduDetailScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openPersyaratanPelayananPublik() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersyaratanPelayananPublikScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openBeritaTerkini() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsScreen(
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    // Palette definition consistent with SuperApp Bojonegoro (e.g. Perhubungan / Pertanian)
    final bgColor = isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textMain = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final primaryBlue = isDark ? const Color(0xFF3B82F6) : const Color(0xFF0D62F1);
    final headerGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF071B36), Color(0xFF0F2B66)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0052D4), Color(0xFF0D62F1)],
          );

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Layanan Sosial',
            subtitle: 'Dinas Sosial Kabupaten Bojonegoro',
            gradient: headerGradient,
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),

          // 2. Scrollable Body Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==========================================
                      // SECTION 1: LAYANAN KAMI (2 Main Services)
                      // ==========================================
                      _buildSectionHeader('Layanan Kami', textMain, textSecondary),
                      const SizedBox(height: 12),

                      _buildMainServiceItem(
                        title: 'Permohonan Surat Rumah Singgah',
                        description:
                            'Pengajuan surat rekomendasi penggunaan layanan rumah singgah Dinas Sosial Kabupaten Bojonegoro.',
                        buttonText: 'Ajukan Sekarang',
                        icon: Icons.house_outlined,
                        primaryColor: primaryBlue,
                        cardBgColor: cardBgColor,
                        borderColor: borderColor,
                        textMain: textMain,
                        textSecondary: textSecondary,
                        isDark: isDark,
                        onTap: _openPermohonanRumahSinggah,
                      ),
                      const SizedBox(height: 10),

                      _buildMainServiceItem(
                        title: 'Masukan, Kritik dan Saran',
                        description:
                            'Fasilitas bagi masyarakat untuk menyampaikan kritik, saran, atau masukan terkait pelayanan.',
                        buttonText: 'Kirim Masukan',
                        icon: Icons.rate_review_outlined,
                        primaryColor: primaryBlue,
                        cardBgColor: cardBgColor,
                        borderColor: borderColor,
                        textMain: textMain,
                        textSecondary: textSecondary,
                        isDark: isDark,
                        onTap: _openKritikSaran,
                      ),

                      const SizedBox(height: 24),

                      // ==========================================
                      // SECTION 2: LAYANAN UNGGULAN (Compact List)
                      // ==========================================
                      _buildSectionHeader('Layanan Unggulan', textMain, textSecondary),
                      const SizedBox(height: 12),

                      Container(
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: Column(
                          children: [
                            _buildCompactServiceTile(
                              title: 'Bantuan Sosial Terpadu',
                              description:
                                  'Informasi dan tata cara pengajuan PKH, BPNT, serta DTKS Kemensos.',
                              actionText: 'Lihat Layanan',
                              icon: Icons.volunteer_activism_outlined,
                              primaryColor: primaryBlue,
                              textMain: textMain,
                              textSecondary: textSecondary,
                              isDark: isDark,
                              onTap: _openBansosTerpadu,
                            ),
                            Divider(height: 1, color: borderColor),
                            _buildCompactServiceTile(
                              title: 'Persyaratan Pelayanan Publik',
                              description:
                                  'Informasi standar pelayanan publik dan dokumen persyaratan administrasi.',
                              actionText: 'Info Detail',
                              icon: Icons.assignment_outlined,
                              primaryColor: primaryBlue,
                              textMain: textMain,
                              textSecondary: textSecondary,
                              isDark: isDark,
                              onTap: _openPersyaratanPelayananPublik,
                            ),
                            Divider(height: 1, color: borderColor),
                            _buildCompactServiceTile(
                              title: 'Berita Terkini',
                              description:
                                  'Informasi dan pengumuman kegiatan terbaru Dinas Sosial Kabupaten Bojonegoro.',
                              actionText: 'Lihat Berita',
                              icon: Icons.newspaper_outlined,
                              primaryColor: primaryBlue,
                              textMain: textMain,
                              textSecondary: textSecondary,
                              isDark: isDark,
                              onTap: _openBeritaTerkini,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Header Title
  Widget _buildSectionHeader(String title, Color textMain, Color textSecondary) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: textMain,
        letterSpacing: -0.2,
      ),
    );
  }

  // Compact Main Service Card Layout for Section 1 ("Layanan Kami")
  Widget _buildMainServiceItem({
    required String title,
    required String description,
    required String buttonText,
    required IconData icon,
    required Color primaryColor,
    required Color cardBgColor,
    required Color borderColor,
    required Color textMain,
    required Color textSecondary,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Soft Tint Icon Container
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(isDark ? 35 : 20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),

                // Title & Description Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textMain,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Right Action Button
                InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha(isDark ? 30 : 15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          buttonText,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Compact Tile Item Layout for Section 2 ("Layanan Unggulan")
  Widget _buildCompactServiceTile({
    required String title,
    required String description,
    required String actionText,
    required IconData icon,
    required Color primaryColor,
    required Color textMain,
    required Color textSecondary,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Icon Badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha(isDark ? 30 : 15),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 19,
                ),
              ),
              const SizedBox(width: 12),

              // Title and Short Desc
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
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Action Text + Arrow Icon (Identical to Top Cards)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha(isDark ? 30 : 15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionText,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
