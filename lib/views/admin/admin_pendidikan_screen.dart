import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/admin/admin_form_dialog.dart';
import '../../widgets/admin/admin_table_view.dart';

class AdminPendidikanScreen extends StatelessWidget {
  const AdminPendidikanScreen({super.key});

  void _showAddEditDialog(BuildContext context, [ItemBeasiswa? existing]) {
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
          subtitle: 'Kelola program beasiswa Pemkab Bojonegoro & berkas persyaratan PDF',
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
                  title: titleController.text.trim(),
                  provider: providerController.text.trim(),
                  quota: quotaController.text.trim(),
                  deadline: deadlineController.text.trim(),
                  pdfFileName: pdfController.text.trim(),
                ),
              );
            }
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ItemBeasiswa item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Hapus Program Beasiswa'),
          content: Text('Apakah Anda yakin ingin menghapus beasiswa "${item.title}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                AdminDataService().deleteBeasiswa(item.id);
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
        final items = adminService.beasiswaList;

        return AdminTableView<ItemBeasiswa>(
          title: 'Manajemen Pendidikan & Beasiswa',
          subtitle: 'Kelola program beasiswa daerah, kuota, periode pendaftaran, dan lampiran PDF.',
          addNewLabel: 'Tambah Program Beasiswa',
          items: items,
          searchFilter: (item, query) =>
              item.title.toLowerCase().contains(query) ||
              item.provider.toLowerCase().contains(query),
          onAddNew: () => _showAddEditDialog(context),
          columns: const [
            AdminTableColumn(title: 'ID', width: 90),
            AdminTableColumn(title: 'Nama Program Beasiswa', width: 240),
            AdminTableColumn(title: 'Penyelenggara', width: 180),
            AdminTableColumn(title: 'Kuota & Deadline', width: 160),
            AdminTableColumn(title: 'Dokumen PDF', width: 180),
            AdminTableColumn(title: 'Aksi', width: 120, alignment: Alignment.center),
          ],
          rowBuilder: (item, index) {
            return [
              Text(item.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
              Text(item.provider, style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kuota: ${item.quota}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0D62F1))),
                  Text('Batas: ${item.deadline}', style: const TextStyle(fontSize: 11.5, color: Color(0xFFEF4444))),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(item.pdfFileName, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Color(0xFF0D62F1), size: 18),
                    onPressed: () => _showAddEditDialog(context, item),
                    tooltip: 'Edit Beasiswa',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 18),
                    onPressed: () => _confirmDelete(context, item),
                    tooltip: 'Hapus Beasiswa',
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
