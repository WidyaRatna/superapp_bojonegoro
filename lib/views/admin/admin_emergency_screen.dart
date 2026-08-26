import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/admin/admin_form_dialog.dart';
import '../../widgets/admin/admin_table_view.dart';

class AdminEmergencyScreen extends StatelessWidget {
  const AdminEmergencyScreen({super.key});

  void _showAddEditDialog(BuildContext context, [ItemEmergencyCall? existing]) {
    final nameController = TextEditingController(text: existing?.serviceName ?? '');
    final hotlineController = TextEditingController(text: existing?.hotline ?? '');
    final categoryController = TextEditingController(text: existing?.category ?? 'Umum / Tanggap Darurat');
    final descController = TextEditingController(text: existing?.description ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Nomor Darurat' : 'Tambah Layanan Darurat Baru',
          subtitle: 'Kelola nomor panggilan darurat 24 jam Bojonegoro (Call Center / Damkar / Medis)',
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
                  serviceName: nameController.text.trim(),
                  hotline: hotlineController.text.trim(),
                  category: categoryController.text.trim(),
                  description: descController.text.trim(),
                ),
              );
            }
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ItemEmergencyCall item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Hapus Layanan Darurat'),
          content: Text('Apakah Anda yakin ingin menghapus hotline "${item.serviceName}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                AdminDataService().deleteEmergency(item.id);
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
    final adminService = AdminDataService();

    return ListenableBuilder(
      listenable: adminService,
      builder: (context, child) {
        final items = adminService.emergencyList;

        return AdminTableView<ItemEmergencyCall>(
          title: 'Manajemen Layanan & Kontak Darurat',
          subtitle: 'Kelola daftar hotline tanggap darurat (112, Damkar, Ambulans, Kepolisian) untuk warga.',
          addNewLabel: 'Tambah Nomor Darurat',
          items: items,
          searchFilter: (item, query) =>
              item.serviceName.toLowerCase().contains(query) ||
              item.hotline.toLowerCase().contains(query) ||
              item.category.toLowerCase().contains(query),
          onAddNew: () => _showAddEditDialog(context),
          columns: const [
            AdminTableColumn(title: 'ID', width: 90),
            AdminTableColumn(title: 'Nama Layanan Darurat', width: 220),
            AdminTableColumn(title: 'Nomor Hotline', width: 150),
            AdminTableColumn(title: 'Kategori', width: 170),
            AdminTableColumn(title: 'Keterangan Layanan', width: 240),
            AdminTableColumn(title: 'Aksi', width: 120, alignment: Alignment.center),
          ],
          rowBuilder: (item, index) {
            return [
              Text(item.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.red.withAlpha(20), shape: BoxShape.circle),
                    child: const Icon(Icons.phone_in_talk_rounded, color: Colors.red, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item.serviceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.red.withAlpha(20), borderRadius: BorderRadius.circular(6)),
                child: Text(item.hotline, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(20)),
                child: Text(item.category, style: const TextStyle(color: Color(0xFF0D62F1), fontWeight: FontWeight.bold, fontSize: 11.5)),
              ),
              Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Color(0xFF0D62F1), size: 18),
                    onPressed: () => _showAddEditDialog(context, item),
                    tooltip: 'Edit Nomor',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 18),
                    onPressed: () => _confirmDelete(context, item),
                    tooltip: 'Hapus Nomor',
                  ),
                ],
              ),
            ];
          },
        );
      },
    );
  }
}
