import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/admin_data_service.dart';
import '../../models/news_model.dart';
import '../../widgets/superapp_header.dart';
import '../../widgets/admin/admin_form_dialog.dart';
import '../../widgets/news_detail_sheet.dart';

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
  final String _officialNewsWebUrl = 'https://bojonegorokab.go.id/berita';

  Future<void> _openOfficialWeb([String? url]) async {
    final targetUrl = Uri.parse(url ?? _officialNewsWebUrl);
    if (await canLaunchUrl(targetUrl)) {
      await launchUrl(targetUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka $targetUrl')),
        );
      }
    }
  }

  void _openNewsDetail(NewsItem news) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewsDetailSheet(news: news),
    );
  }

  void _shareArticle(NewsItem news) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tautan berita disalin: ${news.webUrl}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddEditDialog([ItemBeritaAdmin? existing]) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final categoryController = TextEditingController(text: existing?.category ?? 'Pemerintahan');
    final contentController = TextEditingController(text: existing?.content ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Berita' : 'Publikasi Berita Baru',
          subtitle: 'Kelola artikel warta & pengumuman Pemkab Bojonegoro',
          isEditing: existing != null,
          initialImageName: existing?.imageUrl ?? 'bojonegoro_gate.jpg',
          fields: [
            AdminFormField(
              label: 'Judul Berita',
              controller: titleController,
              hint: 'Tuliskan judul berita utama...',
            ),
            AdminFormField(
              label: 'Kategori Berita',
              controller: categoryController,
              hint: 'Pemerintahan / Ekonomi / Kebudayaan / Infrastruktur',
            ),
            AdminFormField(
              label: 'Isi Lengkap Berita',
              controller: contentController,
              hint: 'Tulis naskah lengkap berita...',
              isMultiLine: true,
            ),
          ],
          onSave: () {
            final service = AdminDataService();
            if (existing != null) {
              existing.title = titleController.text.trim();
              existing.category = categoryController.text.trim();
              existing.content = contentController.text.trim();
              service.updateBerita(existing);
            } else {
              service.addBerita(
                ItemBeritaAdmin(
                  id: 'NEWS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  title: titleController.text.trim().isEmpty ? 'Warta Bojonegoro Terbaru' : titleController.text.trim(),
                  category: categoryController.text.trim().isEmpty ? 'Pemerintahan' : categoryController.text.trim(),
                  content: contentController.text.trim().isEmpty ? 'Artikel lengkap warta Bojonegoro.' : contentController.text.trim(),
                  date: 'Hari Ini',
                  author: 'Humas Bojonegoro',
                  imageUrl: 'assets/images/bojonegoro_gate.jpg',
                  status: 'Published',
                ),
              );
            }
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(existing != null ? 'Berita berhasil diperbarui!' : 'Berita baru berhasil dipublikasikan!'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(ItemBeritaAdmin item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 24),
            SizedBox(width: 8),
            Text('Hapus Berita'),
          ],
        ),
        content: Text('Apakah Anda yakin ingin menghapus berita "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              AdminDataService().deleteBerita(item.id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Berita "${item.title}" telah dihapus.'),
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
    final backgroundColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: const Color(0xFF0D62F1),
        elevation: 4,
        icon: const Icon(Icons.post_add_rounded, color: Colors.white, size: 20),
        label: const Text(
          'Tambah Berita',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5),
        ),
      ),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Berita Terkini',
            subtitle: 'Pemerintah Kabupaten Bojonegoro',
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
            actions: [
              IconButton(
                tooltip: 'Buka Web Resmi Pemkab Bojonegoro',
                icon: const Icon(Icons.language_rounded, color: Colors.white),
                onPressed: () => _openOfficialWeb(),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Banner Button directing to official news site (100% Identical to User UI)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withAlpha(64),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.public_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Portal Berita Resmi Pemkab',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'bojonegorokab.go.id/berita',
                                style: TextStyle(
                                  color: Color(0xFFE0F2FE),
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _openOfficialWeb(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0369A1),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Buka Web',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.open_in_new_rounded, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // News Feed List with exact 100% User Layout + Admin CRUD buttons below
                  AnimatedBuilder(
                    animation: AdminDataService(),
                    builder: (context, _) {
                      final adminService = AdminDataService();
                      final allItems = adminService.beritaList;

                      // Fallback to sampleNews if admin list is empty
                      final newsList = allItems.isNotEmpty
                          ? allItems
                          : sampleNews.map((sn) => ItemBeritaAdmin(
                                id: sn.id,
                                title: sn.title,
                                category: sn.category,
                                date: sn.date,
                                author: 'Humas Bojonegoro',
                                content: sn.content,
                                imageUrl: sn.imageUrl,
                                status: 'Published',
                              )).toList();

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: newsList.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 24),
                        itemBuilder: (context, index) {
                          final item = newsList[index];
                          final news = NewsItem(
                            id: item.id,
                            title: item.title,
                            category: item.category,
                            snippet: item.content,
                            content: item.content,
                            imageUrl: item.imageUrl,
                            date: item.date,
                            readTime: '3 mnt baca',
                            likes: 120,
                            views: 950,
                            webUrl: 'https://bojonegorokab.go.id/berita',
                          );

                          return Container(
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(isDark ? 40 : 10),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. User Exact News Card Body
                                InkWell(
                                  onTap: () => _openNewsDetail(news),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Full-width Hero Image matching User UI 100%
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(14),
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: news.imageUrl.startsWith('assets/')
                                                ? Image.asset(
                                                    news.imageUrl,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) => Container(
                                                      color: const Color(0xFFE2E8F0),
                                                      child: const Center(
                                                        child: Icon(Icons.image_not_supported_rounded, color: Color(0xFF94A3B8), size: 40),
                                                      ),
                                                    ),
                                                  )
                                                : Image.network(
                                                    news.imageUrl,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) => Container(
                                                      color: const Color(0xFFE2E8F0),
                                                      child: const Center(
                                                        child: Icon(Icons.image_not_supported_rounded, color: Color(0xFF94A3B8), size: 40),
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Bold Title Text below image
                                        Text(
                                          news.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                            height: 1.3,
                                          ),
                                        ),
                                        const SizedBox(height: 6),

                                        // Date & Share Row
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${news.date} • ${news.category}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: subtitleColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.open_in_new_rounded,
                                                    size: 20,
                                                    color: subtitleColor,
                                                  ),
                                                  tooltip: 'Buka di bojonegorokab.go.id',
                                                  onPressed: () => _openOfficialWeb(news.webUrl),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.share_outlined,
                                                    size: 20,
                                                    color: subtitleColor,
                                                  ),
                                                  tooltip: 'Bagikan Berita',
                                                  onPressed: () => _shareArticle(news),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                 // 2. High-Contrast Admin CRUD Bar Attached Directly Underneath (2-Row Responsive Layout)
                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                   child: Container(
                                     width: double.infinity,
                                     padding: const EdgeInsets.all(10),
                                     decoration: BoxDecoration(
                                       color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE0F2FE),
                                       borderRadius: BorderRadius.circular(12),
                                       border: Border.all(
                                         color: isDark ? const Color(0xFF0D62F1).withAlpha(80) : const Color(0xFFBAE6FD),
                                         width: 1,
                                       ),
                                     ),
                                     child: Column(
                                       children: [
                                         // Row 1: Label & Status Rilis Badge
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Row(
                                               children: [
                                                 Container(
                                                   padding: const EdgeInsets.all(4),
                                                   decoration: BoxDecoration(
                                                     color: const Color(0xFF0D62F1).withAlpha(30),
                                                     shape: BoxShape.circle,
                                                   ),
                                                   child: const Icon(
                                                     Icons.admin_panel_settings_rounded,
                                                     size: 15,
                                                     color: Color(0xFF0D62F1),
                                                   ),
                                                 ),
                                                 const SizedBox(width: 6),
                                                 Text(
                                                   'Kelola Berita',
                                                   style: TextStyle(
                                                     fontSize: 12,
                                                     fontWeight: FontWeight.bold,
                                                     color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E40AF),
                                                   ),
                                                 ),
                                               ],
                                             ),
                                             // Toggle Publish / Draft
                                             InkWell(
                                               onTap: () {
                                                 adminService.toggleBeritaStatus(item.id);
                                               },
                                               borderRadius: BorderRadius.circular(8),
                                               child: Container(
                                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                 decoration: BoxDecoration(
                                                   color: item.status == 'Published'
                                                       ? const Color(0xFF10B981).withAlpha(25)
                                                       : const Color(0xFFF59E0B).withAlpha(25),
                                                   borderRadius: BorderRadius.circular(6),
                                                   border: Border.all(
                                                     color: item.status == 'Published'
                                                         ? const Color(0xFF10B981)
                                                         : const Color(0xFFF59E0B),
                                                   ),
                                                 ),
                                                 child: Text(
                                                   item.status,
                                                   style: TextStyle(
                                                     fontSize: 11,
                                                     fontWeight: FontWeight.bold,
                                                     color: item.status == 'Published'
                                                         ? const Color(0xFF10B981)
                                                         : const Color(0xFFD97706),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ],
                                         ),
                                         const SizedBox(height: 8),
                                         Divider(height: 1, thickness: 0.8, color: isDark ? const Color(0xFF334155) : const Color(0xFFBAE6FD)),
                                         const SizedBox(height: 8),
                                         // Row 2: Equal Width Action Buttons (Edit & Hapus)
                                         Row(
                                           children: [
                                             Expanded(
                                               child: ElevatedButton.icon(
                                                 onPressed: () => _showAddEditDialog(item),
                                                 icon: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                                                 label: const Text(
                                                   'Edit Berita',
                                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                                 ),
                                                 style: ElevatedButton.styleFrom(
                                                   backgroundColor: const Color(0xFF0D62F1),
                                                   elevation: 0,
                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                   padding: const EdgeInsets.symmetric(vertical: 8),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 8),
                                             Expanded(
                                               child: ElevatedButton.icon(
                                                 onPressed: () => _confirmDelete(item),
                                                 icon: const Icon(Icons.delete_outline_rounded, size: 14, color: Colors.white),
                                                 label: const Text(
                                                   'Hapus Berita',
                                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                                 ),
                                                 style: ElevatedButton.styleFrom(
                                                   backgroundColor: const Color(0xFFEF4444),
                                                   elevation: 0,
                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                   padding: const EdgeInsets.symmetric(vertical: 8),
                                                 ),
                                               ),
                                             ),
                                           ],
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                              ],
                            ),
                          );
                        },
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
