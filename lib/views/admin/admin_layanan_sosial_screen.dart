import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/superapp_header.dart';
import '../../widgets/admin/admin_form_dialog.dart';
import '../bansos_terpadu_detail_screen.dart';
import '../persyaratan_pelayanan_publik_screen.dart';

class AdminLayananSosialScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminLayananSosialScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  State<AdminLayananSosialScreen> createState() => _AdminLayananSosialScreenState();
}

class _AdminLayananSosialScreenState extends State<AdminLayananSosialScreen> {
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

  // Dialog Tambah & Edit Layanan Sosial
  void _showAddEditDialog([ItemLayananSosial? existing]) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final descController = TextEditingController(text: existing?.description ?? '');
    final categoryController = TextEditingController(text: existing?.category ?? 'Layanan Unggulan');
    final reqController = TextEditingController(text: existing?.requirement ?? 'KTP, KK, & Surat Keterangan Desa');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Layanan Sosial' : 'Tambah Layanan Unggulan Baru',
          subtitle: 'Kelola judul, deskripsi, & persyaratan menu layanan sosial',
          isEditing: existing != null,
          fields: [
            AdminFormField(
              label: 'Judul Layanan',
              controller: titleController,
              hint: 'Contoh: Bantuan Sosial Terpadu',
            ),
            AdminFormField(
              label: 'Deskripsi Singkat',
              controller: descController,
              hint: 'Tuliskan deskripsi ringkas layanan sosial...',
              isMultiLine: true,
            ),
            AdminFormField(
              label: 'Kategori Menu',
              controller: categoryController,
              hint: 'Layanan Unggulan / Persyaratan / Informasi',
            ),
            AdminFormField(
              label: 'Persyaratan Utama',
              controller: reqController,
              hint: 'KTP, KK, SKTM Desa',
            ),
          ],
          onSave: () {
            final service = AdminDataService();
            if (existing != null) {
              existing.title = titleController.text.trim().isEmpty ? 'Layanan Sosial' : titleController.text.trim();
              existing.description = descController.text.trim().isEmpty ? 'Deskripsi layanan sosial.' : descController.text.trim();
              existing.category = categoryController.text.trim().isEmpty ? 'Layanan Unggulan' : categoryController.text.trim();
              existing.requirement = reqController.text.trim().isEmpty ? 'Dokumen KTP & KK' : reqController.text.trim();
              service.updateLayananSosial(existing);
            } else {
              service.addLayananSosial(
                ItemLayananSosial(
                  id: 'SOS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  title: titleController.text.trim().isEmpty ? 'Layanan Baru' : titleController.text.trim(),
                  category: categoryController.text.trim().isEmpty ? 'Layanan Unggulan' : categoryController.text.trim(),
                  description: descController.text.trim().isEmpty ? 'Deskripsi layanan sosial Dinas Sosial Bojonegoro.' : descController.text.trim(),
                  requirement: reqController.text.trim().isEmpty ? 'Dokumen KTP & KK' : reqController.text.trim(),
                  mechanism: 'Pengajuan Mandiri / Dinsos Bojonegoro',
                ),
              );
            }
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(existing != null ? 'Layanan Sosial diperbarui!' : 'Layanan Sosial baru berhasil ditambahkan!'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
          },
        );
      },
    );
  }

  // Dialog Konfirmasi Hapus Item
  void _confirmDelete(ItemLayananSosial item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 24),
            SizedBox(width: 8),
            Text('Hapus Layanan'),
          ],
        ),
        content: Text('Apakah Anda yakin ingin menghapus "${item.title}" dari menu layanan sosial?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              AdminDataService().deleteLayananSosial(item.id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${item.title}" telah dihapus.'),
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

    // Palette definition identical to User LayananSosialScreen
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
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddEditDialog(),
            backgroundColor: const Color(0xFF0D62F1),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text(
              'Tambah Layanan',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
              SuperAppHeader(
                title: 'Layanan Sosial',
                subtitle: 'Dinas Sosial Kabupaten Bojonegoro',
                gradient: headerGradient,
                isDarkMode: isDark,
                onToggleDarkMode: widget.onToggleDarkMode,
              ),

              // 2. Scrollable Body Content (100% User UI Parity + CRUD Buttons Below Cards)
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
                                    _buildAdminCompactServiceTile(
                                      item: item,
                                      actionText: item.id == 'SOS-002' ? 'Info Detail' : 'Lihat Layanan',
                                      icon: item.id == 'SOS-002' ? Icons.assignment_outlined : Icons.volunteer_activism_outlined,
                                      primaryColor: primaryBlue,
                                      textMain: textMain,
                                      textSecondary: textSecondary,
                                      isDark: isDark,
                                      onTap: onTapAction,
                                      canDelete: item.id != 'SOS-001' && item.id != 'SOS-002',
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

                          const SizedBox(height: 80),
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

  // Section Header Title (Identical to User UI)
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

  // Compact Tile Item Layout Identical to User UI + CRUD Action Buttons Directly Underneath
  Widget _buildAdminCompactServiceTile({
    required ItemLayananSosial item,
    required String actionText,
    required IconData icon,
    required Color primaryColor,
    required Color textMain,
    required Color textSecondary,
    required bool isDark,
    required VoidCallback onTap,
    bool canDelete = true,
  }) {
    return Column(
      children: [
        Material(
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
                          item.title,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: textMain,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.description,
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
        ),

        // CRUD Action Buttons Directly Underneath the Tile Item
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? const Color(0xFF3B82F6).withAlpha(80) : const Color(0xFFBAE6FD),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D62F1).withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 15,
                        color: Color(0xFF0D62F1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Kelola Item',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E40AF),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Edit Button - Solid Elevated Button for high contrast
                    ElevatedButton.icon(
                      onPressed: () => _showAddEditDialog(item),
                      icon: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                      label: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D62F1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    if (canDelete) ...[
                      const SizedBox(width: 8),
                      // Hapus Button
                      ElevatedButton.icon(
                        onPressed: () => _confirmDelete(item),
                        icon: const Icon(Icons.delete_outline_rounded, size: 14, color: Colors.white),
                        label: const Text(
                          'Hapus',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
