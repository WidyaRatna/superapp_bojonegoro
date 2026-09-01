import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/superapp_header.dart';

class BansosTerpaduDetailScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const BansosTerpaduDetailScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<BansosTerpaduDetailScreen> createState() => _BansosTerpaduDetailScreenState();
}

class _BansosTerpaduDetailScreenState extends State<BansosTerpaduDetailScreen> {
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
        SnackBar(content: Text('Membuka dokumen ($formattedUrl)...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Bantuan Sosial Terpadu',
            subtitle: 'Dinas Sosial Kabupaten Bojonegoro',
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),

          // Content Body
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Official Portal Info Banner Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: isDark
                              ? const LinearGradient(
                                  colors: [Color(0xFF0F2B66), Color(0xFF1E3A8A)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : const LinearGradient(
                                  colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? const Color(0xFF3B82F6).withAlpha(80) : const Color(0xFF93C5FD),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D62F1).withAlpha(isDark ? 50 : 25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.language_rounded,
                                    color: Color(0xFF0D62F1),
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Portal Resmi Bantuan Sosial',
                                        style: TextStyle(
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Info selengkapnya mengenai Bantuan Sosial Dinas Sosial Kab. Bojonegoro dapat dicek di sini.',
                                        style: TextStyle(
                                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                          fontSize: 12,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () => _openWebUrl('https://dinsos.bojonegorokab.go.id/menu/detail/48/BANTUANSOSIAL'),
                                icon: const Icon(Icons.open_in_new_rounded, size: 14, color: Colors.white),
                                label: const Text(
                                  'Cek Disini',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D62F1),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section Title: Program Bantuan Utama
                      Text(
                        'Program Bantuan Sosial Utama',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),

                      _buildProgramCard(
                        title: '1. Program Keluarga Harapan (PKH)',
                        badge: 'Bantuan Tunai Bersyarat',
                        description:
                            'Program pemberian bantuan sosial bersyarat kepada Keluarga Miskin (KM) yang ditetapkan sebagai keluarga penerima manfaat PKH untuk akses kesehatan, pendidikan, dan kesejahteraan sosial.',
                        icon: Icons.family_restroom_rounded,
                        color: const Color(0xFF0D62F1),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),

                      _buildProgramCard(
                        title: '2. Bantuan Pangan Non-Tunai (BPNT / Sembako)',
                        badge: 'Bantuan Pangan Rutin',
                        description:
                            'Bantuan sosial pangan yang disalurkan dalam bentuk tunai/non-tunai secara berkala untuk pemenuhan gizi pokok (beras, telur, dan komoditas pangan esensial) warga Bojonegoro.',
                        icon: Icons.shopping_bag_rounded,
                        color: const Color(0xFF059669),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),

                      _buildProgramCard(
                        title: '3. Data Terpadu Kesejahteraan Sosial (DTKS)',
                        badge: 'Basis Data Nasional',
                        description:
                            'Data induk yang berisi data pemerlu pelayanan kesejahteraan sosial, penerima bantuan dan pemberdayaan sosial, serta potensi dan sumber kesejahteraan sosial Kabupaten Bojonegoro.',
                        icon: Icons.dataset_rounded,
                        color: const Color(0xFFD97706),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 28),

                      // ==========================================
                      // SECTION: JUKNIS BANTUAN SOSIAL
                      // ==========================================
                      Text(
                        'Petunjuk Teknis (Juknis) Bantuan Sosial',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dokumen resmi petunjuk teknis pelaksanaan bantuan sosial Dinas Sosial Kab. Bojonegoro:',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildDocumentTile(
                        title: 'Juknis Bantuan Sosial Anak Yatim',
                        category: 'Petunjuk Teknis Resmi',
                        url: 'https://drive.google.com/file/d/1rtMnX3pSlVIvITL3FgOYwASePOJ32aoY/view?usp=sharing',
                        icon: Icons.picture_as_pdf_rounded,
                        color: const Color(0xFF0D62F1),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),

                      _buildDocumentTile(
                        title: 'Juknis Bantuan Sosial BPNT Daerah',
                        category: 'Petunjuk Teknis Resmi',
                        url: 'https://drive.google.com/file/d/12AOTyYFM4od2oi0S25QKdJGWiMlqs7ko/view?usp=sharing',
                        icon: Icons.picture_as_pdf_rounded,
                        color: const Color(0xFF059669),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),

                      _buildDocumentTile(
                        title: 'Juknis Bantuan Sosial Penyandang Cacat Berat',
                        category: 'Petunjuk Teknis Resmi',
                        url: 'https://drive.google.com/file/d/1ar4x-Bq3b9uPD9izjeuJJ566N6lu7xe4/view?usp=sharing',
                        icon: Icons.picture_as_pdf_rounded,
                        color: const Color(0xFF7C3AED),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),

                      _buildDocumentTile(
                        title: 'Juknis Bantuan Sosial Penyakit Kronis',
                        category: 'Petunjuk Teknis Resmi',
                        url: 'https://drive.google.com/file/d/18RXShIue_tHcO2hW6FQbykeX19wH6wpA/view?usp=sharing',
                        icon: Icons.picture_as_pdf_rounded,
                        color: const Color(0xFFEF4444),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 28),

                      // ==========================================
                      // SECTION: REKAP DATA DINAS SOSIAL
                      // ==========================================
                      Text(
                        'Rekap Data Dinas Sosial',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Laporan & rekapitulasi data kependudukan dan kesejahteraan sosial:',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildDocumentTile(
                        title: 'Rekap Data DTKS Bojonegoro',
                        category: 'Rekapitulasi Data Induk',
                        url: 'https://drive.google.com/file/d/1p__OCImFd7IzR1AmihGUUvIOyIyNodo8/view?usp=sharing',
                        icon: Icons.analytics_rounded,
                        color: const Color(0xFFD97706),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),

                      _buildDocumentTile(
                        title: 'Rekap Data PMKS (Pemerlu Pelayanan Kesejahteraan Sosial)',
                        category: 'Rekapitulasi Data PMKS',
                        url: 'https://drive.google.com/file/d/1kkXIRmjOkUtrRdTW-wjpyguf0XO3LoxS/view?usp=sharing',
                        icon: Icons.bar_chart_rounded,
                        color: const Color(0xFF0284C7),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),

                      _buildDocumentTile(
                        title: 'Rekap Data Kemiskinan Ekstrim',
                        category: 'Rekapitulasi Penanggulangan Kemiskinan',
                        url: 'https://drive.google.com/file/d/1E4OtqBNknV-AwohlAXg0-ISinCMfLGMc/view?usp=sharing',
                        icon: Icons.pie_chart_rounded,
                        color: const Color(0xFFEA580C),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 28),

                      // ==========================================
                      // SECTION: TUTORIAL PENGGUNAAN APLIKASI CEK BANSOS
                      // ==========================================
                      Text(
                        'Tutorial Aplikasi Cek Bansos Kemensos RI',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Panduan dan tata cara penggunaan aplikasi resmi Cek Bansos:',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildDocumentTile(
                        title: 'Tutorial Penggunaan Aplikasi Cek Bansos (Video)',
                        category: 'Panduan Video Tutorial',
                        url: 'https://drive.google.com/file/d/162qZAZX90hTFp21n7LQY-BZimZH6NX0g/view?usp=sharing',
                        icon: Icons.video_library_rounded,
                        color: const Color(0xFFDC2626),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),

                      _buildDocumentTile(
                        title: 'Tutorial Penggunaan Aplikasi Cek Bansos (Gambar / Infografis)',
                        category: 'Panduan Gambar Infografis',
                        url: 'https://drive.google.com/file/d/1uhPeHf2NfWM4sBKjbKRyzqbgRsB80F6e/view?usp=sharing',
                        icon: Icons.image_rounded,
                        color: const Color(0xFF4F46E5),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 28),

                      // ==========================================
                      // SECTION: REKAP PENERIMA BANSOS DINSOS
                      // ==========================================
                      Text(
                        'Rekap Penerima Bansos Dinas Sosial',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Daftar penerima bantuan sosial Dinas Sosial Kabupaten Bojonegoro:',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildDocumentTile(
                        title: 'Rekap Data Penerima Bansos Dinas Sosial Kab. Bojonegoro',
                        category: 'Data Laporan Penerima',
                        url: 'https://drive.google.com/file/d/17uZm7hhzYtcvCMfLjN7zILHd8i5vM3dj/view?usp=sharing',
                        icon: Icons.table_view_rounded,
                        color: const Color(0xFF16A34A),
                        isDark: isDark,
                      ),

                      const SizedBox(height: 30),
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

  Widget _buildProgramCard({
    required String title,
    required String badge,
    required String description,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withAlpha(20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
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
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTile({
    required String title,
    required String category,
    required String url,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => _openWebUrl(url),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withAlpha(isDark ? 35 : 20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: color.withAlpha(isDark ? 30 : 15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Buka Document',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.open_in_new_rounded, size: 13, color: color),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

