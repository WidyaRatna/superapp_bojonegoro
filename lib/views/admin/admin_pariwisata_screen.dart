import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';
import '../../widgets/superapp_header.dart';
import '../../widgets/admin/admin_form_dialog.dart';

class AdminPariwisataScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AdminPariwisataScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleDarkMode,
  });

  @override
  State<AdminPariwisataScreen> createState() => _AdminPariwisataScreenState();
}

class _AdminPariwisataScreenState extends State<AdminPariwisataScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditDialog([ItemPariwisata? existing]) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final locationController = TextEditingController(text: existing?.location ?? 'Bojonegoro');
    final ratingController = TextEditingController(text: existing?.rating ?? '4.7');
    final priceController = TextEditingController(text: existing?.price ?? 'Rp 10.000');
    final descController = TextEditingController(text: existing?.description ?? '');
    final facilitiesController = TextEditingController(
      text: existing?.facilities.join(', ') ?? 'Parkir, Gazebo, Toilet, Warung',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Tempat Wisata' : 'Tambah Destinasi Wisata Baru',
          subtitle: 'Kelola informasi pariwisata daerah, fasilitas, tiket, & gambar banner',
          isEditing: existing != null,
          initialImageName: existing?.imageUrl ?? 'Foto_Wisata.jpg',
          fields: [
            AdminFormField(
              label: 'Nama Tempat Wisata',
              controller: nameController,
              hint: 'Contoh: Khayangan Api',
            ),
            AdminFormField(
              label: 'Lokasi / Kecamatan',
              controller: locationController,
              hint: 'Ngasem, Dander, Bojonegoro',
            ),
            AdminFormField(
              label: 'Rating Pengunjung',
              controller: ratingController,
              hint: '4.7',
            ),
            AdminFormField(
              label: 'Harga Tiket Masuk',
              controller: priceController,
              hint: 'Rp 10.000',
            ),
            AdminFormField(
              label: 'Deskripsi Singkat',
              controller: descController,
              hint: 'Tuliskan daya tarik utama wisata...',
              isMultiLine: true,
            ),
            AdminFormField(
              label: 'Fasilitas (Dipisah Koma)',
              controller: facilitiesController,
              hint: 'Area Parkir, Musholla, Toilet, Warung',
            ),
          ],
          onSave: () {
            final service = AdminDataService();
            final facList = facilitiesController.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();

            if (existing != null) {
              existing.name = nameController.text.trim();
              existing.location = locationController.text.trim();
              existing.rating = ratingController.text.trim();
              existing.price = priceController.text.trim();
              existing.description = descController.text.trim();
              existing.facilities = facList;
              service.updatePariwisata(existing);
            } else {
              service.addPariwisata(
                ItemPariwisata(
                  id: 'WIS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  name: nameController.text.trim(),
                  location: locationController.text.trim(),
                  rating: ratingController.text.trim(),
                  price: priceController.text.trim(),
                  description: descController.text.trim(),
                  facilities: facList,
                  imageUrl: 'assets/images/Khayangan_Api.jpg',
                ),
              );
            }
          },
        );
      },
    );
  }

  void _confirmDelete(ItemPariwisata item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Hapus Destinasi Wisata'),
          content: Text('Apakah Anda yakin ingin menghapus "${item.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                AdminDataService().deletePariwisata(item.id);
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
          'Tambah Wisata',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Kelola Pariwisata',
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
                  hintText: 'Cari destinasi wisata...',
                  hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 13.5),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D62F1), size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // List of Tourism Cards (Identical User Card Styling + Admin Controls)
          Expanded(
            child: ListenableBuilder(
              listenable: adminService,
              builder: (context, child) {
                final list = adminService.pariwisataList.where((spot) {
                  if (_searchQuery.trim().isEmpty) return true;
                  final q = _searchQuery.toLowerCase();
                  return spot.name.toLowerCase().contains(q) ||
                      spot.location.toLowerCase().contains(q) ||
                      spot.description.toLowerCase().contains(q);
                }).toList();

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.landscape_outlined, size: 54, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada data tempat wisata',
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
                          // Header Image / Banner with Rating Badge
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
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(160),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        item.rating,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Card Body Details
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0D62F1).withAlpha(15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item.price,
                                        style: const TextStyle(
                                          color: Color(0xFF0D62F1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, color: Color(0xFF64748B), size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.location,
                                      style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                Text(
                                  item.description,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 14),

                                // Facilities Tags
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: item.facilities.map((fac) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        fac,
                                        style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 16),
                                const Divider(height: 1),
                                const SizedBox(height: 12),

                                // Admin Action Buttons Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () => _showAddEditDialog(item),
                                      icon: const Icon(Icons.edit_rounded, size: 16, color: Color(0xFF0D62F1)),
                                      label: const Text('Edit Wisata', style: TextStyle(fontSize: 12.5, color: Color(0xFF0D62F1), fontWeight: FontWeight.bold)),
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
