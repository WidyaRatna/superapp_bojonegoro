import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../widgets/superapp_header.dart';
import 'package:url_launcher/url_launcher.dart';

class KependudukanScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const KependudukanScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<KependudukanScreen> createState() => _KependudukanScreenState();
}

class _KependudukanScreenState extends State<KependudukanScreen> {
  void _openDataPendudukDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataPendudukDetailScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openPersyaratanLayananDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersyaratanLayananScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Layanan Kependudukan',
            subtitle: 'Disdukcapil Kabupaten Bojonegoro',
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),

            // 2 Main Feature Cards Requested by User
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu Layanan Kependudukan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Silakan pilih layanan informasi kependudukan di bawah ini:',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ITEM 1: Data Jumlah Penduduk
                  _buildMenuCard(
                    icon: Icons.analytics_rounded,
                    color: const Color(0xFF2563EB),
                    badgeText: 'Statistik Demografi',
                    title: 'Data Jumlah Penduduk',
                    subtitle: 'Statistik statistik kependudukan, jumlah KK, gender & sebaran kecamatan Kab. Bojonegoro.',
                    onTap: _openDataPendudukDetail,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 14),

                  // ITEM 2: Persyaratan Layanan
                  _buildMenuCard(
                    icon: Icons.assignment_rounded,
                    color: const Color(0xFF0284C7),
                    badgeText: 'Panduan Dokumen',
                    title: 'Persyaratan Layanan',
                    subtitle: 'Syarat & berkas pengurusan KTP-el, Kartu Keluarga, KIA, Akta Kelahiran & Surat Pindah.',
                    onTap: _openPersyaratanLayananDetail,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required Color color,
    required String badgeText,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(isDark ? 40 : 15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withAlpha(35), color.withAlpha(15)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withAlpha(35), width: 1),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color.withAlpha(30), color.withAlpha(15)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: color.withAlpha(40), width: 1),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withAlpha(210), color],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withAlpha(50),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16,
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

// ==================== SCREEN 1: DATA JUMLAH PENDUDUK ====================
class DataPendudukDetailScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const DataPendudukDetailScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<DataPendudukDetailScreen> createState() => _DataPendudukDetailScreenState();
}

