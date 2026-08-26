import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/admin/admin_form_dialog.dart';
import '../../widgets/admin/admin_table_view.dart';

class AdminKontakInstansiScreen extends StatelessWidget {
  const AdminKontakInstansiScreen({super.key});

  void _showAddEditDialog(BuildContext context, [ItemKontakInstansi? existing]) {
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
                  agencyName: nameController.text.trim(),
                  address: addressController.text.trim(),
                  phone: phoneController.text.trim(),
                  email: emailController.text.trim(),
                  operatingHours: hoursController.text.trim(),
                ),
              );
            }
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ItemKontakInstansi item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Hapus Kontak Instansi'),
          content: Text('Apakah Anda yakin ingin menghapus kontak "${item.agencyName}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                AdminDataService().deleteKontakInstansi(item.id);
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
        final items = adminService.kontakInstansiList;

        return AdminTableView<ItemKontakInstansi>(
          title: 'Manajemen Kontak Instansi Pemkab',
          subtitle: 'Kelola direktori alamat, telepon, email, & jam pelayanan seluruh Dinas Bojonegoro.',
          addNewLabel: 'Tambah Instansi',
          items: items,
          searchFilter: (item, query) =>
              item.agencyName.toLowerCase().contains(query) ||
              item.address.toLowerCase().contains(query),
          onAddNew: () => _showAddEditDialog(context),
          columns: const [
            AdminTableColumn(title: 'ID', width: 90),
            AdminTableColumn(title: 'Nama Instansi', width: 240),
            AdminTableColumn(title: 'Alamat', width: 200),
            AdminTableColumn(title: 'Kontak & Email', width: 200),
            AdminTableColumn(title: 'Jam Operasional', width: 180),
            AdminTableColumn(title: 'Aksi', width: 120, alignment: Alignment.center),
          ],
          rowBuilder: (item, index) {
            return [
              Text(item.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(item.agencyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
              Text(item.address, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Telp: ${item.phone}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0D62F1))),
                  Text(item.email, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                ],
              ),
              Text(item.operatingHours, style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Color(0xFF0D62F1), size: 18),
                    onPressed: () => _showAddEditDialog(context, item),
                    tooltip: 'Edit Instansi',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 18),
                    onPressed: () => _confirmDelete(context, item),
                    tooltip: 'Hapus Instansi',
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
