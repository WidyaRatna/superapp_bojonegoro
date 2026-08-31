import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/admin_data_service.dart';
import '../pariwisata_screen.dart';

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

class _AdminPariwisataScreenState extends State<AdminPariwisataScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  TourismSpot _itemToSpot(ItemPariwisata item) {
    IconData icon = Icons.attractions_rounded;
    Color themeColor = const Color(0xFF06B6D4);

    if (item.category == 'religi') {
      icon = Icons.mosque_rounded;
      themeColor = const Color(0xFF059669);
    } else if (item.category == 'sejarah_budaya') {
      icon = Icons.account_balance_rounded;
      themeColor = const Color(0xFFD97706);
    } else {
      icon = Icons.attractions_rounded;
      themeColor = const Color(0xFF06B6D4);
    }

    return TourismSpot(
      id: item.id,
      title: item.name,
      category: item.category,
      categoryLabel: item.categoryLabel,
      description: item.description,
      address: item.address,
      openHours: item.openHours,
      ticketPrice: item.price,
      facilities: item.facilities,
      icon: icon,
      themeColor: themeColor,
      mapQuery: item.mapQuery,
      imagePath: item.imagePath,
      imageUrl: item.imageUrl,
      transportInfo: item.transportInfo,
      tips: item.tips,
    );
  }

  void _showAddEditDialog([ItemPariwisata? existing]) {
    String category = existing?.category ?? 'rekreasi';
    final nameController = TextEditingController(text: existing?.name ?? '');
    final categoryLabelController = TextEditingController(
      text: existing?.categoryLabel ?? (category == 'religi' ? 'Wisata Religi & Sejarah' : category == 'sejarah_budaya' ? 'Sejarah & Budaya' : 'Rekreasi Alam & Geowisata'),
    );
    final addressController = TextEditingController(text: existing?.address ?? '');
    final openHoursController = TextEditingController(text: existing?.openHours ?? '24 Jam (Setiap Hari)');
    final priceController = TextEditingController(text: existing?.price ?? 'Rp 10.000');
    final ratingController = TextEditingController(text: existing?.rating ?? '4.7');
    final descController = TextEditingController(text: existing?.description ?? '');
    final facilitiesController = TextEditingController(
      text: existing?.facilities.join(', ') ?? 'Area Parkir, Gazebo, Toilet, Warung',
    );
    final mapQueryController = TextEditingController(text: existing?.mapQuery ?? 'Bojonegoro');
    final imagePathController = TextEditingController(text: existing?.imagePath ?? existing?.imageUrl ?? 'assets/images/Khayangan_Api.jpg');
    final transportController = TextEditingController(text: existing?.transportInfo ?? '');
    final tipsController = TextEditingController(text: existing?.tips?.join(', ') ?? '');
    bool isPublished = existing?.isPublished ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4).withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add_location_alt_rounded, color: Color(0xFF06B6D4)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          existing != null ? 'Edit Wisata' : 'Tambah Destinasi Wisata',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Kelola 3 Kategori Pariwisata Bojonegoro',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kategori Picker
                      const Text(
                        'Kategori Pariwisata',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF06B6D4)),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: category,
                        dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        style: TextStyle(fontSize: 13.5, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'rekreasi', child: Text('🎡 Tempat Rekreasi')),
                          DropdownMenuItem(value: 'sejarah_budaya', child: Text('🏛️ Sejarah & Budaya')),
                          DropdownMenuItem(value: 'religi', child: Text('🕌 Wisata Religi')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              category = val;
                              if (categoryLabelController.text.isEmpty ||
                                  categoryLabelController.text.contains('Rekreasi') ||
                                  categoryLabelController.text.contains('Sejarah') ||
                                  categoryLabelController.text.contains('Religi')) {
                                categoryLabelController.text = val == 'religi'
                                    ? 'Wisata Religi & Sejarah'
                                    : val == 'sejarah_budaya'
                                        ? 'Sejarah & Budaya'
                                        : 'Rekreasi Alam & Geowisata';
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 14),

                      // Nama Wisata
                      _buildFormLabel('Nama Tempat Wisata *'),
                      _buildTextField(nameController, 'Contoh: Khayangan Api', isDark),
                      const SizedBox(height: 12),

                      // Label Sub-Kategori
                      _buildFormLabel('Label Sub-Kategori'),
                      _buildTextField(categoryLabelController, 'Contoh: Rekreasi Alam & Geowisata', isDark),
                      const SizedBox(height: 12),

                      // Alamat / Lokasi
                      _buildFormLabel('Alamat / Lokasi *'),
                      _buildTextField(addressController, 'Jl. Khayangan Api, Ngasem, Bojonegoro', isDark),
                      const SizedBox(height: 12),

                      // Row: Jam Operasional & Harga Tiket
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFormLabel('Jam Operasional'),
                                _buildTextField(openHoursController, '24 Jam (Setiap Hari)', isDark),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFormLabel('Harga Tiket'),
                                _buildTextField(priceController, 'Rp 8.500 / orang', isDark),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rating & Map Query
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFormLabel('Rating'),
                                _buildTextField(ratingController, '4.7', isDark),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFormLabel('Google Maps Query/Link'),
                                _buildTextField(mapQueryController, 'Khayangan Api Bojonegoro', isDark),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Path Asset / Image URL
                      _buildFormLabel('Asset Gambar / URL Banner'),
                      _buildTextField(imagePathController, 'assets/images/Khayangan_Api.jpg', isDark),
                      const SizedBox(height: 12),

                      // Deskripsi
                      _buildFormLabel('Deskripsi Wisata *'),
                      _buildTextField(descController, 'Tuliskan daya tarik utama wisata...', isDark, maxLines: 3),
                      const SizedBox(height: 12),

                      // Fasilitas
                      _buildFormLabel('Fasilitas (Dipisah Koma)'),
                      _buildTextField(facilitiesController, 'Area Parkir, Gazebo, Toilet, Warung', isDark),
                      const SizedBox(height: 12),

                      // Transportasi & Tips
                      _buildFormLabel('Informasi Transportasi (Opsional)'),
                      _buildTextField(transportController, 'Berjarak ±20 km dari kota Bojonegoro...', isDark),
                      const SizedBox(height: 12),

                      _buildFormLabel('Tips Pengunjung (Dipisah Koma)'),
                      _buildTextField(tipsController, 'Gunakan pakaian nyaman, Bawa air minum', isDark),
                      const SizedBox(height: 14),

                      // Switch Published Status
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Status Publikasi (Tampil ke User)',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Switch(
                              value: isPublished,
                              activeTrackColor: const Color(0xFF10B981),
                              onChanged: (val) => setDialogState(() => isPublished = val),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nama tempat wisata tidak boleh kosong!'),
                          backgroundColor: Color(0xFFEF4444),
                        ),
                      );
                      return;
                    }

                    final service = AdminDataService();
                    final facList = facilitiesController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

                    final tipsList = tipsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

                    final newItem = ItemPariwisata(
                      id: existing?.id ?? 'WIS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      name: name,
                      category: category,
                      categoryLabel: categoryLabelController.text.trim().isEmpty ? 'Pariwisata Bojonegoro' : categoryLabelController.text.trim(),
                      description: descController.text.trim().isEmpty ? 'Destinasi pariwisata unggulan Kabupaten Bojonegoro.' : descController.text.trim(),
                      address: addressController.text.trim().isEmpty ? 'Kabupaten Bojonegoro' : addressController.text.trim(),
                      openHours: openHoursController.text.trim().isEmpty ? '24 Jam' : openHoursController.text.trim(),
                      price: priceController.text.trim().isEmpty ? 'Gratis' : priceController.text.trim(),
                      rating: ratingController.text.trim().isEmpty ? '4.7' : ratingController.text.trim(),
                      facilities: facList.isEmpty ? ['Parkir', 'Toilet', 'Warung'] : facList,
                      imageUrl: imagePathController.text.trim().isEmpty ? 'assets/images/Khayangan_Api.jpg' : imagePathController.text.trim(),
                      imagePath: imagePathController.text.trim().isEmpty ? 'assets/images/Khayangan_Api.jpg' : imagePathController.text.trim(),
                      mapQuery: mapQueryController.text.trim().isEmpty ? name : mapQueryController.text.trim(),
                      transportInfo: transportController.text.trim().isEmpty ? null : transportController.text.trim(),
                      tips: tipsList.isEmpty ? null : tipsList,
                      isPublished: isPublished,
                    );

                    if (existing != null) {
                      service.updatePariwisata(newItem);
                    } else {
                      service.addPariwisata(newItem);
                    }

                    Navigator.pop(context);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(existing != null ? 'Data wisata "${newItem.name}" berhasil diperbarui!' : 'Destinasi wisata "${newItem.name}" berhasil ditambahkan!'),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF06B6D4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.save_rounded, color: Colors.white, size: 18),
                  label: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool isDark, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
        filled: true,
        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
        ),
      ),
    );
  }

  void _confirmDelete(ItemPariwisata item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Destinasi Wisata'),
        content: Text('Apakah Anda yakin ingin menghapus "${item.name}" dari daftar pariwisata Bojonegoro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AdminDataService().deletePariwisata(item.id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${item.name}" telah dihapus.'),
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

  void _previewDetail(ItemPariwisata item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TourismDetailScreen(
          spot: _itemToSpot(item),
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
  }

  List<ItemPariwisata> _getFilteredItems(String categoryTag) {
    final all = AdminDataService().pariwisataList;
    return all.where((spot) {
      final matchesCategory = spot.category == categoryTag;
      final q = _searchQuery.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          spot.name.toLowerCase().contains(q) ||
          spot.address.toLowerCase().contains(q) ||
          spot.description.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return ListenableBuilder(
      listenable: AdminDataService(),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: isDark
                      ? const [
                          Color(0xFF0B2545), 
                          Color(0xFF0A5560), 
                        ]
                      : const [
                          Color(0xFF0D62F1),
                          Color(0xFF06B6D4), 
                        ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Pariwisata Bojonegoro',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              if (widget.onToggleDarkMode != null)
                IconButton(
                  icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: Colors.white),
                  onPressed: widget.onToggleDarkMode,
                ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kTextTabBarHeight + 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: isDark
                        ? const [
                            Color(0xFF0B2545), 
                            Color(0xFF0A5560), 
                          ]
                        : const [
                            Color(0xFF0D62F1), 
                            Color(0xFF06B6D4),
                          ],
                  ),
                ),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.stylus,
                    },
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    tabAlignment: TabAlignment.start,
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFFCFFAFE),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.attractions_rounded, size: 20),
                        text: 'Tempat Rekreasi',
                      ),
                      Tab(
                        icon: Icon(Icons.account_balance_rounded, size: 20),
                        text: 'Sejarah & Budaya',
                      ),
                      Tab(
                        icon: Icon(Icons.mosque_rounded, size: 20),
                        text: 'Wisata Religi',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddEditDialog(),
            backgroundColor: const Color(0xFF06B6D4),
            icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
            label: const Text(
              'Tambah Wisata Baru',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [

              // Search Bar Input
              Container(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(fontSize: 13.5, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    hintText: 'Cari destinasi wisata yang dikelola admin...',
                    hintStyle: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF06B6D4)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // TabBarView Content for Admin
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAdminTabContent(_getFilteredItems('rekreasi'), isDark),
                    _buildAdminTabContent(_getFilteredItems('sejarah_budaya'), isDark),
                    _buildAdminTabContent(_getFilteredItems('religi'), isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdminTabContent(List<ItemPariwisata> items, bool isDark) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 64, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
              const SizedBox(height: 12),
              Text(
                'Tidak ada destinasi wisata yang ditemukan',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 4),
              Text(
                'Gunakan tombol "Tambah Wisata Baru" di bawah untuk menambah lokasi wisata.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = items[index];
        final spot = _itemToSpot(item);

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 30 : 10),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Thumbnail Image with Status & Rating Badges
              Stack(
                children: [
                  buildSpotImageWidget(spot, height: 170, borderRadius: const BorderRadius.vertical(top: Radius.circular(18))),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.isPublished ? const Color(0xFF10B981) : const Color(0xFF64748B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(item.isPublished ? Icons.check_circle_rounded : Icons.visibility_off_rounded, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            item.isPublished ? 'Terbit (Aktif)' : 'Draft (Non-Aktif)',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            item.rating,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Content Body (Matching User PariwisataScreen Layout)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Icon Container + Title & Sub-category
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: spot.themeColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(spot.icon, color: spot.themeColor, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                spot.title,
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                spot.categoryLabel,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: spot.themeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Description text
                    Text(
                      spot.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Address Row
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 14, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            spot.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Ticket Price Row Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.confirmation_number_rounded, size: 14, color: Color(0xFF06B6D4)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              spot.ticketPrice,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF334155),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Admin Actions Control Buttons Bar
                    const Divider(height: 1),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        // Status Toggle Pill Button (Terbit / Draft)
                        InkWell(
                          onTap: () {
                            AdminDataService().togglePublishPariwisata(item.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(item.isPublished ? 'Status "${item.name}" dinonaktifkan (Draft).' : 'Status "${item.name}" berhasil diterbitkan!'),
                                backgroundColor: item.isPublished ? const Color(0xFF64748B) : const Color(0xFF10B981),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: item.isPublished ? const Color(0xFF10B981).withAlpha(20) : const Color(0xFF64748B).withAlpha(20),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: item.isPublished ? const Color(0xFF10B981) : const Color(0xFF64748B),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  item.isPublished ? Icons.check_circle_rounded : Icons.visibility_off_rounded,
                                  size: 13,
                                  color: item.isPublished ? const Color(0xFF10B981) : const Color(0xFF64748B),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.isPublished ? 'Terbit' : 'Draft',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: item.isPublished ? const Color(0xFF10B981) : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),

                        // Actions: Preview Detail, Edit, Delete
                        OutlinedButton.icon(
                          onPressed: () => _previewDetail(item),
                          icon: const Icon(Icons.visibility_rounded, size: 14, color: Color(0xFF06B6D4)),
                          label: const Text('Detail', style: TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold, fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF06B6D4)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: () => _showAddEditDialog(item),
                          tooltip: 'Edit Destinasi',
                          icon: const Icon(Icons.edit_rounded, size: 18, color: Color(0xFF0D62F1)),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF0D62F1).withAlpha(15),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () => _confirmDelete(item),
                          tooltip: 'Hapus Destinasi',
                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF4444)),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444).withAlpha(15),
                            padding: const EdgeInsets.all(8),
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
  }
}