class _DataPendudukDetailScreenState extends State<DataPendudukDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allKecamatan = const [
    {'no': 1, 'nama': 'Ngraho', 'laki': '24.319', 'perempuan': '24.101', 'total': '48.420', 'luas': '71,48 km²', 'kepadatan': '677,39 jiwa/km²'},
    {'no': 2, 'nama': 'Tambakrejo', 'laki': '28.773', 'perempuan': '28.227', 'total': '57.000', 'luas': '209,52 km²', 'kepadatan': '272,05 jiwa/km²'},
    {'no': 3, 'nama': 'Ngambon', 'laki': '6.064', 'perempuan': '5.951', 'total': '12.015', 'luas': '48,65 km²', 'kepadatan': '246,97 jiwa/km²'},
    {'no': 4, 'nama': 'Ngasem', 'laki': '32.072', 'perempuan': '31.060', 'total': '63.132', 'luas': '147,21 km²', 'kepadatan': '428,86 jiwa/km²'},
    {'no': 5, 'nama': 'Bubulan', 'laki': '7.829', 'perempuan': '7.827', 'total': '15.656', 'luas': '84,73 km²', 'kepadatan': '184,78 jiwa/km²'},
    {'no': 6, 'nama': 'Dander', 'laki': '44.264', 'perempuan': '43.762', 'total': '88.026', 'luas': '118,36 km²', 'kepadatan': '743,71 jiwa/km²'},
    {'no': 7, 'nama': 'Sugihwaras', 'laki': '24.113', 'perempuan': '23.849', 'total': '47.962', 'luas': '87,15 km²', 'kepadatan': '550,34 jiwa/km²'},
    {'no': 8, 'nama': 'Kedungadem', 'laki': '42.702', 'perempuan': '42.740', 'total': '85.442', 'luas': '145,15 km²', 'kepadatan': '588,65 jiwa/km²'},
    {'no': 9, 'nama': 'Kepohbaru', 'laki': '34.494', 'perempuan': '33.773', 'total': '68.267', 'luas': '79,64 km²', 'kepadatan': '857,19 jiwa/km²'},
    {'no': 10, 'nama': 'Baureno', 'laki': '43.241', 'perempuan': '42.205', 'total': '85.446', 'luas': '66,37 km²', 'kepadatan': '1.287,42 jiwa/km²'},
    {'no': 11, 'nama': 'Kanor', 'laki': '31.554', 'perempuan': '31.158', 'total': '62.712', 'luas': '59,78 km²', 'kepadatan': '1.049,05 jiwa/km²'},
    {'no': 12, 'nama': 'Sumberrejo', 'laki': '37.044', 'perempuan': '36.773', 'total': '73.817', 'luas': '76,58 km²', 'kepadatan': '963,92 jiwa/km²'},
    {'no': 13, 'nama': 'Balen', 'laki': '34.598', 'perempuan': '34.338', 'total': '68.936', 'luas': '60,52 km²', 'kepadatan': '1.139,06 jiwa/km²'},
    {'no': 14, 'nama': 'Kapas', 'laki': '29.283', 'perempuan': '28.797', 'total': '58.080', 'luas': '46,38 km²', 'kepadatan': '1.252,26 jiwa/km²'},
    {'no': 15, 'nama': 'Bojonegoro', 'laki': '43.527', 'perempuan': '44.820', 'total': '88.347', 'luas': '25,71 km²', 'kepadatan': '3.436,29 jiwa/km²'},
    {'no': 16, 'nama': 'Kalitidu', 'laki': '26.271', 'perempuan': '26.110', 'total': '52.381', 'luas': '65,95 km²', 'kepadatan': '794,25 jiwa/km²'},
    {'no': 17, 'nama': 'Malo', 'laki': '16.350', 'perempuan': '16.327', 'total': '32.677', 'luas': '65,41 km²', 'kepadatan': '499,57 jiwa/km²'},
    {'no': 18, 'nama': 'Purwosari', 'laki': '15.696', 'perempuan': '15.415', 'total': '31.111', 'luas': '62,32 km²', 'kepadatan': '499,21 jiwa/km²'},
    {'no': 19, 'nama': 'Padangan', 'laki': '22.728', 'perempuan': '22.631', 'total': '45.359', 'luas': '42,00 km²', 'kepadatan': '1.079,98 jiwa/km²'},
    {'no': 20, 'nama': 'Kasiman', 'laki': '16.176', 'perempuan': '16.279', 'total': '32.455', 'luas': '51,80 km²', 'kepadatan': '626,54 jiwa/km²'},
    {'no': 21, 'nama': 'Temayang', 'laki': '19.079', 'perempuan': '18.921', 'total': '38.000', 'luas': '124,67 km²', 'kepadatan': '304,80 jiwa/km²'},
    {'no': 22, 'nama': 'Margomulyo', 'laki': '11.630', 'perempuan': '11.779', 'total': '23.409', 'luas': '139,68 km²', 'kepadatan': '167,59 jiwa/km²'},
    {'no': 23, 'nama': 'Trucuk', 'laki': '20.290', 'perempuan': '20.217', 'total': '40.507', 'luas': '36,71 km²', 'kepadatan': '1.103,43 jiwa/km²'},
    {'no': 24, 'nama': 'Sukosewu', 'laki': '22.530', 'perempuan': '22.198', 'total': '44.728', 'luas': '47,48 km²', 'kepadatan': '942,04 jiwa/km²'},
    {'no': 25, 'nama': 'Kedewan', 'laki': '6.890', 'perempuan': '6.997', 'total': '13.887', 'luas': '56,51 km²', 'kepadatan': '245,74 jiwa/km²'},
    {'no': 26, 'nama': 'Gondang', 'laki': '13.693', 'perempuan': '13.088', 'total': '26.781', 'luas': '107,01 km²', 'kepadatan': '250,27 jiwa/km²'},
    {'no': 27, 'nama': 'Sekar', 'laki': '14.681', 'perempuan': '14.280', 'total': '28.961', 'luas': '130,24 km²', 'kepadatan': '222,37 jiwa/km²'},
    {'no': 28, 'nama': 'Gayam', 'laki': '17.295', 'perempuan': '17.171', 'total': '34.466', 'luas': '50,05 km²', 'kepadatan': '688,63 jiwa/km²'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    final filteredList = _allKecamatan.where((item) {
      final name = (item['nama'] as String).toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Data Jumlah Penduduk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Cards (Exact match to official Disdukcapil Bojonegoro)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [Color(0xFF1E3A8A), Color(0xFF1E1B4B)]
                      : const [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withAlpha(60),
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
                      const Text(
                        'KABUPATEN BOJONEGORO',
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Sampai Tahun 2025', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.groups_rounded, color: Colors.white, size: 36),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '1.367.980 Jiwa',
                            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                          ),
                          Text('Total Penduduk Keseluruhan', style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 12.5)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white30),
                  const SizedBox(height: 12),

                  // 3 Grid Stats: Laki-laki, Perempuan, Laju Pertumbuhan
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatSubTile('687.186 Jiwa', 'Laki-Laki', Icons.male_rounded),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatSubTile('680.794 Jiwa', 'Perempuan', Icons.female_rounded),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatSubTile('0,13 %', 'Laju Pertumbuhan', Icons.trending_up_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Search Bar & List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Data Per Kecamatan (${filteredList.length})',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                ),
                Text(
                  '28 Kecamatan',
                  style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Search Field
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Cari nama kecamatan...',
                hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 13.5),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2563EB)),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 28 Kecamatan Cards List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDark ? 30 : 8),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
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
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2563EB).withAlpha(20),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${item['no']}',
                                  style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Kec. ${item['nama']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB).withAlpha(15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${item['total']} Jiwa',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2563EB)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailRow('♂ Laki-laki', '${item['laki']}', isDark),
                          ),
                          Expanded(
                            child: _buildDetailRow('♀ Perempuan', '${item['perempuan']}', isDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailRow('📐 Luas', '${item['luas']}', isDark),
                          ),
                          Expanded(
                            child: _buildDetailRow('🏙️ Kepadatan', '${item['kepadatan']}', isDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatSubTile(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1E293B))),
      ],
    );
  }
}

