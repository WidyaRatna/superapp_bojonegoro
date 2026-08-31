import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/admin/admin_form_dialog.dart';
import 'admin_pengaduan_pertanian_screen.dart';

class AdminLaporScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminLaporScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  State<AdminLaporScreen> createState() => _AdminLaporScreenState();
}

class _AdminLaporScreenState extends State<AdminLaporScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategoryFilter = 'Semua';

  // Desk Admin Form Controllers
  final _deskNameController = TextEditingController();
  final _deskPhoneController = TextEditingController();
  final _deskNikController = TextEditingController();
  final _deskLocationController = TextEditingController(text: 'Bojonegoro Kota');
  final _deskTitleController = TextEditingController();
  final _deskDescController = TextEditingController();
  String _deskCategory = 'Infrastruktur & Jalan';
  String _deskPhotoSource = 'Kamera Perangkat (GPS Verified)';

  final List<String> _categoryFilters = [
    'Semua',
    'Infrastruktur & Jalan',
    'Kebersihan & Sampah',
    'Pelayanan Publik',
    'Lampu Penerangan',
    'Kesehatan & Medis',
    'Bencana & Banjir',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _deskNameController.dispose();
    _deskPhoneController.dispose();
    _deskNikController.dispose();
    _deskLocationController.dispose();
    _deskTitleController.dispose();
    _deskDescController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanPhone.isEmpty) return;
    final Uri url = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        return;
      }
    } catch (_) {}
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menghubungi $phone...')),
      );
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    var cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '62${cleanPhone.substring(1)}';
    }
    final Uri waUrl = Uri.parse('https://wa.me/$cleanPhone');
    try {
      if (await canLaunchUrl(waUrl)) {
        await launchUrl(waUrl, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membuka WhatsApp $phone...')),
      );
    }
  }

  Future<void> _openEmail(String email) async {
    final Uri mailUrl = Uri.parse('mailto:$email');
    try {
      if (await canLaunchUrl(mailUrl)) {
        await launchUrl(mailUrl);
        return;
      }
    } catch (_) {}
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membuka Email $email...')),
      );
    }
  }

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
        SnackBar(content: Text('Membuka portal ($formattedUrl)...')),
      );
    }
  }

  // Show Modal to Update Citizen Report Status & Admin Response
  void _showUpdateReportStatusDialog(ItemLaporanWarga item, bool isDark) {
    String currentStatus = item.status;
    final noteController = TextEditingController(text: item.adminNote);

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D62F1).withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.rate_review_rounded, color: Color(0xFF0D62F1)),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Tindak Lanjuti Laporan Warga',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pelapor: ${item.reporterName} (${item.location})',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    'Status Laporan saat ini:',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildStatusOptionChip('Menunggu', Colors.amber, currentStatus, (val) {
                        setDialogState(() => currentStatus = val);
                      }),
                      _buildStatusOptionChip('Diproses', const Color(0xFF0D62F1), currentStatus, (val) {
                        setDialogState(() => currentStatus = val);
                      }),
                      _buildStatusOptionChip('Selesai', const Color(0xFF10B981), currentStatus, (val) {
                        setDialogState(() => currentStatus = val);
                      }),
                      _buildStatusOptionChip('Ditolak', const Color(0xFFEF4444), currentStatus, (val) {
                        setDialogState(() => currentStatus = val);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Catatan / Tanggapan Resmi Admin:',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    style: TextStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                    decoration: InputDecoration(
                      hintText: 'Tuliskan catatan tindak lanjut atau alasan penanganan...',
                      hintStyle: TextStyle(fontSize: 12.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Batal'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  AdminDataService().updateStatusLaporanWarga(
                    item.id,
                    currentStatus,
                    noteController.text.trim(),
                  );
                  Navigator.pop(dialogCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Status laporan "${item.title}" berhasil diperbarui menjadi "$currentStatus"!'),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D62F1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                label: const Text('Simpan Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusOptionChip(String title, Color color, String selected, ValueChanged<String> onSelect) {
    final isSelected = selected == title;
    return ChoiceChip(
      label: Text(title),
      selected: isSelected,
      onSelected: (_) => onSelect(title),
      selectedColor: color,
      backgroundColor: color.withAlpha(20),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: isSelected ? Colors.white : color,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color),
      ),
    );
  }

  void _showAddEditSopDialog([ItemSopLapor? existing]) {
    final titleController = TextEditingController(text: existing?.title ?? 'SOP Pelaporan Pengaduan Masyarakat');
    final categoryController = TextEditingController(text: existing?.category ?? 'Pelayanan Publik');
    final sopTextController = TextEditingController(text: existing?.sopText ?? '');
    final pdfController = TextEditingController(text: existing?.pdfFileName ?? 'SOP_Pengaduan_Masyarakat_Bojonegoro.pdf');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit SOP Pelaporan Lapor' : 'Tambah SOP Pelaporan Baru',
          subtitle: 'Kelola SOP, ketentuan laporan, mekanisme pengaduan, & berkas PDF',
          isEditing: existing != null,
          initialPdfName: existing?.pdfFileName ?? 'SOP_Pengaduan_Masyarakat.pdf',
          fields: [
            AdminFormField(
              label: 'Judul SOP / Ketentuan Lapor',
              controller: titleController,
              hint: 'Contoh: SOP Pelaporan Layanan Publik SIAP LAPOR',
            ),
            AdminFormField(
              label: 'Kategori Pelaporan',
              controller: categoryController,
              options: const ['Pelayanan Publik', 'Infrastruktur & Jalan', 'Kebersihan & Sampah', 'Kesehatan & Medis', 'Lampu Penerangan', 'Lainnya'],
            ),
            AdminFormField(
              label: 'Teks Alur & Ketentuan SOP',
              controller: sopTextController,
              hint: '1. Pelapor menyampaikan laporan lengkap...\n2. Verifikasi 1x24 jam...',
              isMultiLine: true,
            ),
            AdminFormField(
              label: 'File Dokumen Pendukung (PDF)',
              controller: pdfController,
              hint: 'File_SOP_Lapor.pdf',
            ),
          ],
          onSave: () {
            final service = AdminDataService();
            final item = ItemSopLapor(
              id: existing?.id ?? 'SOP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              title: titleController.text.trim().isEmpty ? 'SOP Pelaporan Baru' : titleController.text.trim(),
              category: categoryController.text.trim().isEmpty ? 'Pelayanan Publik' : categoryController.text.trim(),
              sopText: sopTextController.text.trim().isEmpty ? 'Teks SOP Pengaduan Masyarakat' : sopTextController.text.trim(),
              pdfFileName: pdfController.text.trim().isEmpty ? 'SOP_Pengaduan_Masyarakat.pdf' : pdfController.text.trim(),
            );
            service.updateLaporSop(item);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(existing != null ? 'SOP Pelaporan diperbarui!' : 'SOP Pelaporan baru ditambahkan!'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeleteReport(ItemLaporanWarga item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Laporan Warga?'),
        content: Text('Apakah Anda yakin ingin menghapus laporan "${item.title}"? Data tidak dapat dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              AdminDataService().deleteLaporanWarga(item.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Laporan warga berhasil dihapus.'),
                  backgroundColor: Color(0xFFEF4444),
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

  void _confirmDeleteSop(ItemSopLapor item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus SOP Pelaporan?'),
        content: Text('Apakah Anda yakin ingin menghapus SOP "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              AdminDataService().deleteLaporSop(item.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('SOP Pelaporan berhasil dihapus.'),
                  backgroundColor: Color(0xFFEF4444),
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

  List<ItemLaporanWarga> _getFilteredReports(List<ItemLaporanWarga> reports) {
    return reports.where((item) {
      final matchesCategory = _selectedCategoryFilter == 'Semua' || item.category == _selectedCategoryFilter;
      final matchesQuery = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.reporterName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diproses':
        return const Color(0xFF0D62F1);
      case 'Selesai':
        return const Color(0xFF10B981);
      case 'Ditolak':
        return const Color(0xFFEF4444);
      case 'Menunggu':
      default:
        return Colors.amber.shade800;
    }
  }

  void _submitDeskReport() {
    final name = _deskNameController.text.trim();
    final title = _deskTitleController.text.trim();
    final desc = _deskDescController.text.trim();

    if (name.isEmpty || title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap lengkapi nama pelapor, judul laporan, dan rincian pengaduan!'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final newReport = ItemLaporanWarga(
      id: 'LPR-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      category: _deskCategory,
      title: title,
      description: desc,
      reporterName: name,
      reporterPhone: _deskPhoneController.text.trim().isEmpty ? '0812-xxxx-xxxx' : _deskPhoneController.text.trim(),
      location: _deskLocationController.text.trim().isEmpty ? 'Bojonegoro Kota' : _deskLocationController.text.trim(),
      photoSource: _deskPhotoSource,
      status: 'Menunggu',
      dateStr: 'Hari ini ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} WIB',
    );

    // Save report to service
    final service = AdminDataService();
    final reports = List<ItemLaporanWarga>.from(service.laporanWargaList);
    reports.insert(0, newReport);

    // Reset controllers
    _deskNameController.clear();
    _deskPhoneController.clear();
    _deskNikController.clear();
    _deskTitleController.clear();
    _deskDescController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Laporan Desk Admin "${newReport.title}" berhasil diinput!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );

    // Switch to Monitoring tab
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return ListenableBuilder(
      listenable: AdminDataService(),
      builder: (context, _) {
        final reportsList = AdminDataService().laporanWargaList;
        final sopList = AdminDataService().laporSopList;
        final filteredReports = _getFilteredReports(reportsList);

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: isDark
                      ? const [
                          Color(0xFF0B2545), // Dark Royal Blue
                          Color(0xFF0A5560), // Dark Teal
                        ]
                      : const [
                          Color(0xFF0D62F1), // Royal Blue SuperApp
                          Color(0xFF06B6D4), // Cyan Pariwisata
                        ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lapor & Pengaduan Warga',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Wadul Bupati Bojonegoro • SIAP LAPOR',
                  style: TextStyle(color: Color(0xFFCFFAFE), fontSize: 11),
                ),
              ],
            ),
            actions: [
              if (widget.onToggleDarkMode != null)
                IconButton(
                  icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: Colors.white),
                  onPressed: widget.onToggleDarkMode,
                ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kTextTabBarHeight + 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: isDark
                        ? const [
                            Color(0xFF0B2545),
                            Color(0xFF0A5560),
                          ]
                        : const [
                            Color(0xFF0D62F1),
                            Color(0xFF06B6D4),
                          ],
                  ),
                ),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.stylus,
                    },
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFFCFFAFE),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.assignment_late_rounded, size: 18),
                        text: 'Wadul Bupati',
                      ),
                      Tab(
                        icon: Icon(Icons.assignment_turned_in_rounded, size: 18),
                        text: 'Monitoring',
                      ),
                      Tab(
                        icon: Icon(Icons.public_rounded, size: 18),
                        text: 'Kanal Lapor',
                      ),
                      Tab(
                        icon: Icon(Icons.description_rounded, size: 18),
                        text: 'SOP Lapor',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: _tabController.index == 3
              ? FloatingActionButton.extended(
                  onPressed: () => _showAddEditSopDialog(),
                  backgroundColor: const Color(0xFF0D62F1),
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  label: const Text(
                    'Tambah SOP',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              : null,
          body: TabBarView(
            controller: _tabController,
            children: [
              // TAB 1: Wadul Bupati & Form Input (Identik Sisi User)
              _buildWadulBupatiFormTab(isDark),

              // TAB 2: Monitoring Laporan Masuk Warga
              _buildMonitoringTab(filteredReports, isDark),

              // TAB 3: Kanal Pengaduan Resmi & SP4N-LAPOR
              _buildKanalLaporTab(isDark),

              // TAB 4: SOP & Ketentuan Lapor
              _buildSopTab(sopList, isDark),
            ],
          ),
        );
      },
    );
  }

  // TAB 1 BUILDER: Wadul Bupati Disclaimer & Form Input (100% Identik Sisi User)
  Widget _buildWadulBupatiFormTab(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Wadul Bupati
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D62F1).withAlpha(isDark ? 30 : 10),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D62F1).withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.assignment_late_rounded, color: Color(0xFF0D62F1), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wadul Bupati Bojonegoro',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Fasilitas pengaduan masyarakat & pelayanan publik Bojonegoro.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Disclaimer Points (Identik laporan_screen.dart)
          _buildDisclaimerPointItem(
            icon: '📌',
            title: 'Tindak Lanjut Laporan',
            description: 'Laporan yang dikirim akan diteruskan kepada Organisasi Perangkat Daerah (OPD) yang berwenang.',
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildDisclaimerPointItem(
            icon: '📍',
            title: 'Lokasi Laporan',
            description: 'Lokasi laporan diambil secara otomatis berdasarkan GPS terverifikasi lokasi pengaduan.',
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildDisclaimerPointItem(
            icon: '📷',
            title: 'Bukti Pendukung',
            description: 'Lampirkan foto lokasi jelas agar memudahkan petugas OPD dalam melakukan verifikasi.',
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildDisclaimerPointItem(
            icon: '🔒',
            title: 'Privasi & Keamanan Data',
            description: 'Kerahasiaan identitas pelapor terjamin aman sesuai ketentuan SIAP LAPOR Bojonegoro.',
            isDark: isDark,
          ),
          const SizedBox(height: 18),

          // Grid Kategori Lapor (7 Categories with Icons)
          Text(
            'Pilih Kategori Pelaporan Warga',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildCategoryTile('Infrastruktur & Jalan', Icons.add_road_rounded, const Color(0xFF0D62F1), isDark),
              _buildCategoryTile('Kebersihan & Sampah', Icons.delete_sweep_rounded, const Color(0xFF10B981), isDark),
              _buildCategoryTile('Pelayanan Publik', Icons.account_balance_rounded, const Color(0xFF8B5CF6), isDark),
              _buildCategoryTile('Lampu Penerangan', Icons.lightbulb_rounded, Colors.amber.shade800, isDark),
              _buildCategoryTile('Kesehatan & Medis', Icons.local_hospital_rounded, const Color(0xFFEF4444), isDark),
              _buildCategoryTile('Bencana & Banjir', Icons.tsunami_rounded, const Color(0xFF0284C7), isDark),
            ],
          ),
          const SizedBox(height: 20),

          // Form Input Desk Admin Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.edit_document, color: Color(0xFF0D62F1), size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Form Input Laporan Desk Admin',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 10),

                _buildFormFieldLabel('Nama Lengkap Pelapor', isDark),
                TextField(
                  controller: _deskNameController,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  decoration: _buildFormInputDecoration('Contoh: Budi Santoso', isDark),
                ),
                const SizedBox(height: 12),

                _buildFormFieldLabel('Nomor HP / WhatsApp', isDark),
                TextField(
                  controller: _deskPhoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  decoration: _buildFormInputDecoration('Contoh: 0812-3456-7890', isDark),
                ),
                const SizedBox(height: 12),

                _buildFormFieldLabel('Kategori Laporan Selected', isDark),
                DropdownButtonFormField<String>(
                  initialValue: _deskCategory,
                  dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  decoration: _buildFormInputDecoration('', isDark),
                  items: _categoryFilters.where((c) => c != 'Semua').map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _deskCategory = val);
                  },
                ),
                const SizedBox(height: 12),

                _buildFormFieldLabel('Judul Laporan Singkat', isDark),
                TextField(
                  controller: _deskTitleController,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  decoration: _buildFormInputDecoration('Contoh: Jalan Berlubang di Perempatan Mastrip', isDark),
                ),
                const SizedBox(height: 12),

                _buildFormFieldLabel('Lokasi / Alamat Kejadian', isDark),
                TextField(
                  controller: _deskLocationController,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  decoration: _buildFormInputDecoration('Contoh: Jl. Mastrip No. 12, Bojonegoro', isDark),
                ),
                const SizedBox(height: 12),

                _buildFormFieldLabel('Rincian Pengaduan Warga', isDark),
                TextField(
                  controller: _deskDescController,
                  maxLines: 3,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  decoration: _buildFormInputDecoration('Tuliskan rincian pengaduan lengkap...', isDark),
                ),
                const SizedBox(height: 12),

                _buildFormFieldLabel('Sumber Bukti Foto', isDark),
                DropdownButtonFormField<String>(
                  initialValue: _deskPhotoSource,
                  dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  decoration: _buildFormInputDecoration('', isDark),
                  items: const [
                    DropdownMenuItem(value: 'Kamera Perangkat (GPS Verified)', child: Text('Kamera Perangkat (GPS Verified)')),
                    DropdownMenuItem(value: 'Galeri Perangkat', child: Text('Galeri Perangkat')),
                    DropdownMenuItem(value: 'Dokumen Fisik Desk Admin', child: Text('Dokumen Fisik Desk Admin')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _deskPhotoSource = val);
                  },
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: _submitDeskReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D62F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    label: const Text(
                      'Kirim Laporan Desk Admin',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(String title, IconData icon, Color color, bool isDark) {
    final isSelected = _deskCategory == title;
    return InkWell(
      onTap: () {
        setState(() => _deskCategory = title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kategori dipilih: $title'), duration: const Duration(milliseconds: 800)),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withAlpha(isDark ? 40 : 20)
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimerPointItem({
    required String icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11.5,
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

  // TAB 2 BUILDER: Monitoring Laporan Masuk
  Widget _buildMonitoringTab(List<ItemLaporanWarga> reports, bool isDark) {
    return Column(
      children: [
        // Wadul Bupati Info Banner Card
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 25 : 8),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D62F1).withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.assignment_late_rounded, color: Color(0xFF0D62F1), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wadul Bupati & SIAP LAPOR',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Monitoring & Penanganan Pengaduan Masyarakat Bojonegoro',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Search Input Bar
        Container(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            style: TextStyle(fontSize: 13.5, color: isDark ? Colors.white : const Color(0xFF0F172A)),
            decoration: InputDecoration(
              hintText: 'Cari judul laporan, pelapor, atau lokasi...',
              hintStyle: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF0D62F1)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Category Filter Horizontal Scroll
        Container(
          height: 48,
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: _categoryFilters.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categoryFilters[index];
              final isSelected = _selectedCategoryFilter == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedCategoryFilter = cat),
                selectedColor: const Color(0xFF0D62F1),
                backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFF0D62F1) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                ),
              );
            },
          ),
        ),

        // Report Cards List
        Expanded(
          child: reports.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_late_rounded, size: 64, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada laporan warga yang ditemukan',
                          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Coba ubah kata kunci atau kategori filter laporan.',
                          style: TextStyle(fontSize: 12.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  physics: const BouncingScrollPhysics(),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final item = reports[index];
                    final statusColor = _getStatusColor(item.status);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 30 : 10),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Header Row: Category Badge & Status Badge
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D62F1).withAlpha(isDark ? 40 : 15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.category,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0D62F1),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: statusColor.withAlpha(20),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: statusColor),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      item.status == 'Selesai'
                                          ? Icons.check_circle_rounded
                                          : item.status == 'Diproses'
                                              ? Icons.sync_rounded
                                              : item.status == 'Ditolak'
                                                  ? Icons.cancel_rounded
                                                  : Icons.hourglass_top_rounded,
                                      size: 13,
                                      color: statusColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.status,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Report Title
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Report Description
                          Text(
                            item.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Metadata Container: Submitter & Location
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person_rounded, size: 15, color: Color(0xFF0D62F1)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Pelapor: ${item.reporterName} (${item.reporterPhone})',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded, size: 15, color: Color(0xFFEF4444)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        item.location,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.photo_camera_rounded, size: 14, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.photoSource,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Admin Response Note (if exists)
                          if (item.adminNote.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withAlpha(isDark ? 25 : 12),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF10B981).withAlpha(50)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.admin_panel_settings_rounded, size: 16, color: Color(0xFF10B981)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Tanggapan Admin: ${item.adminNote}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF10B981),
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 10),

                          // Action Control Buttons Row (1 Row Precision)
                          Row(
                            children: [
                              Text(
                                item.dateStr,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                ),
                              ),
                              const Spacer(),

                              OutlinedButton.icon(
                                onPressed: () => _showUpdateReportStatusDialog(item, isDark),
                                icon: const Icon(Icons.edit_note_rounded, size: 16, color: Color(0xFF0D62F1)),
                                label: const Text('Tindak Lanjuti', style: TextStyle(color: Color(0xFF0D62F1), fontWeight: FontWeight.bold, fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF0D62F1)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                ),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                onPressed: () => _confirmDeleteReport(item),
                                tooltip: 'Hapus Laporan',
                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF4444)),
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444).withAlpha(15),
                                  padding: const EdgeInsets.all(8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // TAB 3 BUILDER: Kanal Pengaduan Resmi & SP4N-LAPOR
  Widget _buildKanalLaporTab(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kanal Pengaduan Resmi & SP4N-LAPOR!',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Kanal resmi pengaduan publik Pemkab Bojonegoro dan integrasi instansi.',
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),

          _buildKanalItemCard(
            title: 'Website SP4N-LAPOR!',
            subtitle: 'Portal nasional resmi pengaduan pelayanan publik Pemkab Bojonegoro',
            badgeText: 'ONLINE NASIONAL',
            icon: Icons.language_rounded,
            color: const Color(0xFF0D62F1),
            buttonText: 'Buka Portal SP4N-LAPOR!',
            onTap: () => _openWebUrl('https://www.lapor.go.id/'),
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          _buildKanalItemCard(
            title: 'Buku Tamu Online DPMPTSP',
            subtitle: 'Formulir online pengaduan perizinan & investasi Bojonegoro',
            badgeText: 'PORTAL PERIZINAN',
            icon: Icons.public_rounded,
            color: const Color(0xFF0D62F1),
            buttonText: 'Buka Buku Tamu DPMPTSP',
            onTap: () => _openWebUrl('https://dpmptsp.bojonegorokab.go.id/bukutamu/add'),
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          _buildKanalItemCard(
            title: 'WhatsApp Helpdesk LAPOR',
            subtitle: 'Nomor resmi layanan pengaduan cepat via WhatsApp',
            badgeText: 'HELP DESK WA',
            icon: Icons.chat_rounded,
            color: const Color(0xFF10B981),
            buttonText: 'Chat WhatsApp Admin',
            onTap: () => _openWhatsApp('0812-3456-7890'),
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          _buildKanalItemCard(
            title: 'Email Pengaduan Direct',
            subtitle: 'Surat elektronik resmi penanganan komplain & aspirasi',
            badgeText: 'EMAIL RESMI',
            icon: Icons.email_rounded,
            color: const Color(0xFFEA580C),
            buttonText: 'Kirim Email Pengaduan',
            onTap: () => _openEmail('dpmptsp@bojonegorokab.go.id'),
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          _buildKanalItemCard(
            title: 'Call Center Direct Line',
            subtitle: 'Layanan telepon darurat pengaduan & informasi perizinan',
            badgeText: 'HOTLINE RESMI',
            icon: Icons.phone_in_talk_rounded,
            color: const Color(0xFF059669),
            buttonText: 'Hubungi (0353) 881513',
            onTap: () => _makePhoneCall('(0353) 881513'),
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          _buildKanalItemCard(
            title: 'Pengaduan DKPP Pertanian',
            subtitle: 'Portal khusus pengaduan pupuk bersubsidi & hama pertanian',
            badgeText: 'PERTANIAN',
            icon: Icons.eco_rounded,
            color: const Color(0xFF10B981),
            buttonText: 'Buka Admin Pertanian',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminPengaduanPertanianScreen(
                    isDarkMode: isDark,
                    onToggleDarkMode: widget.onToggleDarkMode,
                  ),
                ),
              );
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildKanalItemCard({
    required String title,
    required String subtitle,
    required String badgeText,
    required IconData icon,
    required Color color,
    required String buttonText,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 25 : 8),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(isDark ? 40 : 15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              icon: const Icon(Icons.open_in_new_rounded, size: 16, color: Colors.white),
              label: Text(
                buttonText,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFieldLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
      ),
    );
  }

  InputDecoration _buildFormInputDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 12.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
      filled: true,
      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
      ),
    );
  }

  // TAB 4 BUILDER: SOP & Ketentuan Lapor
  Widget _buildSopTab(List<ItemSopLapor> items, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kelola SOP & Ketentuan Pengaduan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Panduan mekanisme pengaduan masyarakat & dokumen pendukung PDF.',
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D62F1).withAlpha(isDark ? 40 : 15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.description_rounded, color: Color(0xFF0D62F1), size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Kategori: ${item.category}',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF0D62F1), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.sopText,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.pdfFileName,
                            style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _showAddEditSopDialog(item),
                          icon: const Icon(Icons.edit_rounded, size: 15, color: Color(0xFF0D62F1)),
                          label: const Text('Edit SOP', style: TextStyle(color: Color(0xFF0D62F1), fontWeight: FontWeight.bold, fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0D62F1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: () => _confirmDeleteSop(item),
                          tooltip: 'Hapus SOP',
                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF4444)),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444).withAlpha(15),
                            padding: const EdgeInsets.all(8),
                          ),
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
    );
  }
}
