import 'package:flutter/material.dart';
import '../widgets/superapp_header.dart';

class PersyaratanPelayananPublikScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const PersyaratanPelayananPublikScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<PersyaratanPelayananPublikScreen> createState() => _PersyaratanPelayananPublikScreenState();
}

class _PersyaratanPelayananPublikScreenState extends State<PersyaratanPelayananPublikScreen> {
  int _expandedIndex = 0;

  final List<Map<String, dynamic>> _serviceRequirements = [
    {
      'title': '1. Permohonan Rekomendasi Rumah Singgah',
      'icon': Icons.house_rounded,
      'color': const Color(0xFF0D62F1),
      'requirements': [
        'Fotokopi KTP & Kartu Keluarga (KK) Pemohon / Pasien.',
        'Surat Rujukan Medis / Rekomendasi Dinas/Faskes (jika untuk keandalan rujukan pengobatan).',
        'Surat Keterangan Tidak Mampu (SKTM) dari Desa / Kelurahan setempat.',
        'Surat Pengantar Permohonan dari Dinas Sosial Kabupaten Bojonegoro.',
      ],
      'waktu': '1 Hari Kerja',
      'biaya': 'Gratis (Rp 0)',
    },
    {
      'title': '2. Surat Rekomendasi Keringanan Biaya (Kesehatan / Pendidikan)',
      'icon': Icons.assignment_turned_in_rounded,
      'color': const Color(0xFF059669),
      'requirements': [
        'Fotokopi KTP & KK yang bersangkutan.',
        'Surat Keterangan Tidak Mampu (SKTM) aktif dari Desa / Kelurahan.',
        'Surat Keterangan Rawat Inap / Tagihan Faskes (untuk pemohon kesehatan).',
        'Bukti Terdaftar / Pengantar DTKS dari Operator Desa.',
      ],
      'waktu': '1 - 2 Hari Kerja',
      'biaya': 'Gratis (Rp 0)',
    },
    {
      'title': '3. Permohonan Alat Bantu Bagi Penyandang Disabilitas',
      'icon': Icons.accessible_rounded,
      'color': const Color(0xFFD97706),
      'requirements': [
        'Fotokopi KTP & KK Pemohon (Disabilitas).',
        'Surat Keterangan Disabilitas dari Puskesmas / Dokter / RSUD.',
        'Foto seluruh badan calon penerima alat bantu.',
        'Surat Permohonan dari Kepala Desa / Lurah yang ditujukan kepada Kepala Dinas Sosial Bojonegoro.',
      ],
      'waktu': 'Proses Verifikasi & Pendataan',
      'biaya': 'Gratis (Rp 0)',
    },
    {
      'title': '4. Rekomendasi Pendaftaran Lembaga Kesejahteraan Sosial (LKS)',
      'icon': Icons.corporate_fare_rounded,
      'color': const Color(0xFF7C3AED),
      'requirements': [
        'Surat Pengajuan Rekomendasi dari Pengurus LKS / Yayasan.',
        'Fotokopi Akta Notaris Pendirian & SK Kemenkumham LKS.',
        'Struktur Organisasi & Susunan Pengurus LKS.',
        'Profil Singkat & Laporan Kegiatan Kesejahteraan Sosial LKS.',
      ],
      'waktu': '3 - 5 Hari Kerja',
      'biaya': 'Gratis (Rp 0)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Persyaratan Pelayanan Publik',
            subtitle: 'Dinas Sosial Kabupaten Bojonegoro',
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),

          // Content List
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
                      // Top Guarantee Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.verified_user_rounded,
                                color: Color(0xFF10B981),
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Standar Layanan Bebas Pungli (Rp 0)',
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Seluruh pelayanan publik di lingkungan Dinas Sosial Kabupaten Bojonegoro tidak dipungut biaya apapun.',
                                    style: TextStyle(
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'Daftar Persyaratan Berdasarkan Jenis Layanan',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Requirements List Expansion / Cards
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _serviceRequirements.length,
                        itemBuilder: (context, index) {
                          final item = _serviceRequirements[index];
                          final isExpanded = _expandedIndex == index;
                          final IconData icon = item['icon'];
                          final Color color = item['color'];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isExpanded
                                    ? color
                                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                width: isExpanded ? 1.5 : 1,
                              ),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                key: Key('expansion_$index'),
                                initiallyExpanded: index == 0,
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: color.withAlpha(25),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(icon, color: color, size: 22),
                                ),
                                title: Text(
                                  item['title'],
                                  style: TextStyle(
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onExpansionChanged: (expanded) {
                                  if (expanded) {
                                    setState(() {
                                      _expandedIndex = index;
                                    });
                                  }
                                },
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(height: 1),
                                        const SizedBox(height: 12),

                                        Row(
                                          children: [
                                            _buildBadge('Estimasi Waktu: ${item['waktu']}', const Color(0xFF0D62F1), isDark),
                                            const SizedBox(width: 8),
                                            _buildBadge('Biaya: ${item['biaya']}', const Color(0xFF10B981), isDark),
                                          ],
                                        ),
                                        const SizedBox(height: 12),

                                        Text(
                                          'Dokumen Persyaratan:',
                                          style: TextStyle(
                                            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        Column(
                                          children: (item['requirements'] as List<String>).map((req) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 6),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.check_circle_outline_rounded,
                                                    color: Color(0xFF0D62F1),
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      req,
                                                      style: TextStyle(
                                                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                                        fontSize: 12.5,
                                                        height: 1.3,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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

  Widget _buildBadge(String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
