import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/superapp_header.dart';
import 'admin_pupuk_bersubsidi_screen.dart';
import 'admin_pengaduan_pertanian_screen.dart';

class AdminPertanianScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminPertanianScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  State<AdminPertanianScreen> createState() => _AdminPertanianScreenState();
}

class _AdminPertanianScreenState extends State<AdminPertanianScreen> {
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

  void _openAdminPupukBersubsidi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminPupukBersubsidiScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openAdminPengaduanPertanian() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminPengaduanPertanianScreen(
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
            subtitle: 'DKPP Kabupaten Bojonegoro (Admin Mode)',
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
                  // 1. Compact Info Box: Dinas Ketahanan Pangan & Pertanian (100% User UI Parity)
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
                            children: const [
                              Text(
                                'dinperta',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: primaryGreen,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
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

                  // 2. Featured Service: Pupuk Bersubsidi Card (100% User UI Parity)
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
                        onTap: _openAdminPupukBersubsidi,
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
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: primaryGreen.withAlpha(isDark ? 35 : 15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'LAYANAN UTAMA DKPP',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: primaryGreen,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0D62F1).withAlpha(isDark ? 40 : 15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'Kelola Data',
                                            style: TextStyle(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0D62F1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Pupuk Bersubsidi',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Informasi e-RDKK 2025–2026, status alokasi penerima pupuk bersubsidi, syarat kelayakan, serta tata cara penebusan resmi di KPL.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.35,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: primaryGreen.withAlpha(isDark ? 30 : 12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: primaryGreen,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. Pengaduan & Aspirasi Card (100% User UI Parity)
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
                        onTap: _openAdminPengaduanPertanian,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Icon Box Container (Soft Blue Pastel)
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0284C7).withAlpha(isDark ? 40 : 18),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF0284C7).withAlpha(30), width: 1.0),
                                ),
                                child: const Icon(
                                  Icons.chat_outlined,
                                  color: Color(0xFF0284C7),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0284C7).withAlpha(isDark ? 35 : 15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'PENGADUAN PERTANIAN',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0284C7),
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0D62F1).withAlpha(isDark ? 40 : 15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'Kelola Aduan',
                                            style: TextStyle(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0D62F1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Pengaduan Pertanian',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Sampaikan aspirasi, keluhan kendala distribusi pupuk, serangan hama tanaman, atau laporan perbaikan irigasi pertanian Bojonegoro.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.35,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0284C7).withAlpha(isDark ? 30 : 12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Color(0xFF0284C7),
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Informasi & Fitur Tambahan (100% User UI Parity)
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
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            leading: const Icon(Icons.insert_chart_outlined_rounded, color: primaryGreen),
                            title: Text(
                              'Harga Komoditas',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                            ),
                            subtitle: const Text('Pantau harga gabah & beras di Bojonegoro', style: TextStyle(fontSize: 11.5)),
                            trailing: const Icon(Icons.chevron_right_rounded, color: primaryGreen),
                            onTap: () => _openWebUrl('https://disdag-online.bojonegorokab.go.id/trend/tabel'),
                          ),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            leading: const Icon(Icons.newspaper_rounded, color: primaryGreen),
                            title: Text(
                              'Informasi Pertanian',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                            ),
                            subtitle: const Text('Informasi dan berita pertanian Bojonegoro', style: TextStyle(fontSize: 11.5)),
                            trailing: const Icon(Icons.chevron_right_rounded, color: primaryGreen),
                            onTap: () => _openWebUrl('https://dinperta.bojonegorokab.go.id/'),
                          ),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            leading: const Icon(Icons.calendar_today_rounded, color: primaryGreen),
                            title: Text(
                              'Jadwal & Informasi',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                            ),
                            subtitle: const Text('Informasi kegiatan & program DKPP', style: TextStyle(fontSize: 11.5)),
                            trailing: const Icon(Icons.chevron_right_rounded, color: primaryGreen),
                            onTap: () => _openWebUrl('https://dinperta.bojonegorokab.go.id/'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
