import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/superapp_header.dart';
import '../../widgets/admin/admin_form_dialog.dart';

class AdminKependudukanScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminKependudukanScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  State<AdminKependudukanScreen> createState() => _AdminKependudukanScreenState();
}

class _AdminKependudukanScreenState extends State<AdminKependudukanScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditDialog([ItemKependudukan? existing]) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final categoryController = TextEditingController(text: existing?.category ?? 'Pendaftaran Penduduk');
    final descController = TextEditingController(text: existing?.description ?? '');
    final pdfController = TextEditingController(text: existing?.pdfFileName ?? 'Persyaratan.pdf');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Layanan Kependudukan' : 'Tambah Layanan Kependudukan',
          subtitle: 'Kelola informasi layanan Disdukcapil & dokumen persyaratan PDF',
          isEditing: existing != null,
          initialPdfName: existing?.pdfFileName ?? 'Dokumen_Persyaratan.pdf',
          fields: [
            AdminFormField(
              label: 'Nama Layanan Kependudukan',
              controller: titleController,
              hint: 'Contoh: Penerbitan Kartu Keluarga (KK) Baru',
            ),
            AdminFormField(
              label: 'Kategori Layanan',
              controller: categoryController,
              hint: 'Pilih kategori',
              options: const ['Pendaftaran Penduduk', 'Pencatatan Sipil', 'Identitas Kependudukan (IKD)'],
            ),
            AdminFormField(
              label: 'Deskripsi & Mekanisme Singkat',
              controller: descController,
              hint: 'Jelaskan syarat dan alur pengajuan...',
              isMultiLine: true,
            ),
            AdminFormField(
              label: 'Nama File PDF Persyaratan',
              controller: pdfController,
              hint: 'Syarat_Dokumen.pdf',
            ),
          ],
          onSave: () {
            final service = AdminDataService();

            if (existing != null) {
              existing.title = titleController.text.trim();
              existing.category = categoryController.text.trim();
              existing.description = descController.text.trim();
              existing.pdfFileName = pdfController.text.trim();
              service.updateKependudukan(existing);
            } else {
              service.addKependudukan(
                ItemKependudukan(
                  id: 'KPD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  title: titleController.text.trim(),
                  category: categoryController.text.trim(),
                  description: descController.text.trim(),
                  pdfFileName: pdfController.text.trim().isEmpty ? 'Syarat_Dokumen.pdf' : pdfController.text.trim(),
                ),
              );
            }
          },
        );
      },
    );
  }

  void _confirmDelete(ItemKependudukan item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Hapus Layanan'),
          content: Text('Apakah Anda yakin ingin menghapus "${item.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                AdminDataService().deleteKependudukan(item.id);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
    final adminService = AdminDataService();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: const Color(0xFF0D62F1),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Tambah Layanan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Kelola Kependudukan',
            subtitle: 'Admin Panel • SuperApp Bojonegoro',
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),
          const SizedBox(height: 12),

          // Search Bar (User Style)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? Border.all(color: const Color(0xFF334155)) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 13.5),
                decoration: InputDecoration(
                  hintText: 'Cari layanan kependudukan Disdukcapil...',
                  hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 13.5),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D62F1), size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // List of Kependudukan Cards (User Parity + Admin Controls)
          Expanded(
            child: ListenableBuilder(
              listenable: adminService,
              builder: (context, child) {
                final list = adminService.kependudukanList.where((k) {
                  if (_searchQuery.trim().isEmpty) return true;
                  final q = _searchQuery.toLowerCase();
                  return k.title.toLowerCase().contains(q) ||
                      k.category.toLowerCase().contains(q) ||
                      k.description.toLowerCase().contains(q);
                }).toList();

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.badge_outlined, size: 54, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada layanan kependudukan',
                          style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = list[index];

                    return Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 50 : 15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D62F1).withAlpha(isDark ? 40 : 15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.badge_rounded, color: Color(0xFF0D62F1), size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0D62F1).withAlpha(15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item.category,
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF0D62F1), fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
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
                            item.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // PDF Attachment Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFEF4444), size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.pdfFileName,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                ),
                                const Icon(Icons.download_rounded, color: Color(0xFF0D62F1), size: 18),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 12),

                          // Admin Actions Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => _showAddEditDialog(item),
                                icon: const Icon(Icons.edit_rounded, size: 16, color: Color(0xFF0D62F1)),
                                label: const Text('Edit Layanan', style: TextStyle(fontSize: 12.5, color: Color(0xFF0D62F1), fontWeight: FontWeight.bold)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF0D62F1)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () => _confirmDelete(item),
                                icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.white),
                                label: const Text('Hapus', style: TextStyle(fontSize: 12.5, color: Colors.white, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
