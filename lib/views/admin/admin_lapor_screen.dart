import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/admin/admin_form_dialog.dart';
import '../../widgets/admin/admin_table_view.dart';

class AdminLaporScreen extends StatelessWidget {
  const AdminLaporScreen({super.key});

  void _showAddEditDialog(BuildContext context, [ItemSopLapor? existing]) {
    final titleController = TextEditingController(text: existing?.title ?? 'SOP Pelaporan Pengaduan Masyarakat');
    final categoryController = TextEditingController(text: existing?.category ?? 'Pelayanan Publik');
    final sopTextController = TextEditingController(text: existing?.sopText ?? '');
    final pdfController = TextEditingController(text: existing?.pdfFileName ?? 'SOP_Pengaduan_Masyarakat_Bojonegoro.pdf');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit SOP Pelaporan Lapor' : 'Tambah SOP Pelaporan Baru',
          subtitle: 'Kelola SOP, ketentuan laporan, mekanisme pengaduan, & berkas pendukung PDF',
          isEditing: existing != null,
          initialPdfName: existing?.pdfFileName ?? 'SOP_Pengaduan_Masyarakat.pdf',
          fields: [
            AdminFormField(
              label: 'Judul SOP / Ketentuan Lapor',
              controller: titleController,
              hint: 'Contoh: SOP Pelaporan Layanan Publik SIAP LAPOR',
            ),
            AdminFormField(
              label: 'Kategori Pelaporan',
              controller: categoryController,
              options: const ['Pelayanan Publik', 'Infrastruktur', 'Kesehatan', 'Sosial & Bencana', 'Keamanan'],
            ),
            AdminFormField(
              label: 'Teks Alur & Ketentuan SOP',
              controller: sopTextController,
              hint: '1. Pelapor menyampaikan laporan lengkap...\n2. Verifikasi 1x24 jam...',
              isMultiLine: true,
            ),
            AdminFormField(
              label: 'File Dokumen Pendukung (PDF)',
              controller: pdfController,
              hint: 'File_SOP_Lapor.pdf',
            ),
          ],
          onSave: () {
            final service = AdminDataService();
            final item = ItemSopLapor(
              id: existing?.id ?? 'LPR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              title: titleController.text.trim(),
              category: categoryController.text.trim(),
              sopText: sopTextController.text.trim(),
              pdfFileName: pdfController.text.trim(),
            );
            service.updateLaporSop(item);
          },
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
        final items = adminService.laporSopList;

        return AdminTableView<ItemSopLapor>(
          title: 'Manajemen SOP Lapor & Pengaduan',
          subtitle: 'Kelola SOP pelaporan masyarakat, ketentuan laporan, alur penyelesaian, dan dokumen pendukung PDF.',
          addNewLabel: 'Perbarui SOP Lapor',
          items: items,
          searchFilter: (item, query) =>
              item.title.toLowerCase().contains(query) ||
              item.category.toLowerCase().contains(query),
          onAddNew: () => _showAddEditDialog(context),
          columns: const [
            AdminTableColumn(title: 'ID', width: 90),
            AdminTableColumn(title: 'Judul SOP / Ketentuan', width: 260),
            AdminTableColumn(title: 'Kategori', width: 160),
            AdminTableColumn(title: 'Dokumen Pendukung (PDF)', width: 220),
            AdminTableColumn(title: 'Aksi', width: 120, alignment: Alignment.center),
          ],
          rowBuilder: (item, index) {
            return [
              Text(item.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                  Text(item.sopText, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(item.category, style: const TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 11.5)),
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
                    tooltip: 'Edit SOP Lapor',
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
