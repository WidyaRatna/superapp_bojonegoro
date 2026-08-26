import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/admin/admin_form_dialog.dart';
import '../../widgets/admin/admin_table_view.dart';

class AdminLayananSosialScreen extends StatelessWidget {
  const AdminLayananSosialScreen({super.key});

  void _showAddEditDialog(BuildContext context, [ItemLayananSosial? existing]) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final categoryController = TextEditingController(text: existing?.category ?? 'Bansos');
    final descController = TextEditingController(text: existing?.description ?? '');
    final reqController = TextEditingController(text: existing?.requirement ?? 'Terdaftar di DTKS');
    final mechController = TextEditingController(text: existing?.mechanism ?? 'Pencairan berkala melalui Himbara/Pos');
    final pdfController = TextEditingController(text: existing?.pdfFileName ?? 'Persyaratan_Bantuan_Sosial.pdf');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Layanan Sosial' : 'Tambah Program Layanan Sosial',
          subtitle: 'Kelola program bansos, rumah singgah, rujukan, & dokumen persyaratan PDF',
          isEditing: existing != null,
          initialPdfName: existing?.pdfFileName ?? 'Syarat_Bansos.pdf',
          fields: [
            AdminFormField(
              label: 'Nama Program Layanan Sosial',
              controller: titleController,
              hint: 'Contoh: Program Bantuan Sosial PKH Daerah',
            ),
            AdminFormField(
              label: 'Kategori Layanan',
              controller: categoryController,
              options: const ['Bansos', 'Rumah Singgah', 'Disabilitas', 'Lansia', 'Rehabilitasi'],
            ),
            AdminFormField(
              label: 'Deskripsi Program',
              controller: descController,
              hint: 'Tuliskan ruang lingkup program...',
              isMultiLine: true,
            ),
            AdminFormField(
              label: 'Persyaratan Penerima',
              controller: reqController,
              hint: 'Kriteria penerima manfaat...',
              isMultiLine: true,
            ),
            AdminFormField(
              label: 'Mekanisme & Alur',
              controller: mechController,
              hint: 'Mekanisme pengajuan / penyaluran...',
              isMultiLine: true,
            ),
            AdminFormField(
              label: 'File Dokumen Persyaratan (PDF)',
              controller: pdfController,
              hint: 'Berkas_Syarat_Sosial.pdf',
            ),
          ],
          onSave: () {
            final service = AdminDataService();
            if (existing != null) {
              existing.title = titleController.text.trim();
              existing.category = categoryController.text.trim();
              existing.description = descController.text.trim();
              existing.requirement = reqController.text.trim();
              existing.mechanism = mechController.text.trim();
              existing.pdfFileName = pdfController.text.trim();
              service.updateLayananSosial(existing);
            } else {
              service.addLayananSosial(
                ItemLayananSosial(
                  id: 'SOS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  title: titleController.text.trim(),
                  category: categoryController.text.trim(),
                  description: descController.text.trim(),
                  requirement: reqController.text.trim(),
                  mechanism: mechController.text.trim(),
                  pdfFileName: pdfController.text.trim(),
                ),
              );
            }
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ItemLayananSosial item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Hapus Layanan Sosial'),
          content: Text('Apakah Anda yakin ingin menghapus "${item.title}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                AdminDataService().deleteLayananSosial(item.id);
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
        final items = adminService.layananSosialList;

        return AdminTableView<ItemLayananSosial>(
          title: 'Manajemen Layanan Sosial & Bansos',
          subtitle: 'Kelola program bantuan sosial, persyaratan penerima manfaat, dan dokumen pendukung.',
          addNewLabel: 'Tambah Layanan Sosial',
          items: items,
          searchFilter: (item, query) =>
              item.title.toLowerCase().contains(query) ||
              item.category.toLowerCase().contains(query),
          onAddNew: () => _showAddEditDialog(context),
          columns: const [
            AdminTableColumn(title: 'ID', width: 90),
            AdminTableColumn(title: 'Nama Program Layanan', width: 220),
            AdminTableColumn(title: 'Kategori', width: 140),
            AdminTableColumn(title: 'Persyaratan & Mekanisme', width: 260),
            AdminTableColumn(title: 'Dokumen PDF', width: 180),
            AdminTableColumn(title: 'Aksi', width: 120, alignment: Alignment.center),
          ],
          rowBuilder: (item, index) {
            return [
              Text(item.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(20)),
                child: Text(item.category, style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 11.5)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Syarat: ${item.requirement}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
                  Text('Alur: ${item.mechanism}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
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
                    tooltip: 'Edit Layanan',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 18),
                    onPressed: () => _confirmDelete(context, item),
                    tooltip: 'Hapus Layanan',
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
