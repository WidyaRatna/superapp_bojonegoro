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
    final companyController = TextEditingController(text: existing?.companyName ?? '');
    final categoryController = TextEditingController(text: existing?.category ?? 'Teknologi & IT');
    final salaryController = TextEditingController(text: existing?.salaryRange ?? 'Rp 3.500.000 - Rp 5.000.000');
    final descController = TextEditingController(text: existing?.description ?? '');
    final contactController = TextEditingController(text: existing?.contactPhone ?? '081234567890');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Lowongan Kerja' : 'Tambah Lowongan Kerja',
          subtitle: 'Kelola informasi lowongan pekerjaan daerah & status verifikasi',
          isEditing: existing != null,
          fields: [
            AdminFormField(
              label: 'Judul Posisi Lowongan',
              controller: titleController,
              hint: 'Contoh: Frontend Developer',
            ),
            AdminFormField(
              label: 'Nama Perusahaan / Usaha',
              controller: companyController,
              hint: 'PT Bojonegoro Teknologi Utama',
            ),
            AdminFormField(
              label: 'Kategori Pekerjaan',
              controller: categoryController,
              hint: 'Pilih kategori',
              options: const ['Teknologi & IT', 'Administrasi & Keuangan', 'Pemasaran & Penjualan', 'Industri & Teknik', 'Jasa & Pelayanan'],
            ),
            AdminFormField(
              label: 'Kisaran Gaji / Insentif',
              controller: salaryController,
              hint: 'Rp 3.500.000 - Rp 5.000.000',
            ),
            AdminFormField(
              label: 'Deskripsi Kebutuhan & Syarat',
              controller: descController,
              hint: 'Jelaskan kualifikasi calon pelamar...',
              isMultiLine: true,
            ),
            AdminFormField(
              label: 'Nomor Kontak HP / WA',
              controller: contactController,
              hint: '081234567890',
            ),
          ],
          onSave: () {
            final service = AdminDataService();

            if (existing != null) {
              existing.title = titleController.text.trim();
              existing.companyName = companyController.text.trim();
              existing.category = categoryController.text.trim();
              existing.salaryRange = salaryController.text.trim();
              existing.description = descController.text.trim();
              existing.contactPhone = contactController.text.trim();
              service.updateLoker(existing);
            } else {
              service.addLoker(
                ItemLokerAdmin(
                  id: 'LKR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  title: titleController.text.trim(),
                  company: companyController.text.trim(),
                  location: 'Bojonegoro',
                  salary: salaryController.text.trim(),
                  category: categoryController.text.trim(),
                  description: descController.text.trim(),
                  contactPhone: contactController.text.trim(),
                  postedDate: '24 Agustus 2026',
                  status: 'Terverifikasi',
                ),
              );
            }
          },
        );
      },
    );
  }

  void _confirmDelete(ItemLokerAdmin item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Hapus Lowongan'),
          content: Text('Apakah Anda yakin ingin menghapus "${item.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                AdminDataService().deleteLoker(item.id);
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
          'Tambah Loker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Kelola Lowongan Kerja',
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
                  hintText: 'Cari posisi lowongan atau perusahaan...',
                  hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 13.5),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D62F1), size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // List of Job Cards (User Parity + Verification Controls)
          Expanded(
            child: ListenableBuilder(
              listenable: adminService,
              builder: (context, child) {
                final list = adminService.lokerList.where((job) {
                  if (_searchQuery.trim().isEmpty) return true;
                  final q = _searchQuery.toLowerCase();
                  return job.title.toLowerCase().contains(q) ||
                      job.companyName.toLowerCase().contains(q) ||
                      job.category.toLowerCase().contains(q);
                }).toList();

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.work_outline_rounded, size: 54, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada data lowongan kerja',
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

                    Color statusColor;
                    IconData statusIcon;
                    if (item.status == 'Terverifikasi') {
                      statusColor = const Color(0xFF10B981);
                      statusIcon = Icons.check_circle_rounded;
                    } else if (item.status == 'Ditolak') {
                      statusColor = const Color(0xFFEF4444);
                      statusIcon = Icons.cancel_rounded;
                    } else {
                      statusColor = Colors.amber.shade700;
                      statusIcon = Icons.hourglass_top_rounded;
                    }

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
                                child: const Icon(Icons.work_rounded, color: Color(0xFF0D62F1), size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item.companyName,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Status Verification Badge Dropdown/Button
                              PopupMenuButton<String>(
                                onSelected: (val) {
                                  adminService.updateLokerStatus(item.id, val);
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'Terverifikasi',
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                                        SizedBox(width: 8),
                                        Text('Setujui (Terverifikasi)'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'Menunggu Verifikasi',
                                    child: Row(
                                      children: [
                                        Icon(Icons.hourglass_top_rounded, color: Colors.amber, size: 18),
                                        SizedBox(width: 8),
                                        Text('Pending (Menunggu)'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'Ditolak',
                                    child: Row(
                                      children: [
                                        Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 18),
                                        SizedBox(width: 8),
                                        Text('Tolak Loker'),
                                      ],
                                    ),
                                  ),
                                ],
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withAlpha(20),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: statusColor.withAlpha(50)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(statusIcon, color: statusColor, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        item.status,
                                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11.5),
                                      ),
                                      const SizedBox(width: 2),
                                      Icon(Icons.arrow_drop_down_rounded, color: statusColor, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Salary & Category Row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withAlpha(15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.salaryRange,
                                  style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.category,
                                  style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569), fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Text(
                            item.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                                label: const Text('Edit Loker', style: TextStyle(fontSize: 12.5, color: Color(0xFF0D62F1), fontWeight: FontWeight.bold)),
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
