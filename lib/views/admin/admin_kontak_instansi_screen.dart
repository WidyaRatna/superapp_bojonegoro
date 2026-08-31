import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/superapp_header.dart';
import '../../widgets/admin/admin_form_dialog.dart';

class AdminKontakInstansiScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminKontakInstansiScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  State<AdminKontakInstansiScreen> createState() => _AdminKontakInstansiScreenState();
}

class _AdminKontakInstansiScreenState extends State<AdminKontakInstansiScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditDialog([ItemKontakInstansi? existing]) {
    final nameController = TextEditingController(text: existing?.agencyName ?? '');
    final addressController = TextEditingController(text: existing?.address ?? '');
    final phoneController = TextEditingController(text: existing?.phone ?? '');
    final emailController = TextEditingController(text: existing?.email ?? '');
    final hoursController = TextEditingController(text: existing?.operatingHours ?? 'Senin - Jumat (07.30 - 15.30 WIB)');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Kontak Instansi' : 'Tambah Kontak Instansi Baru',
          subtitle: 'Kelola direktori kontak dinas/instansi Pemkab Bojonegoro',
          isEditing: existing != null,
          fields: [
            AdminFormField(
              label: 'Nama Instansi / Dinas',
              controller: nameController,
              hint: 'Dinas Kependudukan dan Pencatatan Sipil',
            ),
            AdminFormField(
              label: 'Alamat Kantor',
              controller: addressController,
              hint: 'Jl. Pattimura No. 26, Bojonegoro',
            ),
            AdminFormField(
              label: 'Nomor Telepon / Hotline',
              controller: phoneController,
              hint: '(0353) 881513',
            ),
            AdminFormField(
              label: 'Email Resmi',
              controller: emailController,
              hint: 'disdukcapil@bojonegorkab.go.id',
            ),
            AdminFormField(
              label: 'Jam Operasional Layanan',
              controller: hoursController,
              hint: 'Senin - Jumat (07.30 - 15.30 WIB)',
            ),
          ],
          onSave: () {
            final service = AdminDataService();
            if (existing != null) {
              existing.agencyName = nameController.text.trim();
              existing.address = addressController.text.trim();
              existing.phone = phoneController.text.trim();
              existing.email = emailController.text.trim();
              existing.operatingHours = hoursController.text.trim();
              service.updateKontakInstansi(existing);
            } else {
              service.addKontakInstansi(
                ItemKontakInstansi(
                  id: 'INS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  agencyName: nameController.text.trim().isEmpty ? 'Dinas Pemkab' : nameController.text.trim(),
                  address: addressController.text.trim().isEmpty ? 'Bojonegoro' : addressController.text.trim(),
                  phone: phoneController.text.trim().isEmpty ? '(0353) 881234' : phoneController.text.trim(),
                  email: emailController.text.trim().isEmpty ? 'info@bojonegorkab.go.id' : emailController.text.trim(),
                  operatingHours: hoursController.text.trim().isEmpty ? 'Senin - Jumat (07.30 - 15.30 WIB)' : hoursController.text.trim(),
                ),
              );
            }
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(existing != null ? 'Kontak instansi diperbarui!' : 'Kontak instansi baru ditambahkan!'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(ItemKontakInstansi item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Kontak Instansi'),
        content: Text('Apakah Anda yakin ingin menghapus "${item.agencyName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AdminDataService().deleteKontakInstansi(item.id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Instansi "${item.agencyName}" telah dihapus.'),
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
    final items = AdminDataService().kontakInstansiList;
    final filtered = items.where((instansi) {
      final q = _searchQuery.toLowerCase();
      return instansi.agencyName.toLowerCase().contains(q) || instansi.address.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: const Color(0xFF0D62F1),
        icon: const Icon(Icons.corporate_fare_rounded, color: Colors.white),
        label: const Text(
          'Tambah Instansi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Kelola Direktori Instansi',
            subtitle: 'Kontak dinas & OPD Pemkab Bojonegoro',
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
                      hintText: 'Cari nama dinas / instansi...',
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

                  Text(
                    'Daftar Dinas & OPD',
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
                                    color: const Color(0xFF0D62F1).withAlpha(isDark ? 40 : 15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.account_balance_rounded, color: Color(0xFF0D62F1), size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.agencyName,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.address,
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                const Icon(Icons.phone_rounded, color: Color(0xFF0D62F1), size: 16),
                                const SizedBox(width: 6),
                                Text(item.phone, style: TextStyle(fontSize: 12, color: isDark ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                                const SizedBox(width: 16),
                                const Icon(Icons.email_rounded, color: Color(0xFF0D62F1), size: 16),
                                const SizedBox(width: 6),
                                Expanded(child: Text(item.email, style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)), overflow: TextOverflow.ellipsis)),
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
                                  label: const Text('Edit Instansi', style: TextStyle(color: Color(0xFF0D62F1), fontWeight: FontWeight.bold)),
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
