import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/admin_data_service.dart';
import '../../assets/brosur_beasiswa_data.dart';
import '../../widgets/admin/admin_form_dialog.dart';

class AdminPendidikanScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminPendidikanScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  State<AdminPendidikanScreen> createState() => _AdminPendidikanScreenState();
}

class _AdminPendidikanScreenState extends State<AdminPendidikanScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedSubService; // null = Selection Menu, 'beasiswa' = Beasiswa, 'perpustakaan' = Perpustakaan

  Future<void> _openPerpustakaanPlayStore() async {
    const String urlStr = 'https://play.google.com/store/apps/details?id=mam.reader.emaos&pcampaignid=web_share';
    final Uri url = Uri.parse(urlStr);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    // Fallback for Windows desktop system shell during active debug session
    if (!kIsWeb) {
      try {
        if (Platform.isWindows) {
          await Process.run('cmd', ['/c', 'start', '', urlStr]);
          return;
        }
      } catch (_) {}
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Membuka aplikasi E-MAOS Perpustakaan Bojonegoro di Play Store... 📱'),
          backgroundColor: Color(0xFF0D62F1),
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- BEASISWA DIALOG & MANAGEMENT ---
  void _showAddEditBeasiswaDialog([ItemBeasiswa? existing]) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final providerController = TextEditingController(text: existing?.provider ?? 'Dinas Pendidikan Bojonegoro');
    final quotaController = TextEditingController(text: existing?.quota ?? '500 Mahasiswa');
    final deadlineController = TextEditingController(text: existing?.deadline ?? '30 November 2026');
    final pdfController = TextEditingController(text: existing?.pdfFileName ?? 'Syarat_Pendaftaran_Beasiswa.pdf');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Informasi Beasiswa' : 'Tambah Program Beasiswa Baru',
          subtitle: 'Kelola program beasiswa Pemkab Bojonegoro & berkas PDF',
          isEditing: existing != null,
          initialPdfName: existing?.pdfFileName ?? 'Syarat_Pendaftaran_Beasiswa.pdf',
          initialImageName: existing?.imageUrl ?? 'Brosur_Beasiswa.png',
          fields: [
            AdminFormField(
              label: 'Nama Program Beasiswa',
              controller: titleController,
              hint: 'Contoh: Beasiswa Scientist Bojonegoro 2026',
            ),
            AdminFormField(
              label: 'Penyelenggara / Instansi',
              controller: providerController,
              hint: 'Dinas Pendidikan Bojonegoro',
            ),
            AdminFormField(
              label: 'Kuota Penerima',
              controller: quotaController,
              hint: '500 Mahasiswa / Pelajar',
            ),
            AdminFormField(
              label: 'Batas Akhir Pendaftaran',
              controller: deadlineController,
              hint: '30 Oktober 2026',
            ),
            AdminFormField(
              label: 'File PDF Persyaratan',
              controller: pdfController,
              hint: 'Syarat_Lengkap_Beasiswa.pdf',
            ),
          ],
          onSave: () {
            final service = AdminDataService();
            if (existing != null) {
              existing.title = titleController.text.trim();
              existing.provider = providerController.text.trim();
              existing.quota = quotaController.text.trim();
              existing.deadline = deadlineController.text.trim();
              existing.pdfFileName = pdfController.text.trim();
              service.updateBeasiswa(existing);
            } else {
              service.addBeasiswa(
                ItemBeasiswa(
                  id: 'BSW-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  title: titleController.text.trim().isEmpty ? 'Beasiswa Daerah Baru' : titleController.text.trim(),
                  provider: providerController.text.trim().isEmpty ? 'Dinas Pendidikan Bojonegoro' : providerController.text.trim(),
                  quota: quotaController.text.trim().isEmpty ? '500 Mahasiswa' : quotaController.text.trim(),
                  deadline: deadlineController.text.trim().isEmpty ? '30 November 2026' : deadlineController.text.trim(),
                  pdfFileName: pdfController.text.trim().isEmpty ? 'Syarat_Pendaftaran_Beasiswa.pdf' : pdfController.text.trim(),
                ),
              );
            }
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(existing != null ? 'Program Beasiswa diperbarui! (Tersinkron dengan Pengguna)' : 'Program Beasiswa baru ditambahkan! (Tersinkron dengan Pengguna)'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeleteBeasiswa(ItemBeasiswa item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Program Beasiswa'),
        content: Text('Apakah Anda yakin ingin menghapus beasiswa "${item.title}"? Perubahan akan langsung berdampak pada tampilan pengguna.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AdminDataService().deleteBeasiswa(item.id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Beasiswa "${item.title}" telah dihapus.'),
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

  // --- PERPUSTAKAAN DIALOG & MANAGEMENT ---
  void _showAddEditPerpustakaanDialog([ItemPerpustakaan? existing]) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final authorController = TextEditingController(text: existing?.author ?? 'Dinas Perpustakaan & Kearsipan Bojonegoro');
    final categoryController = TextEditingController(text: existing?.category ?? 'E-Book / Digital');
    final stockController = TextEditingController(text: existing?.stock ?? '100 Eksemplar');
    final descriptionController = TextEditingController(text: existing?.description ?? 'Buku katalog perpustakaan digital daerah Bojonegoro.');
    final pdfController = TextEditingController(text: existing?.pdfFileName ?? 'Katalog_E_Book_Perpustakaan.pdf');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Katalog Perpustakaan' : 'Tambah Katalog Buku Digital Baru',
          subtitle: 'Kelola buku digital & katalog perpustakaan daerah Bojonegoro',
          isEditing: existing != null,
          initialPdfName: existing?.pdfFileName ?? 'Katalog_E_Book_Perpustakaan.pdf',
          fields: [
            AdminFormField(
              label: 'Judul Buku / Katalog',
              controller: titleController,
              hint: 'Contoh: Sejarah & Kebudayaan Bojonegoro',
            ),
            AdminFormField(
              label: 'Pengarang / Instansi',
              controller: authorController,
              hint: 'Dinas Perpustakaan Bojonegoro',
            ),
            AdminFormField(
              label: 'Kategori Buku',
              controller: categoryController,
              hint: 'E-Book / Digital / Sejarah / Sains',
            ),
            AdminFormField(
              label: 'Stok / Ketersediaan',
              controller: stockController,
              hint: '100 Eksemplar / 12.500 E-Book',
            ),
            AdminFormField(
              label: 'Deskripsi Singkat',
              controller: descriptionController,
              hint: 'Catatan ringkas isi buku digital',
            ),
            AdminFormField(
              label: 'File PDF Katalog / E-Book',
              controller: pdfController,
              hint: 'File_Buku_Digital.pdf',
            ),
          ],
          onSave: () {
            final service = AdminDataService();
            if (existing != null) {
              existing.title = titleController.text.trim();
              existing.author = authorController.text.trim();
              existing.category = categoryController.text.trim();
              existing.stock = stockController.text.trim();
              existing.description = descriptionController.text.trim();
              existing.pdfFileName = pdfController.text.trim();
              service.updatePerpustakaan(existing);
            } else {
              service.addPerpustakaan(
                ItemPerpustakaan(
                  id: 'PRP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  title: titleController.text.trim().isEmpty ? 'Katalog Buku Baru' : titleController.text.trim(),
                  author: authorController.text.trim().isEmpty ? 'Dinas Perpustakaan Bojonegoro' : authorController.text.trim(),
                  category: categoryController.text.trim().isEmpty ? 'E-Book' : categoryController.text.trim(),
                  stock: stockController.text.trim().isEmpty ? '100 E-Book' : stockController.text.trim(),
                  description: descriptionController.text.trim().isEmpty ? 'Katalog buku digital perpustakaan daerah.' : descriptionController.text.trim(),
                  pdfFileName: pdfController.text.trim().isEmpty ? 'Katalog_E_Book_Perpustakaan.pdf' : pdfController.text.trim(),
                ),
              );
            }
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(existing != null ? 'Katalog Buku diperbarui! (Tersinkron dengan Pengguna)' : 'Katalog Buku baru ditambahkan! (Tersinkron dengan Pengguna)'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeletePerpustakaan(ItemPerpustakaan item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Katalog Buku'),
        content: Text('Apakah Anda yakin ingin menghapus buku "${item.title}"? Perubahan akan langsung berdampak pada tampilan pengguna.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AdminDataService().deletePerpustakaan(item.id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Buku "${item.title}" telah dihapus.'),
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

  // --- EDIT BROSUR / POSTER BANNER DIALOG ---
  void _showEditBrosurBannerDialog() {
    final titleController = TextEditingController(text: 'Brosur Beasiswa Bojonegoro 2026');
    final periodController = TextEditingController(text: '1 Agustus s.d 31 Agustus 2026');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: 'Edit Poster Brosur Beasiswa',
          subtitle: 'Unggah file poster baru atau perbarui informasi brosur resmi',
          isEditing: true,
          initialImageName: 'brosur_beasiswa.png',
          fields: [
            AdminFormField(
              label: 'Judul Brosur / Program',
              controller: titleController,
              hint: 'Brosur Beasiswa Bojonegoro 2026',
            ),
            AdminFormField(
              label: 'Periode Pendaftaran',
              controller: periodController,
              hint: '1 Agustus s.d 31 Agustus 2026',
            ),
          ],
          onSave: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Poster Brosur Beasiswa berhasil diperbarui! 🖼️✨'),
                backgroundColor: Color(0xFF10B981),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return ListenableBuilder(
      listenable: AdminDataService(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
          floatingActionButton: _selectedSubService == 'beasiswa'
              ? FloatingActionButton.extended(
                  onPressed: () => _showAddEditBeasiswaDialog(),
                  backgroundColor: const Color(0xFF8B5CF6),
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  label: const Text(
                    'Tambah Beasiswa Baru',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              : _selectedSubService == 'perpustakaan'
                  ? FloatingActionButton.extended(
                      onPressed: () => _showAddEditPerpustakaanDialog(),
                      backgroundColor: const Color(0xFF0D62F1),
                      icon: const Icon(Icons.add_rounded, color: Colors.white),
                      label: const Text(
                        'Tambah Buku Baru',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  : null,
          body: _selectedSubService == null
              ? _buildSelectionMenu(isDark)
              : _selectedSubService == 'beasiswa'
                  ? _buildBeasiswaAdminViewIdenticalToUser(isDark)
                  : _buildPerpustakaanAdminViewIdenticalToUser(isDark),
        );
      },
    );
  }

  // --- 1. SUB-SERVICE SELECTION MENU MENU MENU ---
  Widget _buildSelectionMenu(bool isDark) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final pendidikanGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF312E81), Color(0xFF4C1D95)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          );

    return Column(
      children: [
        // Header Bar
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
          decoration: BoxDecoration(gradient: pendidikanGradient),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'PORTAL ADMIN',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
                      color: isDark ? Colors.amber : Colors.white,
                    ),
                    onPressed: widget.onToggleDarkMode,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Kelola Layanan Pendidikan',
                          style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Dinas Pendidikan Kabupaten Bojonegoro',
                          style: TextStyle(color: Color(0xFFEDE9FE), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Layanan Pendidikan',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Silakan pilih salah satu layanan online di bawah ini untuk dikelola:',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 20),

                // SELECTION CARD 1: Pendaftaran Beasiswa Daerah
                _buildSelectionCard(
                  icon: Icons.workspace_premium_rounded,
                  iconBgColor: const Color(0xFFF3E8FF),
                  iconColor: const Color(0xFF8B5CF6),
                  title: 'Pendaftaran Beasiswa Daerah',
                  subtitle: 'Program Beasiswa Kuliah & Sekolah Kab. Bojonegoro',
                  onTap: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                      _selectedSubService = 'beasiswa';
                    });
                  },
                  isDark: isDark,
                ),
                const SizedBox(height: 14),

                // SELECTION CARD 2: Informasi Perpustakaan Daerah (Play Store Link)
                _buildSelectionCard(
                  icon: Icons.local_library_rounded,
                  iconBgColor: const Color(0xFFE0F2FE),
                  iconColor: const Color(0xFF0284C7),
                  title: 'Informasi Perpustakaan Daerah',
                  subtitle: 'Katalog Buku Digital E-Pustaka, Download & Baca Buku (Buka Aplikasi E-MAOS di Play Store)',
                  onTap: _openPerpustakaanPlayStore,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 35 : 10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Row(
              children: [
                // Left Icon Box
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark ? iconColor.withAlpha(35) : iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Arrow Circle Button Right
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0D62F1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 2. ADMIN BEASISWA VIEW (EXACT IDENTICAL VISUAL WITH USER SCREEN + ADMIN CONTROL BUTTONS) ---
  Widget _buildBeasiswaAdminViewIdenticalToUser(bool isDark) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final items = AdminDataService().beasiswaList;
    final filtered = items.where((b) {
      final q = _searchQuery.toLowerCase();
      return b.title.toLowerCase().contains(q) || b.provider.toLowerCase().contains(q);
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Top Header Bar (Royal Blue Government Theme)
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFF0D62F1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () => setState(() => _selectedSubService = null),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.amber.withAlpha(220),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'ADMIN MODE',
                              style: TextStyle(color: Color(0xFF0F172A), fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Flexible(
                            child: Text(
                              'Beasiswa Daerah Bojonegoro',
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
                        color: isDark ? Colors.amber : Colors.white,
                      ),
                      onPressed: widget.onToggleDarkMode,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Program Beasiswa Pemkab 2026',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Dinas Pendidikan Kabupaten Bojonegoro',
                            style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Admin Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Cari program beasiswa...',
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D62F1)),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF0D62F1), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Official Flyer Banner Image with Admin Overlay Edit Button
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 30 : 8),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(
                          brosurBeasiswaBytes,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            'assets/images/brosur_beasiswa.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // ADMIN OVERLAY EDIT POSTER BUTTON
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _showEditBrosurBannerDialog,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D62F1),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(50),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.edit_rounded, color: Colors.white, size: 15),
                                SizedBox(width: 6),
                                Text(
                                  'Edit Poster Brosur',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // SECTION 1: Program Beasiswa Pendidikan Tinggi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.school_rounded, color: Color(0xFF0D62F1), size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Program Beasiswa Pendidikan Tinggi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D62F1).withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${filtered.length} Beasiswa',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0D62F1)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // List of Beasiswa Cards (Clean Government Service Style + Admin Controls)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 25 : 6),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D62F1).withAlpha(18),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFF0D62F1), size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Penyelenggara: ${item.provider}',
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

                            // Clean Information Rows (Kuota & Deadline)
                            Row(
                              children: [
                                Icon(Icons.people_outline_rounded, size: 14, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Text(
                                  'Kuota: ${item.quota}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.event_outlined, size: 14, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Batas: ${item.deadline}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), height: 1),
                            const SizedBox(height: 12),

                            // PDF File & Clean Download Button
                            Row(
                              children: [
                                const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFEF4444), size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.pdfFileName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Mengunduh ${item.pdfFileName}...'),
                                        backgroundColor: const Color(0xFF0D62F1),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.download_rounded, size: 14, color: Colors.white),
                                  label: const Text('Unduh PDF', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D62F1),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // ADMIN ACTION PANEL (EDIT & DELETE BUTTONS)
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () => _showAddEditBeasiswaDialog(item),
                                    icon: const Icon(Icons.edit_rounded, size: 14, color: Color(0xFF0D62F1)),
                                    label: const Text('Edit Beasiswa', style: TextStyle(color: Color(0xFF0D62F1), fontSize: 12, fontWeight: FontWeight.bold)),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Color(0xFF0D62F1)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () => _confirmDeleteBeasiswa(item),
                                    icon: const Icon(Icons.delete_outline_rounded, size: 14, color: Colors.white),
                                    label: const Text('Hapus', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEF4444),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. ADMIN PERPUSTAKAAN VIEW (EXACT IDENTICAL VISUAL WITH USER SCREEN + ADMIN CONTROL BUTTONS) ---
  Widget _buildPerpustakaanAdminViewIdenticalToUser(bool isDark) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final items = AdminDataService().perpustakaanList;
    final filtered = items.where((b) {
      final q = _searchQuery.toLowerCase();
      return b.title.toLowerCase().contains(q) || b.author.toLowerCase().contains(q) || b.category.toLowerCase().contains(q);
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Header Bar (Identical to User PerpustakaanDetailScreen)
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [Color(0xFF0F172A), Color(0xFF1E3A8A)]
                    : const [Color(0xFF0052D4), Color(0xFF0D62F1)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () => setState(() => _selectedSubService = null),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.amber.withAlpha(220),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'ADMIN MODE',
                              style: TextStyle(color: Color(0xFF0F172A), fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Flexible(
                            child: Text(
                              'Perpustakaan & E-Pustaka',
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
                        color: isDark ? Colors.amber : Colors.white,
                      ),
                      onPressed: widget.onToggleDarkMode,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(35),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.local_library_rounded, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'E-Pustaka Bojonegoro',
                            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Katalog Buku Digital & Layanan Perpustakaan Daerah',
                            style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Admin Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Cari katalog buku digital / e-pustaka...',
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D62F1)),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF0D62F1), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // E-MAOS Play Store Launcher Banner
                InkWell(
                  onTap: _openPerpustakaanPlayStore,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D62F1).withAlpha(isDark ? 35 : 15),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF0D62F1), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D62F1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.shop_two_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Aplikasi E-MAOS Perpustakaan',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0D62F1),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Buka langsung link Google Play Store resmi E-MAOS Bojonegoro',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.open_in_new_rounded, color: Color(0xFF0D62F1), size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Digital E-Book Library Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Koleksi E-Book Digital Bojonegoro',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D62F1).withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${filtered.length} Buku',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0D62F1)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Daftar buku digital daerah yang dapat langsung dikelola oleh admin:',
                  style: TextStyle(fontSize: 12.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
                const SizedBox(height: 14),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final book = filtered[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(isDark ? 30 : 6), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D62F1).withAlpha(20),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.menu_book_rounded, color: Color(0xFF0D62F1), size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF8B5CF6).withAlpha(25),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            book.category,
                                            style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 10.5, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF10B981).withAlpha(25),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            book.stock,
                                            style: const TextStyle(color: Color(0xFF10B981), fontSize: 10.5, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      book.title,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Pengarang: ${book.author}',
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      book.description,
                                      style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // File PDF Link
                          Row(
                            children: [
                              const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  book.pdfFileName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // ADMIN ACTION PANEL (EDIT & DELETE BUTTONS)
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => _showAddEditPerpustakaanDialog(book),
                                  icon: const Icon(Icons.edit_rounded, size: 15, color: Color(0xFF0D62F1)),
                                  label: const Text('Edit Buku', style: TextStyle(color: Color(0xFF0D62F1), fontWeight: FontWeight.bold)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF0D62F1)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: () => _confirmDeletePerpustakaan(book),
                                  icon: const Icon(Icons.delete_outline_rounded, size: 15, color: Colors.white),
                                  label: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEF4444),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
