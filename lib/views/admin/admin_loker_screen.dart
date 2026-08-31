import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/superapp_header.dart';
import '../../widgets/admin/admin_form_dialog.dart';

class AdminLokerScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminLokerScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  State<AdminLokerScreen> createState() => _AdminLokerScreenState();
}

class _AdminLokerScreenState extends State<AdminLokerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditDialog([ItemLokerAdmin? existing]) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final companyController = TextEditingController(text: existing?.company ?? '');
    final locationController = TextEditingController(text: existing?.location ?? 'Bojonegoro');
    final salaryController = TextEditingController(text: existing?.salary ?? 'Rp 3.000.000 - Rp 4.500.000');
    final categoryController = TextEditingController(text: existing?.category ?? 'Swasta / UMKM');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Lowongan Kerja' : 'Tambah Loker Baru',
          subtitle: 'Kelola informasi lowongan pekerjaan daerah Bojonegoro',
          isEditing: existing != null,
          fields: [
            AdminFormField(
              label: 'Judul Posisi Pekerjaan',
              controller: titleController,
              hint: 'Contoh: Staf Administrasi & Kasir',
            ),
            AdminFormField(
              label: 'Nama Perusahaan / PT / Instansi',
              controller: companyController,
              hint: 'PT Surya Bojonegoro',
            ),
            AdminFormField(
              label: 'Lokasi Kerja',
              controller: locationController,
              hint: 'Kec. Bojonegoro, Kab. Bojonegoro',
            ),
            AdminFormField(
              label: 'Kategori Sektor',
              controller: categoryController,
              hint: 'Swasta / Industri / Perbankan / BUMD',
            ),
            AdminFormField(
              label: 'Kisaran Gaji',
              controller: salaryController,
              hint: 'Rp 3.000.000 - Rp 4.500.000',
            ),
          ],
          onSave: () {
            final service = AdminDataService();
            if (existing != null) {
              existing.title = titleController.text.trim();
              existing.company = companyController.text.trim();
              existing.location = locationController.text.trim();
              existing.salary = salaryController.text.trim();
              existing.category = categoryController.text.trim();
              service.updateLoker(existing);
            } else {
              service.addLoker(
                ItemLokerAdmin(
                  id: 'LOK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  title: titleController.text.trim().isEmpty ? 'Posisi Kerja Baru' : titleController.text.trim(),
                  company: companyController.text.trim().isEmpty ? 'Perusahaan Mitra Bojonegoro' : companyController.text.trim(),
                  location: locationController.text.trim().isEmpty ? 'Bojonegoro' : locationController.text.trim(),
                  salary: salaryController.text.trim().isEmpty ? 'Sesuai UMK Bojonegoro' : salaryController.text.trim(),
                  category: categoryController.text.trim().isEmpty ? 'Swasta' : categoryController.text.trim(),
                  postedDate: 'Hari Ini',
                  status: 'Terverifikasi',
                ),
              );
            }
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(existing != null ? 'Loker berhasil diperbarui!' : 'Loker baru berhasil dipublikasi!'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(ItemLokerAdmin item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Lowongan Kerja'),
        content: Text('Apakah Anda yakin ingin menghapus lowongan "${item.title}" dari ${item.company}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AdminDataService().deleteLoker(item.id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Loker "${item.title}" telah dihapus.'),
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
    final items = AdminDataService().lokerList;
    final filtered = items.where((loker) {
      final q = _searchQuery.toLowerCase();
      return loker.title.toLowerCase().contains(q) || loker.company.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: const Color(0xFF0D62F1),
        icon: const Icon(Icons.work_history_rounded, color: Colors.white),
        label: const Text(
          'Tambah Loker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Kelola Lowongan Kerja',
            subtitle: 'Publikasi, verifikasi, edit & hapus loker Bojonegoro',
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Cari posisi pekerjaan atau nama perusahaan...',
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
            const SizedBox(height: 16),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = filtered[index];
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
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D62F1).withAlpha(isDark ? 40 : 15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(Icons.business_center_rounded, color: Color(0xFF0D62F1), size: 24),
                            ),
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
                                  item.company,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withAlpha(isDark ? 40 : 20),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item.status,
                              style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(
                            item.location,
                            style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          ),
                          const Spacer(),
                          const Icon(Icons.payments_rounded, size: 14, color: Color(0xFF10B981)),
                          const SizedBox(width: 4),
                          Text(
                            item.salary,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
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
                            onPressed: () => _showAddEditDialog(item),
                            icon: const Icon(Icons.edit_rounded, size: 15, color: Color(0xFF0D62F1)),
                            label: const Text('Edit', style: TextStyle(color: Color(0xFF0D62F1), fontWeight: FontWeight.bold)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF0D62F1)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () => _confirmDelete(item),
                            icon: const Icon(Icons.delete_outline_rounded, size: 15, color: Colors.white),
                            label: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEF4444),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            ),
                          ),
                        ],
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
    ),
  ],
),
    );
  }
}
