import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/admin/admin_form_dialog.dart';

class _InfoCardModel {
  String id;
  String title;
  IconData icon;
  List<String> bullets;

  _InfoCardModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.bullets,
  });
}

class AdminPupukBersubsidiScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminPupukBersubsidiScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<AdminPupukBersubsidiScreen> createState() => _AdminPupukBersubsidiScreenState();
}

class _AdminPupukBersubsidiScreenState extends State<AdminPupukBersubsidiScreen> {
  final List<_InfoCardModel> _infoCards = [
    _InfoCardModel(
      id: 'INF-1',
      title: 'Jenis Pupuk Bersubsidi',
      icon: Icons.inventory_2_rounded,
      bullets: [
        'Urea: Pupuk Nitrogen untuk pertumbuhan vegetatif tanaman.',
        'NPK: Pupuk majemuk seimbang (Nitrogen, Phospat, Kalium).',
        'NPK Formula Khusus: Khusus alokasi komoditas kakao.',
        'Pupuk Organik: Untuk perbaikan struktur & kesuburan tanah.',
      ],
    ),
    _InfoCardModel(
      id: 'INF-2',
      title: 'Syarat Penerima Pupuk Bersubsidi',
      icon: Icons.verified_user_rounded,
      bullets: [
        'Terdaftar dalam e-RDKK & SIMLUHTAN Kementan RI.',
        'Tergabung dalam Kelompok Tani (Poktan) setempat.',
        'Mengusahakan lahan maksimal 2 (dua) Hektar per musim tanam.',
        'Memiliki Kartu Tani / e-KTP terverifikasi di Kios Resmi.',
      ],
    ),
    _InfoCardModel(
      id: 'INF-3',
      title: 'Mekanisme Penebusan',
      icon: Icons.shopping_bag_rounded,
      bullets: [
        '1. Datang ke Kios Pupuk Lengkap (KPL) resmi di wilayah domisili kelompok.',
        '2. Tunjukkan KTP Asli / Kartu Tani kepada petugas KPL.',
        '3. Petugas mengonfirmasi NIK & sisa alokasi kuota pupuk pada aplikasi e-Pubers.',
        '4. Petani membayar sesuai Harga Eceran Tertinggi (HET) dan menerima bukti resmi.',
      ],
    ),
    _InfoCardModel(
      id: 'INF-4',
      title: 'Informasi Umum & HET Resmi',
      icon: Icons.gavel_rounded,
      bullets: [
        'HET Urea: Rp 2.250 / kg.',
        'HET NPK: Rp 2.300 / kg.',
        'HET NPK Kakao: Rp 3.300 / kg.',
        'HET Pupuk Organik: Rp 800 / kg.',
        'Penjualan di atas HET adalah pelanggaran hukum. Laporkan via pengaduan DKPP jika ada ketidaksesuaian.',
      ],
    ),
  ];

  Future<void> _openExternalUrl(String urlStr, String labelName) async {
    final Uri url = Uri.parse(urlStr.trim());
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', urlStr.trim()]);
        return;
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

  void _showAddEditInfoDialog([_InfoCardModel? existing]) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final contentController = TextEditingController(
      text: existing?.bullets.join('\n') ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Kartu Informasi' : 'Tambah Kartu Informasi Baru',
          subtitle: 'Kelola judul dan poin-poin deskripsi informasi pupuk bersubsidi',
          isEditing: existing != null,
          fields: [
            AdminFormField(
              label: 'Judul Informasi',
              controller: titleController,
              hint: 'Contoh: HET & Alokasi Pupuk 2026',
            ),
            AdminFormField(
              label: 'Poin-Poin Informasi (Pisahkan Per Baris)',
              controller: contentController,
              hint: 'Tuliskan poin informasi di setiap baris baru...',
              isMultiLine: true,
            ),
          ],
          onSave: () {
            final titleText = titleController.text.trim();
            final lines = contentController.text
                .split('\n')
                .map((l) => l.trim())
                .where((l) => l.isNotEmpty)
                .toList();

            if (titleText.isEmpty) return;

            setState(() {
              if (existing != null) {
                existing.title = titleText;
                existing.bullets = lines.isEmpty ? ['Informasi telah diperbarui.'] : lines;
              } else {
                _infoCards.add(
                  _InfoCardModel(
                    id: 'INF-${DateTime.now().millisecondsSinceEpoch}',
                    title: titleText,
                    icon: Icons.info_outline_rounded,
                    bullets: lines.isEmpty ? ['Informasi baru ditambahkan.'] : lines,
                  ),
                );
              }
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(existing != null ? 'Kartu informasi berhasil diperbarui!' : 'Kartu informasi baru ditambahkan!'),
                backgroundColor: const Color(0xFF059669),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeleteInfo(_InfoCardModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Kartu Informasi'),
        content: Text('Apakah Anda yakin ingin menghapus "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _infoCards.removeWhere((card) => card.id == item.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Kartu informasi "${item.title}" telah dihapus.'),
                  backgroundColor: const Color(0xFFEF4444),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
    final double topPadding = MediaQuery.of(context).padding.top;
    const primaryGreen = Color(0xFF059669);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditInfoDialog(),
        backgroundColor: primaryGreen,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Tambah Info',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Bar (100% User UI Parity)
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
                    color: primaryGreen.withAlpha(50),
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
                                'DKPP Kab. Bojonegoro (Admin)',
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
                  // Deskripsi Singkat Layanan (Exact User UI Parity)
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
                            color: primaryGreen.withAlpha(20),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.eco_rounded,
                            color: primaryGreen,
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

                  // Section Title: AKSES LAYANAN UTAMA (Exact User UI Parity)
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

                  // Card 1: Cek Subsidi Pupuk (Exact User UI Parity)
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

                  // Card 2: e-RDKK 2025–2026 (Exact User UI Parity)
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

                  // Section Title: INFORMASI PUPUK BERSUBSIDI (Expandable Cards + Admin CRUD)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: primaryGreen,
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
                      OutlinedButton.icon(
                        onPressed: () => _showAddInfoDialog(),
                        icon: const Icon(Icons.add_rounded, size: 14, color: primaryGreen),
                        label: const Text('Tambah Info', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 11.5)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: primaryGreen),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Dynamic Expandable Information Cards List (Editable by Admin)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _infoCards.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final card = _infoCards[index];
                      return _buildInfoExpandableCard(
                        isDark: isDark,
                        card: card,
                        onEdit: () => _showAddEditInfoDialog(card),
                        onDelete: () => _confirmDeleteInfo(card),
                      );
                    },
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddInfoDialog() {
    _showAddEditInfoDialog(null);
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
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: Text(
                  buttonText,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
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
    required _InfoCardModel card,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    const primaryGreen = Color(0xFF059669);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: primaryGreen,
          collapsedIconColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryGreen.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(card.icon, color: primaryGreen, size: 20),
          ),
          title: Text(
            card.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...card.bullets.map((b) => _BulletText(b)),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),

                  // Admin Action Buttons (Edit & Delete)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_rounded, size: 14, color: primaryGreen),
                        label: const Text('Edit Isi', style: TextStyle(color: primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: primaryGreen),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline_rounded, size: 14, color: Colors.white),
                        label: const Text('Hapus Card', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.5,
          height: 1.4,
          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
        ),
      ),
    );
  }
}