// ==================== SCREEN 2: PERSYARATAN LAYANAN ====================
class PersyaratanLayananScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const PersyaratanLayananScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  Future<void> _openDashboardWeb(BuildContext context) async {
    const String urlStr = 'https://sites.google.com/view/persyaratanpelayanandukcapil/dashboard';
    final Uri url = Uri.parse(urlStr);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Membuka website dashboard persyaratan Disdukcapil...'),
          backgroundColor: Color(0xFF0284C7),
        ),
      );
    }
  }

  Future<void> _downloadPdfAsset(BuildContext context, String assetPath, String outputName) async {
    try {
      // 1. Read PDF bytes directly from Flutter Asset Bundle
      ByteData? data;
      try {
        data = await rootBundle.load(assetPath);
      } catch (_) {
        if (!kIsWeb) {
          final File localFile = File(assetPath);
          if (localFile.existsSync()) {
            final List<int> bytesFromFile = await localFile.readAsBytes();
            data = ByteData.sublistView(Uint8List.fromList(bytesFromFile));
          }
        }
      }

      if (data == null) {
        throw Exception('File PDF "$outputName" tidak dapat dimuat dari asset ($assetPath).');
      }

      final List<int> bytes = data.buffer.asUint8List();

      // 2. Determine target save directory (Downloads folder or Temp)
      Directory? targetDir;
      try {
        if (!kIsWeb && Platform.isWindows) {
          final String? userProfile = Platform.environment['USERPROFILE'];
          if (userProfile != null) {
            final Directory downloadsDir = Directory('$userProfile\\Downloads');
            if (!downloadsDir.existsSync()) {
              downloadsDir.createSync(recursive: true);
            }
            targetDir = downloadsDir;
          }
        }
      } catch (_) {}
      targetDir ??= Directory.systemTemp;

      // 3. Save the PDF file to disk
      final String savePath = '${targetDir.path}${Platform.pathSeparator}$outputName';
      final File savedFile = File(savePath);
      await savedFile.writeAsBytes(bytes, flush: true);

      // 4. Open the PDF file automatically
      if (!kIsWeb && Platform.isWindows) {
        await Process.run('cmd', ['/c', 'start', '', savePath]);
      } else {
        final Uri fileUri = Uri.file(savePath);
        if (await canLaunchUrl(fileUri)) {
          await launchUrl(fileUri, mode: LaunchMode.externalApplication);
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil mengunduh & membuka $outputName: $savePath'),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunduh PDF: $e'),
            backgroundColor: const Color(0xFFEF4444),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _downloadFormulirF102(BuildContext context) async {
    await _downloadPdfAsset(
      context,
      'assets/dokumen/F-1.02.pdf',
      'Formulir_F-1.02.pdf',
    );
  }

  Future<void> _downloadFormulirF103(BuildContext context) async {
    await _downloadPdfAsset(
      context,
      'assets/dokumen/F-1.03.pdf',
      'Formulir_F-1.03.pdf',
    );
  }

  Future<void> _downloadFormulirF106(BuildContext context) async {
    await _downloadPdfAsset(
      context,
      'assets/dokumen/F-1.06.pdf',
      'Formulir_F-1.06.pdf',
    );
  }

  Future<void> _downloadFormulirF107(BuildContext context) async {
    await _downloadPdfAsset(
      context,
      'assets/dokumen/F-1.07.pdf',
      'Formulir_F-1.07_SuratKuasa.pdf',
    );
  }

  Future<void> _downloadFormulirF201(BuildContext context) async {
    await _downloadPdfAsset(
      context,
      'assets/dokumen/F 2.01.pdf',
      'Formulir_F-2.01.pdf',
    );
  }

  Future<void> _downloadFormulirF203(BuildContext context) async {
    await _downloadPdfAsset(
      context,
      'assets/dokumen/F-2.03.pdf',
      'Formulir_F-2.03_SPTJM_Kelahiran.pdf',
    );
  }

  Future<void> _downloadFormulirF204(BuildContext context) async {
    await _downloadPdfAsset(
      context,
      'assets/dokumen/F-2.04.pdf',
      'Formulir_F-2.04_SPTJM_SuamiIstri.pdf',
    );
  }

  Future<void> _downloadFormulirKIA(BuildContext context) async {
    await _downloadPdfAsset(
      context,
      'assets/dokumen/FORMULIR KIA.pdf',
      'Formulir_Penerbitan_KIA.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || isDarkMode;

    final syarats = [
      {
        'title': 'Persyaratan Kartu Tanda Penduduk (KTP)',
        'icon': Icons.badge_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyaratan-ktp',
        'items': [
          '📌 KTP BAGI PEMULA (BARU):',
          '  • Kartu Tanda Penduduk wajib dimiliki oleh penduduk yang tercatat dalam KK dan telah berusia 17 tahun atau kurang dari 17 tahun tapi sudah menikah.',
          '  • Formulir F-1.02',
          '  • Kartu Keluarga (KK)',
          '  • Tempat Pelayanan: Kantor kecamatan sesuai domisili',
          '',
          '📌 PERSYARATAN KTP RUSAK:',
          '  • Formulir F-1.02',
          '  • Kartu Keluarga (KK)',
          '  • KTP Asli (yang rusak)',
          '',
          '📌 PERSYARATAN KTP HILANG:',
          '  • Formulir F-1.02',
          '  • Kartu Keluarga (KK)',
          '  • Surat Keterangan Kehilangan dari Kepolisian',
        ]
      },
      {
        'title': 'Persyaratan Layanan KIA (Kartu Identitas Anak)',
        'icon': Icons.child_care_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyaratan-kia',
        'hasFormulirKIA': true,
        'items': [
          '📌 SYARAT PENERBITAN KIA:',
          '  • Membawa Fotocopy KTP Orang Tua',
          '  • Membawa Fotocopy Kartu Keluarga (KK) Orang Tua',
          '  • Membawa Fotocopy Akta Kelahiran Anak',
          '  • Formulir Penerbitan KIA (Dapat diunduh via tombol di bawah)',
          '  • Membawa Foto Anak ukuran 2x3 (untuk anak usia 5-16 tahun)',
          '',
          '📌 MANFAAT KIA:',
          '  1. Mencegah Perdagangan Anak',
          '  2. Sebagai Bukti Identifikasi Diri',
          '  3. Memudahkan Dalam Pelayanan Publik',
          '',
          '📍 CATATAN PENGAJUAN:',
          '  Pengajuan Cetak KIA anak dapat dilakukan di Kecamatan maupun di Mall Pelayanan Publik (MPP) Bojonegoro.',
        ]
      },
      {
        'title': 'Persyaratan KK (Kartu Keluarga)',
        'icon': Icons.roofing_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyratan-kk',
        'hasFormulirF102': true,
        'hasFormulirF106': true,
        'hasDownloadIKD': true,
        'items': [
          '📌 PERSYARATAN PERUBAHAN BIODATA PENDUDUK:',
          'Membawa KK asli',
          'Formulir F-1.02 (Unduh via tombol di bawah)',
          'Formulir F-1.06 (Unduh via tombol di bawah)',
          'Membawa data dukung lain (Misal: Buku/Akta Nikah, Akta Cerai, Akta Kematian, Akta Kelahiran, Ijazah, Surat Keputusan/Keterangan bagi Perubahan Pekerjaan PNS/ASN/TNI/POLRI)',
          '',
          '📌 PERSYARATAN PISAH KK:',
          'Membawa KK asli kedua-duanya',
          'Formulir F-1.02 (Unduh via tombol di bawah)',
          'Formulir F-1.06 (jika ada perubahan - Unduh via tombol di bawah)',
          'SKPWNI (Jika Pindah)',
          'Membawa data dukung lain (Misal: Buku Nikah)',
          '',
          '📌 PERSYARATAN PENAMBAHAN / PENGURANGAN ANGGOTA KELUARGA:',
          'Membawa KK asli',
          'Formulir F-1.02 (Unduh via tombol di bawah)',
          'Formulir F-1.06 (Unduh via tombol di bawah)',
          'Membawa data dukung: Surat Keterangan Kelahiran dari Puskesmas atau Rumah Sakit, Surat Kematian dari Desa atau Rumah Sakit, Buku Nikah',
          '',
          '📌 PERSYARATAN NUMPANG KARTU KELUARGA:',
          'Formulir F-1.02 (Unduh via tombol di bawah)',
          'Kartu Keluarga Asal',
          'Kartu Keluarga yang diikuti',
          'Formulir F-1.06 (Unduh via tombol di bawah)',
          'Lampiran Data Dukung (Contoh: Buku/Akta Nikah, Akta Cerai, Akta Kematian, Akta Kelahiran, Surat Pindah)',
          '',
          '📌 PERSYARATAN KARTU KELUARGA RUSAK:',
          'Formulir F-1.02 (Unduh via tombol di bawah)',
          'Kartu Keluarga yang Rusak',
          'Buku Nikah',
          '',
          '📌 PERSYARATAN KARTU KELUARGA HILANG:',
          'Formulir F-1.02 (Unduh via tombol di bawah)',
          'Surat Keterangan Kehilangan dari Kepolisian',
          'Buku Nikah',
          '',
          '📱 DOKUMEN DIGITAL:',
          'Dokumen Digital Kartu Keluarga tersedia dan dapat diakses pada Aplikasi Identitas Kependudukan Digital (IKD) (Unduh via tombol Android / iOS di bawah)',
        ]
      },
      {
        'title': 'Persyaratan IKD (Identitas Kependudukan Digital)',
        'icon': Icons.phone_android_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyaratan-ikd',
        'hasDownloadIKD': true,
        'urlCanvaVideo': 'https://www.canva.com/design/DAF5WgQPEws/watch',
        'items': [
          '📌 PENGERTIAN IKD:',
          'Identitas Kependudukan Digital (IKD) adalah informasi elektronik yang digunakan untuk merepresentasikan dokumen kependudukan dan data balikan dalam aplikasi digital melalui smartphone.',
          '',
          '📌 SYARAT MENDAFTAR IKD:',
          'Memiliki HP Android atau iOS',
          'Memiliki KTP-el Fisik',
          'Memiliki Email dan Nomor Telepon yang Aktif',
          '',
          '📌 AKTIVASI IKD:',
          'Aktivasi IKD dapat dilakukan di Mall Pelayanan Publik (MPP) Bojonegoro dan Kantor Kecamatan.',
          'Cara mendaftar/panduan lengkap dapat dilihat melalui video tutorial via tombol di bawah.',
          'Unduh aplikasi IKD untuk Android (Play Store) atau iOS (App Store) via tombol di bawah.',
        ]
      },
      {
        'title': 'Persyaratan Pindah (SKPWNI)',
        'icon': Icons.directions_car_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyaratan-pindah',
        'hasFormulirF103': true,
        'hasDownloadIKD': true,
        'items': [
          '📌 PERSYARATAN PINDAH DATANG:',
          'Cukup membawa Surat Keterangan Pindah Warga Negara Indonesia (SKPWNI) dari Dukcapil asal.',
          '',
          '📌 PERSYARATAN PINDAH KELUAR:',
          'Membawa Fotokopi KTP',
          'Formulir F-1.03 (Unduh via tombol di bawah)',
          '',
          '📌 SALURAN PERMOHONAN PINDAH PENDUDUK:',
          'Offline (Tatap Muka): Dilayani di Loket Pelayanan Desa / Kelurahan',
          'Online: Dapat diajukan tanpa formulir kertas melalui Aplikasi Identitas Kependudukan Digital (IKD) untuk Pindah Individu dan statusnya bukan Kepala Keluarga',
        ]
      },
      {
        'title': 'Persyaratan Akta Kelahiran',
        'icon': Icons.child_friendly_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyaratan-akta-kelahiran',
        'hasFormulirAktaLahir': true,
        'hasDownloadIKD': true,
        'items': [
          '📌 PERSYARATAN AKTA KELAHIRAN BARU:',
          'Surat Keterangan Kelahiran dari desa / Bidan atau Rumah Sakit',
          'Kartu Keluarga orang tua (dari anak yang akan dibuatkan akta)',
          'KTP-el orang tua dan dua orang saksi',
          'Buku Nikah (Muslim) / Akta Perkawinan (Non-Muslim) orang tua kandung',
          'Formulir F-2.01 (Unduh via tombol di bawah)',
          'Formulir F-2.03 SPTJM Kebenaran Data Kelahiran (Unduh via tombol di bawah)',
          'Formulir F-2.04 SPTJM Kebenaran Pasangan Suami Istri (Unduh via tombol di bawah, apabila tidak bisa menunjukkan buku nikah)',
          '',
          '📌 SALURAN LAYANAN AKTA KELAHIRAN BARU:',
          'Offline (Tatap Muka): Dilayani di Loket Pelayanan Desa/Kelurahan, Atau RSI Muhammadiyah Sumberejo, RSIA Fatma, RSI Muhammadiyah Kalitidu, RSUD Padangan.',
          'Online: Dapat diajukan tanpa formulir kertas melalui Aplikasi Identitas Kependudukan Digital (IKD)',
          '',
          '📌 PENERBITAN KEMBALI AKTA KELAHIRAN KARENA HILANG:',
          'Mengisi Form Permohonan (tersedia di Kantor Dukcapil Mall Pelayanan Publik)',
          'Surat Keterangan Kehilangan dari Kepolisian',
          'KTP Pemohon / Pemilik Akta & Kartu Keluarga',
          'Buku Nikah Orang Tua',
          'Surat Kuasa Bermaterai dan KTP yang diberi Kuasa (Apabila dikuasakan)',
          'Untuk memudahkan pencarian arsip, harap membawa Fotokopi Akta Kelahiran yang hilang (jika masih memiliki)',
          '',
          '📌 PENERBITAN KEMBALI AKTA KELAHIRAN KARENA RUSAK:',
          'Mengisi Form Permohonan (tersedia di Kantor Dukcapil)',
          'Akta Kelahiran Asli yang Rusak',
          'KTP Pemohon / Pemilik Akta & Kartu Keluarga',
          'Buku Nikah Orang Tua',
          'Surat Kuasa Bermaterai dan KTP yang diberi Kuasa (Apabila dikuasakan)',
          '',
          '📍 LOKASI PENGAJUAN AKTA HILANG / RUSAK:',
          'Pemohon dapat mengajukan Permohonan Penerbitan Kembali Akta Kelahiran karena HILANG dan RUSAK di Mall Pelayanan Publik (MPP) Kabupaten Bojonegoro.',
        ]
      },
      {
        'title': 'Persyaratan Akta Kematian',
        'icon': Icons.description_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyaratan-akta-kematian',
        'hasFormulirAktaKematian': true,
        'hasDownloadIKD': true,
        'items': [
          '📌 PERSYARATAN AKTA KEMATIAN:',
          'Surat Keterangan Kematian dari dokter/paramedis (bila ada)',
          'Surat Keterangan Kematian dari Desa',
          'KK dan KTP-el yang meninggal',
          'Fotokopi KTP-el 2 (dua) orang saksi',
          'Fotokopi kutipan akta kelahiran yang meninggal (jika ada)',
          'Formulir F-2.01 (Unduh via tombol di bawah)',
          '',
          '📌 AKTA KEMATIAN BAGI PENDUDUK TAK DIKETAHUI IDENTITASNYA:',
          'Surat Keterangan Kematian dari dokter/paramedis (bila ada)',
          'Surat Keterangan Kematian dari Desa / SPTJM Kebenaran Data Kematian',
          'Fotokopi KTP-el 2 (dua) orang saksi',
          'Formulir F-2.01 (Unduh via tombol di bawah)',
          'Surat Keterangan Kematian dari Kepolisian',
          'Salinan penetapan pengadilan / dari maskapai penerbangan bagi seseorang yang tidak jelas kebenarannya karena hilang atau mati dan tidak ditemukan jenazahnya',
          '',
          '📌 SALURAN LAYANAN AKTA KEMATIAN:',
          'Offline (Tatap Muka): Dilayani di Loket Pelayanan Desa/Kelurahan, Atau RSI Muhammadiyah Sumberejo, RSIA Fatma, RSI Muhammadiyah Kalitidu, RSUD Padangan.',
          'Online: Dapat diajukan tanpa formulir kertas melalui Aplikasi Identitas Kependudukan Digital (IKD) apabila satu Kartu Keluarga dengan pelapor dan terdapat dalam database.',
          '',
          '📌 PENERBITAN KEMBALI AKTA KEMATIAN KARENA RUSAK:',
          'Mengisi form permohonan (tersedia di Kantor Dukcapil)',
          'Surat Keterangan Kehilangan dari Kepolisian (atau Akta Kematian Asli yang Rusak)',
          'KTP Pemohon / Ahli Waris & Kartu Keluarga Ahli Waris',
          'Formulir F-1.07 Surat Kuasa Bermaterai (Unduh via tombol di bawah) dan KTP yang diberi kuasa (Apabila dikuasakan)',
          '',
          '📌 PENERBITAN KEMBALI AKTA KEMATIAN KARENA HILANG:',
          'Mengisi form permohonan (tersedia di Kantor Dukcapil)',
          'KTP Ahli Waris & Kartu Keluarga Ahli Waris',
          'Surat Kehilangan dari Kepolisian & Surat Keterangan dari Desa',
          'Formulir F-1.07 Surat Kuasa Bermaterai (Unduh via tombol di bawah) dan KTP yang diberi kuasa (Apabila dikuasakan)',
          '',
          '📍 LOKASI PENGAJUAN AKTA HILANG / RUSAK:',
          'Pemohon dapat mengajukan Permohonan Penerbitan Kembali Akta Kematian karena HILANG dan RUSAK di Mall Pelayanan Publik (MPP) Kabupaten Bojonegoro.',
        ]
      },
      {
        'title': 'Persyaratan Perkawinan Non Muslim',
        'icon': Icons.favorite_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyaratan-perkawinan-non-muslim',
        'hasFormulirF201': true,
        'items': [
          '📌 PERSYARATAN PERKAWINAN NON-MUSLIM:',
          'Fotokopi surat keterangan telah terjadinya perkawinan dari pemuka agama atau penghayat kepercayaan terhadap Tuhan Yang Maha Esa',
          'Pas foto suami dan istri ukuran 4x6 berwarna = 1 lembar (berjejer)',
          'Fotokopi KTP-el dan KK pasangan',
          'Fotokopi KTP-el Orang tua Suami dan Istri',
          'Fotokopi KTP 2 (dua) orang saksi',
          'Formulir F-2.01 (Unduh via tombol di bawah)',
          'Fotokopi Akta Kematian (Bagi Janda/Duda karena cerai mati)',
          'Akta Cerai Asli (Bagi Janda/Duda karena cerai hidup)',
          'Penetapan Pengadilan bagi pasangan yang beda agama',
          'Izin menikah dari pengadilan bagi usia di bawah umur (kurang dari 19 Tahun)',
          '',
          '🏢 MEKANISME PERMOHONAN:',
          'Offline (Tatap Muka): Dilayani di Mall Pelayanan Publik (MPP) Kabupaten Bojonegoro',
        ]
      },
      {
        'title': 'Persyaratan Perceraian Non Muslim',
        'icon': Icons.heart_broken_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyaratan-perceraian-non-muslim',
        'hasFormulirF201': true,
        'items': [
          '📌 PERSYARATAN PERCERAIAN NON-MUSLIM:',
          'Salinan Keputusan Pengadilan Negeri',
          'Kutipan Akta Perkawinan asli Suami dan Istri',
          'Fotokopi KK Suami dan Istri',
          'Fotokopi KTP Suami dan Istri',
          'Formulir F-2.01 (Unduh via tombol di bawah)',
          '',
          '🏢 MEKANISME PERMOHONAN:',
          'Offline (Tatap Muka): Dilayani di Mall Pelayanan Publik (MPP) Kabupaten Bojonegoro',
        ]
      },
      {
        'title': 'Persyaratan Perubahan Nama',
        'icon': Icons.edit_note_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyaratan-perubahan-nama',
        'items': [
          '📌 PERSYARATAN PERUBAHAN NAMA:',
          'Salinan Penetapan Pengadilan Negeri',
          'Kutipan Akta Kelahiran Asli',
          'Fotokopi KK (Nama Lama)',
          'Fotokopi KTP (Nama Lama)',
          '',
          '🏢 MEKANISME PERMOHONAN:',
          'Offline (Tatap Muka): Dilayani di Mall Pelayanan Publik (MPP) Kabupaten Bojonegoro',
        ]
      },
      {
        'title': 'Persyaratan Adopsi / Pengangkatan Anak',
        'icon': Icons.family_restroom_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyaratan-adopsi-anak',
        'items': [
          '📌 PERSYARATAN PENGANGKATAN ANAK:',
          'Salinan Penetapan Keputusan Pengadilan Negeri tentang Pengangkatan Anak',
          'Kutipan Akta Kelahiran Anak Asli',
          'Fotokopi KK orang tua angkat (pemohon)',
          'Fotokopi KTP-el',
          '',
          '🏢 MEKANISME PERMOHONAN:',
          'Offline (Tatap Muka): Dilayani di Mall Pelayanan Publik (MPP) Kabupaten Bojonegoro',
        ]
      },
      {
        'title': 'Persyaratan Pengesahan Anak',
        'icon': Icons.verified_user_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyaratan-pengesahan-anak',
        'items': [
          '📌 PERSYARATAN PENGESAHAN ANAK:',
          'Kutipan Akta Kelahiran Asli',
          'Fotokopi KK orang tua',
          'Fotokopi KTP orang tua',
          'Fotokopi Penetapan Pengadilan (tentang asal-usul anak)',
          '',
          '🏢 MEKANISME PERMOHONAN:',
          'Offline (Tatap Muka): Dilayani di Mall Pelayanan Publik (MPP) Kabupaten Bojonegoro',
        ]
      },
      {
        'title': 'Persyaratan Pengakuan Anak',
        'icon': Icons.face_rounded,
        'url': 'https://sites.google.com/view/persyaratanpelayanandukcapil/persyaratan-pengakuan-anak',
        'items': [
          '📌 PERSYARATAN PENGAKUAN ANAK:',
          'Surat Pernyataan Pengakuan Anak dari Ayah Biologis yang disetujui oleh Ibu Kandung',
          'Surat Keterangan telah terjadi perkawinan:',
          '  - Non-Muslim: Pemberkatan dari gereja',
          '  - Muslim: Putusan Pengadilan Agama / sidang asal-usul anak',
          'Kutipan Akta Kelahiran Anak Asli',
          'Fotokopi KK dan KTP-el Ayah Biologis',
          'Fotokopi KK dan KTP-el Ibu Kandung',
          '',
          '🏢 MEKANISME PERMOHONAN:',
          'Offline (Tatap Muka): Dilayani di Mall Pelayanan Publik (MPP) Kabupaten Bojonegoro',
        ]
      },
      {
        'title': 'Legalisir Online Disdukcapil',
        'icon': Icons.fact_check_rounded,
        'url': 'https://docs.google.com/forms/d/e/1FAIpQLSe9r3RKN2qnlce-ERFTYvV1qNRkBkJVEwHSPiRgffNMg4VpOg/viewform',
        'items': [
          '📌 PERMOHONAN LEGALISIR DOKUMEN ADMINDUK ONLINE:',
          'Pengajuan legalisir dilakukan secara online via formulir Google Form resmi Disdukcapil Bojonegoro (Klik tombol di bawah).',
          '',
          '📌 KETENTUAN PENTING (MOHON DIBACA):',
          '1. Dokumen Kependudukan yang sudah bertanda tangan elektronik (TTE) dan KTP-el TIDAK PERLU dilegalisir, sesuai Peraturan Menteri Dalam Negeri No. 104 Tahun 2019 Pasal 19 ayat (6).',
          '2. Pastikan Subjek / Pemohon yang mengajukan legalisir masih menjadi Penduduk Kabupaten Bojonegoro.',
        ]
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0284C7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Persyaratan Layanan Disdukcapil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Direct Link Banner to Official Web Dashboard
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [Color(0xFF0369A1), Color(0xFF075985)]
                      : const [Color(0xFF0284C7), Color(0xFF0369A1)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withAlpha(50),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.public_rounded, color: Colors.white, size: 26),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Web Dashboard Disdukcapil',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Persyaratan & panduan layanan selengkapnya dapat diakses langsung via portal web resmi Disdukcapil.',
                    style: TextStyle(color: Color(0xFFE0F2FE), fontSize: 12.5, height: 1.35),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _openDashboardWeb(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0284C7),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: const Text(
                          'Web Dashboard',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _downloadFormulirF102(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: const Text(
                          'Unduh Formulir F-1.02 (PDF)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _downloadFormulirF103(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA580C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: const Text(
                          'Unduh Formulir F-1.03 (PDF)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _downloadFormulirF106(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD97706),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: const Text(
                          'Unduh Formulir F-1.06 (PDF)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _downloadFormulirF107(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: const Text(
                          'Unduh Formulir F-1.07 (PDF)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Text(
              'Jenis-Jenis Persyaratan Layanan (14 Kategori Resmi)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
            const SizedBox(height: 4),
            Text(
              'Pilih salah satu dari 14 kategori layanan di bawah ini untuk melihat detailnya:',
              style: TextStyle(fontSize: 12.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: syarats.length,
              itemBuilder: (context, index) {
                final item = syarats[index];
                final title = item['title'] as String;
                final icon = item['icon'] as IconData;
                final url = item['url'] as String;
                final list = item['items'] as List<String>;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: const Color(0xFF0284C7), size: 22),
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      ...list.map((syarat) {
                        if (syarat.trim().isEmpty) {
                          return const SizedBox(height: 6);
                        }
                        final isHeader = syarat.startsWith('📌') || syarat.startsWith('📍') || syarat.startsWith('📱') || syarat.startsWith('🏢');
                        if (isHeader) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                syarat,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                                ),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(color: Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 14)),
                              Expanded(
                                child: Text(
                                  syarat,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.touch_app_rounded,
                                  size: 16,
                                  color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Aksi & Unduh Berkas Layanan',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                if (index == 0 || item['hasFormulirF102'] == true)
                                  ElevatedButton.icon(
                                    onPressed: () => _downloadFormulirF102(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF59E0B),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.file_download_rounded, size: 16),
                                    label: const Text('Unduh F-1.02 (PDF)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                if (item['hasFormulirF103'] == true)
                                  ElevatedButton.icon(
                                    onPressed: () => _downloadFormulirF103(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEA580C),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.file_download_rounded, size: 16),
                                    label: const Text('Unduh F-1.03 (PDF)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                if (item['hasFormulirF106'] == true)
                                  ElevatedButton.icon(
                                    onPressed: () => _downloadFormulirF106(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD97706),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.file_download_rounded, size: 16),
                                    label: const Text('Unduh F-1.06 (PDF)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                if (item['hasFormulirF107'] == true || item['hasFormulirAktaKematian'] == true)
                                  ElevatedButton.icon(
                                    onPressed: () => _downloadFormulirF107(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF7C3AED),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.file_download_rounded, size: 16),
                                    label: const Text('Unduh F-1.07 (Surat Kuasa)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                if (item['hasFormulirKIA'] == true)
                                  ElevatedButton.icon(
                                    onPressed: () => _downloadFormulirKIA(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0284C7),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.file_download_rounded, size: 16),
                                    label: const Text('Unduh Formulir KIA (PDF)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                if (item['hasFormulirF201'] == true || item['hasFormulirAktaLahir'] == true || item['hasFormulirAktaKematian'] == true)
                                  ElevatedButton.icon(
                                    onPressed: () => _downloadFormulirF201(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2563EB),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.file_download_rounded, size: 16),
                                    label: const Text('Unduh F-2.01 (PDF)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                if (item['hasFormulirAktaLahir'] == true) ...[
                                  ElevatedButton.icon(
                                    onPressed: () => _downloadFormulirF203(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0D9488),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.file_download_rounded, size: 16),
                                    label: const Text('Unduh F-2.03 (SPTJM Lahir)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _downloadFormulirF204(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4F46E5),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.file_download_rounded, size: 16),
                                    label: const Text('Unduh F-2.04 (SPTJM Pasutri)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                ],
                                if (item['hasDownloadIKD'] == true) ...[
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      const String androidUrl = 'https://play.google.com/store/apps/details?id=gov.dukcapil.mobile_id&hl=id';
                                      final Uri uri = Uri.parse(androidUrl);
                                      try {
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                                        }
                                      } catch (_) {}
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.android_rounded, size: 16),
                                    label: const Text('IKD Android (Play Store)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      const String appleUrl = 'https://apps.apple.com/id/app/identitas-kependudukan-digital/id6448944056?l=id';
                                      final Uri uri = Uri.parse(appleUrl);
                                      try {
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                                        }
                                      } catch (_) {}
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF334155),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.apple_rounded, size: 16),
                                    label: const Text('IKD iOS (App Store)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                  if (item['urlCanvaVideo'] != null)
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        final String videoUrl = item['urlCanvaVideo'] as String;
                                        final Uri uri = Uri.parse(videoUrl);
                                        try {
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                                          }
                                        } catch (_) {}
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFE11D48),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      icon: const Icon(Icons.play_circle_fill_rounded, size: 16),
                                      label: const Text('Video Cara Daftar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final Uri uri = Uri.parse(url);
                                  try {
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                                    }
                                  } catch (_) {}
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF0284C7),
                                  side: const BorderSide(color: Color(0xFF0284C7), width: 1.2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                                ),
                                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                                label: const Text(
                                  'Buka Web Portal Layanan Ini',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                                ),
                              ),
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
          ],
        ),
      ),
    );
  }
}
