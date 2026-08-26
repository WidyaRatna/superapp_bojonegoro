import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/loker_model.dart';
import 'loker_detail_screen.dart';

class LokerScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const LokerScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<LokerScreen> createState() => _LokerScreenState();
}

class _LokerScreenState extends State<LokerScreen> with SingleTickerProviderStateMixin {
  bool _localDark = false;
  late TabController _tabController;

  // Master State for Job Listings
  late List<LokerItem> _allLokerList;
  
  // Search & Filter state for Pencari Kerja
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  String _selectedKecamatan = 'Semua Kecamatan';

  // Form State for Input Lowongan (Pemberi Kerja)
  final _formKey = GlobalKey<FormState>();
  String _inputPostedRole = 'Aparat Desa / Pemerintah';
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  String _inputCategory = listKategoriLokerForm.first;
  String _inputType = listTipePekerjaan.first;
  String _inputKecamatan = listKecamatanLokerForm.first;
  final _addressController = TextEditingController(); // Full typed address
  final _salaryController = TextEditingController();
  final _descController = TextEditingController();
  final _reqController = TextEditingController();
  final _phoneController = TextEditingController();
  final _waController = TextEditingController();
  final _contactNameController = TextEditingController(); // Nama Penanggung Jawab
  final _igController = TextEditingController(); // Instagram
  final _emailController = TextEditingController(); // Email
  final _webController = TextEditingController(); // Website
  String _posterImagePath = ''; // Uploaded Poster Image Path

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _localDark = widget.isDarkMode;
    _tabController = TabController(length: 2, vsync: this);
    _allLokerList = List.from(initialLokerItems);
  }

  @override
  void didUpdateWidget(covariant LokerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      setState(() {
        _localDark = widget.isDarkMode;
      });
    }
  }

  void _toggleDarkMode() {
    setState(() {
      _localDark = !_localDark;
    });
    if (widget.onToggleDarkMode != null) {
      widget.onToggleDarkMode!();
    }
  }

  bool _isDarkModeActive(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark || _localDark;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _salaryController.dispose();
    _descController.dispose();
    _reqController.dispose();
    _phoneController.dispose();
    _waController.dispose();
    _contactNameController.dispose();
    _igController.dispose();
    _emailController.dispose();
    _webController.dispose();
    super.dispose();
  }

  List<LokerItem> get _filteredLokerList {
    return _allLokerList.where((item) {
      final matchesQuery = _searchQuery.trim().isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.companyName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.fullAddress.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Semua' || item.category == _selectedCategory;
      final matchesKecamatan = _selectedKecamatan == 'Semua Kecamatan' || item.locationKecamatan == _selectedKecamatan;
      return matchesQuery && matchesCategory && matchesKecamatan;
    }).toList();
  }

  Future<void> _pickPosterImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _posterImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memilih gambar poster.')),
        );
      }
    }
  }

  void _submitNewLoker() {
    if (_formKey.currentState!.validate()) {
      final reqList = _reqController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final now = DateTime.now();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
      final formattedDate = '${now.day} ${months[now.month - 1]} ${now.year}';

      final newLoker = LokerItem(
        id: 'loker_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        companyName: _companyController.text.trim(),
        category: _inputCategory,
        locationKecamatan: _inputKecamatan,
        fullAddress: _addressController.text.trim(),
        salaryRange: _salaryController.text.trim().isEmpty ? 'Nego / UMK' : _salaryController.text.trim(),
        jobType: _inputType,
        description: _descController.text.trim(),
        requirements: reqList.isNotEmpty ? reqList : ['Tidak ada persyaratan khusus'],
        contactName: _contactNameController.text.trim(),
        contactPhone: _phoneController.text.trim(),
        contactWhatsapp: _waController.text.trim(),
        instagram: _igController.text.trim(),
        email: _emailController.text.trim(),
        website: _webController.text.trim(),
        posterImagePath: _posterImagePath,
        postedByRole: _inputPostedRole,
        postedDate: formattedDate,
        isVerified: true,
      );

      setState(() {
        _allLokerList.insert(0, newLoker);
        _searchQuery = '';
        _selectedCategory = 'Semua';
        _selectedKecamatan = 'Semua Kecamatan';
      });

      // Clear Form
      _titleController.clear();
      _companyController.clear();
      _addressController.clear();
      _salaryController.clear();
      _descController.clear();
      _reqController.clear();
      _phoneController.clear();
      _waController.clear();
      _contactNameController.clear();
      _igController.clear();
      _emailController.clear();
      _webController.clear();
      _posterImagePath = '';

      // Show Success Dialog / Banner
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: _isDarkModeActive(context) ? const Color(0xFF1E293B) : Colors.white,
          title: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 28),
              SizedBox(width: 10),
              Text('Lowongan Tersimpan!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: Text(
            'Lowongan pekerjaan telah berhasil divalidasi dan ditayangkan pada daftar Cari Lowongan Bojonegoro.',
            style: TextStyle(color: _isDarkModeActive(context) ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _tabController.animateTo(0); // Switch back to 'Cari Lowongan' tab
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Lihat di Daftar Lowongan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  void _openLokerDetail(LokerItem loker) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LokerDetailScreen(
          loker: loker,
          isDarkMode: _isDarkModeActive(context),
          onToggleDarkMode: _toggleDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDarkModeActive(context);
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Premium Emerald Green Header Bar
          Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16, (topPadding > 0 ? topPadding : 16) + 4, 16, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? const [
                            Color(0xFF064E3B),
                            Color(0xFF047857),
                            Color(0xFF059669),
                          ]
                        : const [
                            Color(0xFF047857),
                            Color(0xFF059669),
                            Color(0xFF10B981),
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF059669).withAlpha(70),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Info Loker Bojonegoro',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                            color: isDark ? Colors.amber : Colors.white,
                            size: 20,
                          ),
                          onPressed: _toggleDarkMode,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Portal Bursa Kerja & Input Lowongan Pekerjaan Kab. Bojonegoro',
                        style: TextStyle(
                          color: Colors.white.withAlpha(220),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Clean Segmented Control inside Green Header
                    Container(
                      height: 40,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF042F2E).withAlpha(180)
                            : const Color(0xFF064E3B).withAlpha(120),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withAlpha(40),
                          width: 1.0,
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: const Color(0xFF047857),
                        unselectedLabelColor: Colors.white,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
                        tabs: const [
                          Tab(
                            height: 34,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_rounded, size: 15),
                                SizedBox(width: 5),
                                Text('Cari Lowongan'),
                              ],
                            ),
                          ),
                          Tab(
                            height: 34,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline_rounded, size: 15),
                                SizedBox(width: 5),
                                Text('Input Lowongan'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -20,
                top: 10,
                child: IgnorePointer(
                  child: Icon(
                    Icons.work_rounded,
                    size: 130,
                    color: Colors.white.withAlpha(15),
                  ),
                ),
              ),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCariLowonganTab(isDark),
                _buildInputLowonganTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tab 1: Cari Lowongan (Flow Pencari Kerja)
  Widget _buildCariLowonganTab(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Search Bar & Location Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Cari pekerjaan (admin, kasir, teknisi...)...',
                        hintStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 12.5),
                        prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF059669)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Kecamatan Location Filter Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, size: 18, color: Color(0xFF059669)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedKecamatan,
                        isExpanded: true,
                        dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        items: listKecamatanLoker.map((kec) {
                          return DropdownMenuItem<String>(
                            value: kec,
                            child: Text(kec, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedKecamatan = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Horizontal Category Choice Chips
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
                PointerDeviceKind.stylus,
              },
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: listKategoriLoker.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: const Color(0xFF059669),
                      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF059669)
                            : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        width: 1.0,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Job Vacancies List
          if (_filteredLokerList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.work_off_rounded, size: 48, color: Colors.grey.withAlpha(150)),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada lowongan pekerjaan',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Coba sesuaikan kata kunci pencarian atau lokasi kecamatan',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredLokerList.length,
                itemBuilder: (context, index) {
                  final item = _filteredLokerList[index];
                  final isAparat = item.postedByRole.contains('Aparat');

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => _openLokerDetail(item),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), width: 1.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(isDark ? 25 : 6),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Poster image if available
                            if (item.posterImagePath.isNotEmpty) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 140,
                                  width: double.infinity,
                                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                  child: Image.file(
                                    File(item.posterImagePath),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            // Role Badge & Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isAparat
                                            ? const Color(0xFF059669).withAlpha(isDark ? 35 : 15)
                                            : const Color(0xFF0284C7).withAlpha(isDark ? 35 : 15),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: isAparat
                                              ? const Color(0xFF059669).withAlpha(30)
                                              : const Color(0xFF0284C7).withAlpha(30),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Text(
                                        item.postedByRole,
                                        style: TextStyle(
                                          color: isAparat ? const Color(0xFF059669) : const Color(0xFF0284C7),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (item.id.startsWith('loker_') && !item.id.startsWith('loker_1') && !item.id.startsWith('loker_2') && !item.id.startsWith('loker_3')) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withAlpha(30),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: const Color(0xFF10B981), width: 0.8),
                                        ),
                                        child: const Text(
                                          'Baru',
                                          style: TextStyle(
                                            color: Color(0xFF10B981),
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  item.postedDate,
                                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Job Title & Company
                            Text(
                              item.title,
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.companyName,
                              style: const TextStyle(
                                color: Color(0xFF059669),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Location, Salary & Job Type Chips
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _buildMiniBadge(Icons.location_on_rounded, item.locationKecamatan, isDark),
                                _buildMiniBadge(Icons.work_outline_rounded, item.jobType, isDark),
                                _buildMiniBadge(Icons.payments_outlined, item.salaryRange, isDark),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Tab 2: Input Lowongan (Flow Pemberi Kerja - Aparat / Masyarakat)
  Widget _buildInputLowonganTab(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Formulir Tambah Lowongan Pekerjaan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF059669),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Lowongan yang Anda kirim akan langsung diverifikasi dan ditayangkan untuk pencari kerja di Kab. Bojonegoro.',
                style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),

              // Role Selection
              _buildFormLabel('Status Pemasang Lowongan', isDark),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _inputPostedRole,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold),
                    items: const [
                      DropdownMenuItem(value: 'Aparat Desa / Pemerintah', child: Text('Aparat Desa / Instansi Pemerintah')),
                      DropdownMenuItem(value: 'Masyarakat / Perusahaan', child: Text('Masyarakat / Perusahaan Swasta')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _inputPostedRole = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Title Input
              _buildFormLabel('Judul Pekerjaan / Posisi *', isDark),
              _buildTextField(
                controller: _titleController,
                hint: 'Misal: Staff Administrasi Desa, Kasir Toko, Operator Pabrik',
                isDark: isDark,
                validator: (val) => val == null || val.trim().isEmpty ? 'Mohon isi judul pekerjaan' : null,
              ),
              const SizedBox(height: 14),

              // Company / Instansi Name
              _buildFormLabel('Nama Perusahaan / Instansi / Usaha *', isDark),
              _buildTextField(
                controller: _companyController,
                hint: 'Misal: Kantor Desa Balenrejo, Toko Sembako Jaya',
                isDark: isDark,
                validator: (val) => val == null || val.trim().isEmpty ? 'Mohon isi nama perusahaan / instansi' : null,
              ),
              const SizedBox(height: 14),

              // Upload Poster / Brosur Image
              _buildFormLabel('Upload Gambar Poster / Brosur Lowongan (Opsional)', isDark),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    if (_posterImagePath.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 160,
                          width: double.infinity,
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          child: Image.file(
                            File(_posterImagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () => _pickPosterImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library_rounded, size: 18),
                            label: const Text('Ganti Gambar'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _posterImagePath = '';
                              });
                            },
                            icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                            label: const Text('Hapus', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ] else ...[
                      const Icon(Icons.add_photo_alternate_rounded, size: 40, color: Color(0xFF059669)),
                      const SizedBox(height: 6),
                      Text(
                        'Pilih gambar poster / brosur dari galeri atau kamera',
                        style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _pickPosterImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library_rounded, size: 16, color: Colors.white),
                            label: const Text('Galeri', style: TextStyle(color: Colors.white, fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF059669),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                            onPressed: () => _pickPosterImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt_rounded, size: 16, color: Color(0xFF059669)),
                            label: const Text('Kamera', style: TextStyle(color: Color(0xFF059669), fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF059669)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Category & Job Type Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormLabel('Kategori *', isDark),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _inputCategory,
                              isExpanded: true,
                              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 12.5),
                              items: listKategoriLokerForm.map((cat) => DropdownMenuItem(value: cat, child: Text(cat, overflow: TextOverflow.ellipsis))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _inputCategory = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormLabel('Tipe Pekerjaan *', isDark),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _inputType,
                              isExpanded: true,
                              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 12.5),
                              items: listTipePekerjaan.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _inputType = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Location Kecamatan
              _buildFormLabel('Lokasi Kecamatan *', isDark),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _inputKecamatan,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 13),
                    items: listKecamatanLokerForm.map((kec) => DropdownMenuItem(value: kec, child: Text(kec))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _inputKecamatan = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Custom Full Address (Ketik Sendiri)
              _buildFormLabel('Alamat Lengkap (Ketik Sendiri) *', isDark),
              _buildTextField(
                controller: _addressController,
                hint: 'Misal: Jl. Raya Balen No. 45, Desa Balenrejo, RT 03/RW 01',
                isDark: isDark,
                maxLines: 2,
                validator: (val) => val == null || val.trim().isEmpty ? 'Mohon ketik alamat lengkap' : null,
              ),
              const SizedBox(height: 14),

              // Salary Range
              _buildFormLabel('Estimasi Gaji / Upah', isDark),
              _buildTextField(
                controller: _salaryController,
                hint: 'Misal: Rp 2.500.000 / bulan atau UMK Bojonegoro',
                isDark: isDark,
              ),
              const SizedBox(height: 14),

              // Description
              _buildFormLabel('Deskripsi Pekerjaan *', isDark),
              _buildTextField(
                controller: _descController,
                hint: 'Jelaskan tugas utama, jam kerja, dan rincian pekerjaan...',
                isDark: isDark,
                maxLines: 4,
                validator: (val) => val == null || val.trim().isEmpty ? 'Mohon isi deskripsi pekerjaan' : null,
              ),
              const SizedBox(height: 14),

              // Requirements
              _buildFormLabel('Persyaratan & Kualifikasi (Satu per baris) *', isDark),
              _buildTextField(
                controller: _reqController,
                hint: 'Pendidikan minimal SMA/SMK\nMenguasai Komputer\nSehat Jasmani & Rohani',
                isDark: isDark,
                maxLines: 4,
                validator: (val) => val == null || val.trim().isEmpty ? 'Mohon isi persyaratan pekerjaan' : null,
              ),
              const SizedBox(height: 14),

              // Contact Person & Phone Info
              const Text(
                'Kontak & Penanggung Jawab Lowongan',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
              ),
              const SizedBox(height: 8),

              // Contact Name Input
              _buildFormLabel('Nama Penanggung Jawab / HRD *', isDark),
              _buildTextField(
                controller: _contactNameController,
                hint: 'Misal: Bpk. Supardi (Sekdes) / Ibu Ani (HRD)',
                isDark: isDark,
                validator: (val) => val == null || val.trim().isEmpty ? 'Mohon isi nama penanggung jawab' : null,
              ),
              const SizedBox(height: 14),

              // Contact Phone & WhatsApp
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormLabel('No. Penanggung Jawab *', isDark),
                        _buildTextField(
                          controller: _phoneController,
                          hint: '081234567890',
                          isDark: isDark,
                          keyboardType: TextInputType.phone,
                          validator: (val) => val == null || val.trim().isEmpty ? 'Isi no. penanggung jawab' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormLabel('No. WhatsApp *', isDark),
                        _buildTextField(
                          controller: _waController,
                          hint: '081234567890',
                          isDark: isDark,
                          keyboardType: TextInputType.phone,
                          validator: (val) => val == null || val.trim().isEmpty ? 'Isi WhatsApp' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Social Media & Links Header
              const Text(
                'Media Sosial & Kontak Tambahan (Opsional)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
              ),
              const SizedBox(height: 8),

              // Instagram Handle Input
              _buildFormLabel('Instagram (Username / Handle)', isDark),
              _buildTextField(
                controller: _igController,
                hint: 'Misal: @kantor_desabalenrejo atau @perusahaan_id',
                isDark: isDark,
              ),
              const SizedBox(height: 10),

              // Email HRD Input
              _buildFormLabel('Email Perusahaan / HRD', isDark),
              _buildTextField(
                controller: _emailController,
                hint: 'Misal: hrd@perusahaan.co.id',
                isDark: isDark,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),

              // Website URL Input
              _buildFormLabel('Website / Link Media Sosial Lain', isDark),
              _buildTextField(
                controller: _webController,
                hint: 'Misal: www.perusahaan.co.id',
                isDark: isDark,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submitNewLoker,
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  label: const Text(
                    'Submit & Tayangkan Lowongan',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 12),
        filled: true,
        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildMiniBadge(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF059669)),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
