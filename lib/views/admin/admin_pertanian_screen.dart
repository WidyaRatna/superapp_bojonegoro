import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/admin/admin_form_dialog.dart';
import '../../widgets/admin/admin_table_view.dart';

class AdminPertanianScreen extends StatelessWidget {
  const AdminPertanianScreen({super.key});

  void _showAddEditDialog(BuildContext context, [ItemPertanian? existing]) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final typeController = TextEditingController(text: existing?.type ?? 'Nitrogen (N)');
    final priceController = TextEditingController(text: existing?.price ?? 'Rp 2.250 / kg');
    final reqController = TextEditingController(text: existing?.requirements ?? 'Terdaftar di e-RDKK & Kartu Tani');
    final mechController = TextEditingController(text: existing?.mechanism ?? 'Penebusan melalui Kios Pupuk Lengkap (KPL)');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Informasi Pupuk' : 'Tambah Jenis Pupuk Subsidized',
          subtitle: 'Kelola alokasi pupuk bersubsidi, HET, dan mekanisme e-RDKK',
          isEditing: existing != null,
          fields: [
            AdminFormField(
              label: 'Nama Pupuk / Sektor',
              controller: nameController,
              hint: 'Contoh: Pupuk UREA Subsidized',
            ),
            AdminFormField(
              label: 'Kandungan / Jenis',
              controller: typeController,
              hint: 'Nitrogen (N) / Majemuk (NPK)',
            ),
            AdminFormField(
              label: 'Harga Eceran Tertinggi (HET)',
              controller: priceController,
              hint: 'Rp 2.250 / kg',
            ),
            AdminFormField(
              label: 'Persyaratan Penebusan',
              controller: reqController,
              hint: 'Persyaratan wajib petani...',
              isMultiLine: true,
            ),
            AdminFormField(
              label: 'Mekanisme Penyaluran',
              controller: mechController,
              hint: 'Alur penebusan di Kios Pupuk...',
              isMultiLine: true,
            ),
          ],
          onSave: () {
            final service = AdminDataService();
            if (existing != null) {
              existing.name = nameController.text.trim();
              existing.type = typeController.text.trim();
              existing.price = priceController.text.trim();
              existing.requirements = reqController.text.trim();
              existing.mechanism = mechController.text.trim();
              service.updatePertanian(existing);
            } else {
              service.addPertanian(
                ItemPertanian(
                  id: 'PRT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  name: nameController.text.trim(),
                  type: typeController.text.trim(),
                  price: priceController.text.trim(),
                  requirements: reqController.text.trim(),
                  mechanism: mechController.text.trim(),
                ),
              );
            }
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ItemPertanian item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Hapus Data Pupuk'),
          content: Text('Apakah Anda yakin ingin menghapus data pupuk "${item.name}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                AdminDataService().deletePertanian(item.id);
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
        final items = adminService.pertanianList;

        return AdminTableView<ItemPertanian>(
          title: 'Manajemen Informasi Pertanian & Pupuk Subsidized',
          subtitle: 'Kelola jenis pupuk bersubsidi, Harga HET, alokasi e-RDKK, dan syarat penebusan.',
          addNewLabel: 'Tambah Data Pupuk',
          items: items,
          searchFilter: (item, query) =>
              item.name.toLowerCase().contains(query) ||
              item.type.toLowerCase().contains(query),
          onAddNew: () => _showAddEditDialog(context),
          columns: const [
            AdminTableColumn(title: 'ID', width: 90),
            AdminTableColumn(title: 'Jenis / Nama Pupuk', width: 220),
            AdminTableColumn(title: 'Kandungan', width: 140),
            AdminTableColumn(title: 'HET Subsidized', width: 150),
            AdminTableColumn(title: 'Persyaratan & Mekanisme', width: 260),
            AdminTableColumn(title: 'Aksi', width: 120, alignment: Alignment.center),
          ],
          rowBuilder: (item, index) {
            return [
              Text(item.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
              Text(item.type, style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569))),
              Text(item.price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Syarat: ${item.requirements}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: Color(0xFF334155))),
                  Text('Mekanisme: ${item.mechanism}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Color(0xFF0D62F1), size: 18),
                    onPressed: () => _showAddEditDialog(context, item),
                    tooltip: 'Edit Pupuk',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 18),
                    onPressed: () => _confirmDelete(context, item),
                    tooltip: 'Hapus Pupuk',
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
