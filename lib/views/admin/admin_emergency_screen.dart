import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/superapp_header.dart';
import '../../widgets/admin/admin_form_dialog.dart';

class AdminEmergencyScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminEmergencyScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  State<AdminEmergencyScreen> createState() => _AdminEmergencyScreenState();
}

class _AdminEmergencyScreenState extends State<AdminEmergencyScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditDialog([ItemEmergencyCall? existing]) {
    final nameController = TextEditingController(text: existing?.serviceName ?? '');
    final hotlineController = TextEditingController(text: existing?.hotline ?? '');
    final categoryController = TextEditingController(text: existing?.category ?? 'Umum / Tanggap Darurat');
    final descController = TextEditingController(text: existing?.description ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Nomor Darurat' : 'Tambah Layanan Darurat Baru',
          subtitle: 'Kelola nomor panggilan darurat 24 jam Bojonegoro (112 / Damkar / Medis)',
          isEditing: existing != null,
          fields: [
            AdminFormField(
              label: 'Nama Layanan Darurat',
              controller: nameController,
              hint: 'Contoh: Call Center Bojonegoro 112',
            ),
            AdminFormField(
              label: 'Nomor Telepon / Hotline Darurat',
              controller: hotlineController,
              hint: '112 / (0353) 113',
            ),
            AdminFormField(
              label: 'Kategori Kedaruratan',
              controller: categoryController,
              options: const ['Umum / Tanggap Darurat', 'Kebakaran & Penyelamatan', 'Medis', 'Kepolisian', 'Bencana Alam'],
            ),
            AdminFormField(
              label: 'Deskripsi Informasi Layanan',
              controller: descController,
              hint: 'Tuliskan ruang lingkup kedaruratan...',
              isMultiLine: true,
            ),
          ],
          onSave: () {
            final service = AdminDataService();
            if (existing != null) {
              existing.serviceName = nameController.text.trim();
              existing.hotline = hotlineController.text.trim();
              existing.category = categoryController.text.trim();
              existing.description = descController.text.trim();
              service.updateEmergency(existing);
            } else {
              service.addEmergency(
                ItemEmergencyCall(
                  id: 'EMG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  serviceName: nameController.text.trim().isEmpty ? 'Layanan Darurat Baru' : nameController.text.trim(),
                  hotline: hotlineController.text.trim().isEmpty ? '112' : hotlineController.text.trim(),
                  category: categoryController.text.trim().isEmpty ? 'Tanggap Darurat' : categoryController.text.trim(),
                  description: descController.text.trim().isEmpty ? 'Layanan siaga 24 jam Pemkab Bojonegoro' : descController.text.trim(),
                ),
              );
            }
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(existing != null ? 'Nomor darurat diperbarui!' : 'Nomor darurat baru ditambahkan!'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(ItemEmergencyCall item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Panggilan Darurat'),
        content: Text('Apakah Anda yakin ingin menghapus "${item.serviceName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AdminDataService().deleteEmergency(item.id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Nomor darurat "${item.serviceName}" telah dihapus.'),
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
    final emergencyGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF881337), Color(0xFF9F1239)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE11D48), Color(0xFFF43F5E)],
          );

    final items = AdminDataService().emergencyList;
    final filtered = items.where((emg) {
      final q = _searchQuery.toLowerCase();
      return emg.serviceName.toLowerCase().contains(q) || emg.hotline.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: const Color(0xFFE11D48),
        icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white),
        label: const Text(
          'Tambah Panggilan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Kelola Layanan Darurat 112',
            subtitle: 'Nomor siaga 24 jam Pemkab Bojonegoro',
            gradient: emergencyGradient,
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Cari nomor darurat / hotline...',
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFE11D48)),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE11D48), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Nomor Panggilan Darurat Siaga',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),

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
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE11D48).withAlpha(isDark ? 40 : 15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.support_agent_rounded, color: Color(0xFFE11D48), size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.serviceName,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Kategori: ${item.category}',
                                        style: const TextStyle(fontSize: 12, color: Color(0xFFE11D48), fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444).withAlpha(isDark ? 30 : 12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '📞 ${item.hotline}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFE11D48)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.description,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => _showAddEditDialog(item),
                                  icon: const Icon(Icons.edit_rounded, size: 15, color: Color(0xFFE11D48)),
                                  label: const Text('Edit Nomor', style: TextStyle(color: Color(0xFFE11D48), fontWeight: FontWeight.bold)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFE11D48)),
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
