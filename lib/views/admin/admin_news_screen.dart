import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/superapp_header.dart';
import '../../widgets/admin/admin_form_dialog.dart';

class AdminNewsScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminNewsScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  State<AdminNewsScreen> createState() => _AdminNewsScreenState();
}

class _AdminNewsScreenState extends State<AdminNewsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditDialog([ItemBeritaAdmin? existing]) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final categoryController = TextEditingController(text: existing?.category ?? 'Pemerintahan');
    final dateController = TextEditingController(text: existing?.date ?? '24 Agustus 2026');
    final authorController = TextEditingController(text: existing?.author ?? 'Diskominfo Bojonegoro');
    final contentController = TextEditingController(text: existing?.content ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Berita' : 'Tambah Berita Baru',
          subtitle: 'Kelola artikel publikasi daerah, gambar banner, & status tayang',
          isEditing: existing != null,
          initialImageName: existing?.imageUrl ?? 'Banner_Berita.jpg',
          fields: [
            AdminFormField(
              label: 'Judul Artikel Berita',
              controller: titleController,
              hint: 'Tuliskan judul berita utama...',
            ),
            AdminFormField(
              label: 'Kategori Berita',
              controller: categoryController,
              hint: 'Pilih kategori',
              options: const ['Pemerintahan', 'Budaya & Tradisi', 'Pariwisata', 'Pertanian', 'Pendidikan', 'Kesehatan'],
            ),
            AdminFormField(
              label: 'Tanggal Publikasi',
              controller: dateController,
              hint: '24 Agustus 2026',
            ),
            AdminFormField(
              label: 'Penulis / Instansi',
              controller: authorController,
              hint: 'Diskominfo Bojonegoro',
            ),
            AdminFormField(
              label: 'Isi Lengkap Berita',
              controller: contentController,
              hint: 'Tuliskan alur cerita dan isi berita lengkap...',
              isMultiLine: true,
            ),
          ],
          onSave: () {
            final service = AdminDataService();

            if (existing != null) {
              existing.title = titleController.text.trim();
              existing.category = categoryController.text.trim();
              existing.date = dateController.text.trim();
              existing.author = authorController.text.trim();
              existing.content = contentController.text.trim();
              service.updateBerita(existing);
            } else {
              service.addBerita(
                ItemBeritaAdmin(
                  id: 'NWS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  title: titleController.text.trim(),
                  category: categoryController.text.trim(),
                  date: dateController.text.trim(),
                  author: authorController.text.trim(),
                  content: contentController.text.trim(),
                  imageUrl: 'assets/images/super image.png',
                  status: 'Published',
                ),
              );
            }
          },
        );
      },
    );
  }

  void _confirmDelete(ItemBeritaAdmin item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Hapus Artikel Berita'),
          content: Text('Apakah Anda yakin ingin menghapus artikel "${item.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                AdminDataService().deleteBerita(item.id);
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
          'Tambah Berita',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Kelola Berita',
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
                  hintText: 'Cari judul berita atau artikel...',
                  hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 13.5),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D62F1), size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // News Cards List (User Style Parity)
          Expanded(
            child: ListenableBuilder(
              listenable: adminService,
              builder: (context, child) {
                final list = adminService.beritaList.where((b) {
                  if (_searchQuery.trim().isEmpty) return true;
                  final q = _searchQuery.toLowerCase();
                  return b.title.toLowerCase().contains(q) ||
                      b.category.toLowerCase().contains(q) ||
                      b.content.toLowerCase().contains(q);
                }).toList();

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.newspaper_outlined, size: 54, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada artikel berita',
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
                    final isPublished = item.status == 'Published';

                    return Container(
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
                          // 16:9 Image Thumbnail with Category & Status Badges
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: item.imageUrl.startsWith('assets/')
                                      ? Image.asset(item.imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey.shade300))
                                      : Image.network(item.imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey.shade300)),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D62F1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.5),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: InkWell(
                                  onTap: () => adminService.toggleBeritaStatus(item.id),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isPublished ? const Color(0xFF10B981) : Colors.amber.shade700,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(isPublished ? Icons.check_circle_rounded : Icons.edit_note_rounded, color: Colors.white, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          isPublished ? 'Published' : 'Draft',
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Card Body Text & Actions
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                Text(
                                  '${item.date} • ${item.author}',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                Text(
                                  item.content,
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

                                // Admin Action Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => adminService.toggleBeritaStatus(item.id),
                                      icon: Icon(
                                        isPublished ? Icons.visibility_off_rounded : Icons.publish_rounded,
                                        size: 16,
                                        color: isPublished ? Colors.orange : const Color(0xFF10B981),
                                      ),
                                      label: Text(
                                        isPublished ? 'Ubah ke Draft' : 'Publikasikan',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                          color: isPublished ? Colors.orange : const Color(0xFF10B981),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: () => _showAddEditDialog(item),
                                          icon: const Icon(Icons.edit_rounded, size: 16, color: Color(0xFF0D62F1)),
                                          label: const Text('Edit', style: TextStyle(fontSize: 12.5, color: Color(0xFF0D62F1), fontWeight: FontWeight.bold)),
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
                              ],
                            ),
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
