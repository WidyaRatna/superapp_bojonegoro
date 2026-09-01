import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PupukBersubsidiScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const PupukBersubsidiScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<PupukBersubsidiScreen> createState() => _PupukBersubsidiScreenState();
}

class _PupukBersubsidiScreenState extends State<PupukBersubsidiScreen> {
  // External URL Helper with Windows Fallback & Error Handling
  Future<void> _openExternalUrl(String urlStr, String labelName) async {
    final Uri url = Uri.parse(urlStr.trim());
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!kIsWeb) {
      try {
        if (Platform.isWindows) {
          await Process.run('cmd', ['/c', 'start', '', urlStr.trim()]);
          return;
        }
      } catch (_) {}
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membuka portal $labelName ($urlStr)...'),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
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
                                'Pupuk Bersubsidi',
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
                  // Deskripsi Singkat Layanan
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(isDark ? 30 : 10),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669).withAlpha(20),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.eco_rounded,
                            color: Color(0xFF059669),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Layanan Resmi Pupuk Bersubsidi',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Pintu akses informasi dan layanan resmi pupuk bersubsidi bagi masyarakat dan petani Kabupaten Bojonegoro.',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  height: 1.4,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Section Subtitle
                  Text(
                    'AKSES LAYANAN UTAMA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Card 1: Cek Subsidi Pupuk
                  _buildServiceCard(
                    isDark: isDark,
                    title: 'Cek Subsidi Pupuk',
                    description: 'Cek informasi penerima pupuk bersubsidi.',
                    buttonText: 'Cek Sekarang',
                    icon: Icons.search_rounded,
                    badgeText: 'Portal Resmi Kementan',
                    badgeColor: const Color(0xFF0284C7),
                    onTap: () => _openExternalUrl(
                      'https://pupukbersubsidi.pertanian.go.id/ceksubsidi/search',
                      'Cek Subsidi Pupuk',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Card 2: e-RDKK 2025–2026
                  _buildServiceCard(
                    isDark: isDark,
                    title: 'e-RDKK 2025–2026',
                    description: 'Akses layanan e-RDKK untuk kebutuhan pupuk bersubsidi.',
                    buttonText: 'Buka Layanan',
                    icon: Icons.space_dashboard_rounded,
                    badgeText: 'Alokasi & RDKK',
                    badgeColor: const Color(0xFF059669),
                    onTap: () => _openExternalUrl(
                      'https://erdkk25.pertanian.go.id/',
                      'e-RDKK 2025–2026',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section Informasi Pupuk Bersubsidi
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: Color(0xFF059669),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Informasi Pupuk Bersubsidi',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Info items list
                  _buildInfoExpandableCard(
                    isDark: isDark,
                    title: 'Jenis Pupuk Bersubsidi',
                    icon: Icons.inventory_2_rounded,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _BulletText('Urea: Pupuk Nitrogen untuk pertumbuhan vegetatif tanaman.'),
                        _BulletText('NPK: Pupuk majemuk seimbang (Nitrogen, Phospat, Kalium).'),
                        _BulletText('NPK Formula Khusus: Khusus alokasi komoditas kakao.'),
                        _BulletText('Pupuk Organik: Untuk perbaikan struktur & kesuburan tanah.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildInfoExpandableCard(
                    isDark: isDark,
                    title: 'Syarat Penerima Pupuk Bersubsidi',
                    icon: Icons.verified_user_rounded,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _BulletText('Terdaftar dalam e-RDKK & SIMLUHTAN Kementan RI.'),
                        _BulletText('Tergabung dalam Kelompok Tani (Poktan) setempat.'),
                        _BulletText('Mengusahakan lahan maksimal 2 (dua) Hektar per musim tanam.'),
                        _BulletText('Memiliki Kartu Tani / e-KTP terverifikasi di Kios Resmi.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildInfoExpandableCard(
                    isDark: isDark,
                    title: 'Mekanisme Penebusan',
                    icon: Icons.shopping_bag_rounded,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _BulletText('1. Datang ke Kios Pupuk Lengkap (KPL) resmi di wilayah domisili kelompok.'),
                        _BulletText('2. Tunjukkan KTP Asli / Kartu Tani kepada petugas KPL.'),
                        _BulletText('3. Petugas mengonfirmasi NIK & sisa alokasi kuota pupuk pada aplikasi e-Pubers.'),
                        _BulletText('4. Petani membayar sesuai Harga Eceran Tertinggi (HET) dan menerima bukti resmi.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildInfoExpandableCard(
                    isDark: isDark,
                    title: 'Informasi Umum & HET Resmi',
                    icon: Icons.gavel_rounded,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _BulletText('HET Urea: Rp 2.250 / kg.'),
                        _BulletText('HET NPK: Rp 2.300 / kg.'),
                        _BulletText('HET NPK Kakao: Rp 3.300 / kg.'),
                        _BulletText('HET Pupuk Organik: Rp 800 / kg.'),
                        _BulletText('Penjualan di atas HET adalah pelanggaran hukum. Laporkan via pengaduan DKPP jika ada ketidaksesuaian.'),
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

  Widget _buildServiceCard({
    required bool isDark,
    required String title,
    required String description,
    required String buttonText,
    required IconData icon,
    required String badgeText,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withAlpha(isDark ? 20 : 25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: badgeColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: badgeColor, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: badgeColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: badgeColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: onTap,
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoExpandableCard({
    required bool isDark,
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
          iconColor: const Color(0xFF059669),
          collapsedIconColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          leading: Icon(icon, color: const Color(0xFF059669), size: 20),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: content,
            ),
          ],
        ),
      ),
    ),
  );
}
}

class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669))),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
