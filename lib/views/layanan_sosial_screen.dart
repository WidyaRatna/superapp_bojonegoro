import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../widgets/superapp_header.dart';
import '../services/admin_data_service.dart';
import 'bansos_terpadu_detail_screen.dart';
import 'persyaratan_pelayanan_publik_screen.dart';

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
 
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

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

    return AnimatedBuilder(
      animation: AdminDataService(),
      builder: (context, _) {
        final items = AdminDataService().layananSosialList.where((e) => e.id != 'SOS-003' && e.id != 'SOS-004').toList();

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
                          // SECTION 1: LAYANAN UNGGULAN (Compact List)
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
                              children: items.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                final isFirst = index == 0;

                                VoidCallback onTapAction;
                                if (item.id == 'SOS-001') {
                                  onTapAction = _openBansosTerpadu;
                                } else if (item.id == 'SOS-002') {
                                  onTapAction = _openPersyaratanPelayananPublik;
                                } else {
                                  onTapAction = () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Membuka detail "${item.title}"...')),
                                    );
                                  };
                                }

                                return Column(
                                  children: [
                                    if (!isFirst) Divider(height: 1, color: borderColor),
                                    _buildCompactServiceTile(
                                      title: item.title,
                                      description: item.description,
                                      actionText: item.id == 'SOS-002' ? 'Info Detail' : 'Lihat Layanan',
                                      icon: item.id == 'SOS-002' ? Icons.assignment_outlined : Icons.volunteer_activism_outlined,
                                      primaryColor: primaryBlue,
                                      textMain: textMain,
                                      textSecondary: textSecondary,
                                      isDark: isDark,
                                      onTap: onTapAction,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ==========================================
                          // SECTION 2: QR CODE DOWNLOAD APLIKASI PPID DINSOS
                          // ==========================================
                          _buildSectionHeader('QR CODE DOWNLOAD APLIKASI PPID DINSOS', textMain, textSecondary),
                          const SizedBox(height: 4),
                          Text(
                            'Layanan Pengelolaan Informasi dan Dokumentasi (PPID) Dinas Sosial Kab. Bojonegoro',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: textSecondary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cardBgColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor, width: 1),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 320),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFF0F172A), width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(isDark ? 40 : 12),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          'assets/images/qr_ppid_dinsos.png',
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 220,
                                              color: Colors.white,
                                              alignment: Alignment.center,
                                              child: const Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.qr_code_2_rounded, size: 110, color: Color(0xFF0F172A)),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'Scan QR PPID Dinsos',
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () => _openWebUrl('https://dinsos.bojonegorokab.go.id/'),
                                  icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                                  label: const Text(
                                    'DOWNLOAD APLIKASI PPID DINSOS',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.3, color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F172A),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
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
      },
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

  // Compact Tile Item Layout for Section 1 ("Layanan Unggulan")
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

              // Action Text + Arrow Icon
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
