import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/informasi_pangan_model.dart';

class InformasiPanganScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const InformasiPanganScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<InformasiPanganScreen> createState() => _InformasiPanganScreenState();
}

class _InformasiPanganScreenState extends State<InformasiPanganScreen> {
  // State for filters
  String _selectedKecamatanId = '';
  String _selectedPasarId = '';
  DateTime _selectedDate = DateTime.now();
  String _searchQuery = '';
  String _selectedCategoryFilter = 'Semua';
  bool _isTableView = false; // False = Card View, True = Table View

  // State for data and fetching
  List<FoodPriceItem> _foodPriceItems = sampleBojonegoroFoodPrices;
  bool _isLoading = false;
  String _tableTitle = 'Tabel Harga Bahan Pokok Kabupaten Bojonegoro';


  @override
  void initState() {
    super.initState();
    _fetchDisdagData();
  }

  String get _formattedDate {
    final year = _selectedDate.year.toString().padLeft(4, '0');
    final month = _selectedDate.month.toString().padLeft(2, '0');
    final day = _selectedDate.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String get _formattedDisplayDate {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year}';
  }

  List<PasarOption> get _availableMarkets {
    if (_selectedKecamatanId.isEmpty) {
      return listPasarDisdag;
    }
    return [
      const PasarOption(id: '', name: 'Semua Pasar di Kecamatan Ini', kecamatanId: ''),
      ...listPasarDisdag.where((p) => p.kecamatanId == _selectedKecamatanId || p.id.isEmpty),
    ];
  }

  Future<void> _fetchDisdagData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 8);
      
      final Uri uri = Uri.parse('https://disdag-online.bojonegorokab.go.id/trend/generate_content_tabel_harga');
      final HttpClientRequest request = await client.postUrl(uri);
      
      request.headers.contentType = ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8');
      
      final String body = 'id_skpd=${Uri.encodeComponent(_selectedKecamatanId)}'
          '&id_pasar=${Uri.encodeComponent(_selectedPasarId)}'
          '&tgl_harga=${Uri.encodeComponent(_formattedDate)}';
      
      request.write(body);
      
      final HttpClientResponse response = await request.close();
      
      if (response.statusCode == 200) {
        final String responseBody = await response.transform(utf8.decoder).join();
        final dynamic jsonData = jsonDecode(responseBody);
        
        if (jsonData is Map && jsonData['success'] == true) {
          final String kontenHarga = jsonData['konten_harga'] ?? '';
          final String judulTabel = jsonData['judul_tabel'] ?? '';
          
          final List<FoodPriceItem> parsedItems = parseDisdagHtmlTable(kontenHarga);
          
          if (mounted) {
            setState(() {
              if (parsedItems.isNotEmpty) {
                _foodPriceItems = parsedItems;
              }
              if (judulTabel.isNotEmpty) {
                _tableTitle = judulTabel.replaceAll(RegExp(r'<[^>]*>'), '').trim();
              }
              _isLoading = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      // Network timeout or offline fallback
    }

    if (mounted) {
      setState(() {
        _foodPriceItems = sampleBojonegoroFoodPrices;
        _tableTitle = 'Harga Bahan Pokok Bojonegoro ($_formattedDisplayDate)';
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: widget.isDarkMode
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Color(0xFF0D9488),
                    onPrimary: Colors.white,
                    surface: Color(0xFF1E293B),
                    onSurface: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF0D9488),
                    onPrimary: Colors.white,
                  ),
                ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchDisdagData();
    }
  }

  Future<void> _openDisdagWebsite() async {
    final Uri url = Uri.parse('https://disdag-online.bojonegorokab.go.id/trend/tabel');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka browser untuk URL Disdag.')),
        );
      }
    }
  }

  List<String> get _categories {
    final Set<String> cats = {'Semua'};
    for (final item in _foodPriceItems) {
      if (item.category.isNotEmpty) {
        cats.add(item.category);
      }
    }
    return cats.toList();
  }

  List<FoodPriceItem> get _filteredItems {
    return _foodPriceItems.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategoryFilter == 'Semua' || item.category == _selectedCategoryFilter;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  int get _upCount => _foodPriceItems.where((i) => i.trend == 'up').length;
  int get _downCount => _foodPriceItems.where((i) => i.trend == 'down').length;
  int get _stableCount => _foodPriceItems.where((i) => i.trend == 'stable').length;

  void _showItemDetailModal(FoodPriceItem item) {
    final isDark = widget.isDarkMode;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withAlpha(30),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.shopping_basket_rounded, color: Color(0xFF0D9488), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.category.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF0D9488),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        item.name,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Harga Hari Ini ($_formattedDisplayDate)', item.formattedPriceToday, isDark, isBold: true),
                  const Divider(height: 20),
                  _buildDetailRow('Harga Kemarin', item.formattedPriceYesterday, isDark),
                  const Divider(height: 20),
                  _buildDetailRow('Perubahan Nominal', item.formattedPriceChange, isDark,
                      color: item.trend == 'up'
                          ? Colors.red
                          : item.trend == 'down'
                              ? Colors.green
                              : Colors.grey),
                  const Divider(height: 20),
                  _buildDetailRow('Persentase Perubahan', item.formattedPercentChange, isDark,
                      color: item.trend == 'up'
                          ? Colors.red
                          : item.trend == 'down'
                              ? Colors.green
                              : Colors.grey),
                  const Divider(height: 20),
                  _buildDetailRow('Satuan Ukur', item.unit, isDark),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _openDisdagWebsite();
                },
                icon: const Icon(Icons.open_in_browser_rounded, color: Colors.white),
                label: const Text(
                  'Cek Tren Grafik di Web Disdag',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? (isDark ? Colors.white : const Color(0xFF0F172A)),
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Teal Header Container
          Container(
            padding: EdgeInsets.fromLTRB(16, (topPadding > 0 ? topPadding : 16) + 4, 16, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? const [
                        Color(0xFF042F2C),
                        Color(0xFF0D9488),
                        Color(0xFF0F766E),
                      ]
                    : const [
                        Color(0xFF0D9488),
                        Color(0xFF14B8A6),
                        Color(0xFF0F766E),
                      ],
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D9488).withAlpha(60),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar Controls
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
                          'Informasi Pangan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
                          onPressed: _fetchDisdagData,
                          tooltip: 'Perbarui Data',
                        ),
                        IconButton(
                          icon: const Icon(Icons.language_rounded, color: Colors.white, size: 22),
                          onPressed: _openDisdagWebsite,
                          tooltip: 'Buka Web Disdag',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    _tableTitle,
                    style: TextStyle(
                      color: Colors.white.withAlpha(235),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Body
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Filter Controls Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filter Lokasi & Tanggal',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Kecamatan Dropdown
                          Row(
                            children: [
                              const Icon(Icons.location_city_rounded, size: 18, color: Color(0xFF0D9488)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedKecamatanId,
                                      isExpanded: true,
                                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                                      style: TextStyle(
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      items: listKecamatanDisdag.map((kec) {
                                        return DropdownMenuItem<String>(
                                          value: kec.id,
                                          child: Text(kec.name, overflow: TextOverflow.ellipsis),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            _selectedKecamatanId = val;
                                            _selectedPasarId = '';
                                          });
                                          _fetchDisdagData();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Pasar Dropdown
                          Row(
                            children: [
                              const Icon(Icons.storefront_rounded, size: 18, color: Color(0xFF0D9488)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedPasarId,
                                      isExpanded: true,
                                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                                      style: TextStyle(
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      items: _availableMarkets.map((pasar) {
                                        return DropdownMenuItem<String>(
                                          value: pasar.id,
                                          child: Text(pasar.name, overflow: TextOverflow.ellipsis),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            _selectedPasarId = val;
                                          });
                                          _fetchDisdagData();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Date Picker Row
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_rounded, size: 18, color: Color(0xFF0D9488)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(context),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Tanggal: $_formattedDisplayDate',
                                          style: TextStyle(
                                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Icon(Icons.arrow_drop_down_rounded, size: 20, color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Metrics Summary Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildMetricCard('Total', '${_foodPriceItems.length}', const Color(0xFF0D9488), isDark),
                        const SizedBox(width: 8),
                        _buildMetricCard('Naik', '$_upCount', Colors.red, isDark, icon: Icons.trending_up_rounded),
                        const SizedBox(width: 8),
                        _buildMetricCard('Turun', '$_downCount', Colors.green, isDark, icon: Icons.trending_down_rounded),
                        const SizedBox(width: 8),
                        _buildMetricCard('Stabil', '$_stableCount', Colors.blue, isDark, icon: Icons.remove_rounded),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Search Bar & View Mode Toggle
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
                              border: Border.all(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val;
                                });
                              },
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                fontSize: 13,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Cari bahan pokok (beras, cabai, telur...)...',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.5),
                                prefixIcon: Icon(Icons.search_rounded, size: 20, color: Color(0xFF0D9488)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // View Switcher Button
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isTableView ? Icons.grid_view_rounded : Icons.table_rows_rounded,
                              color: const Color(0xFF0D9488),
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _isTableView = !_isTableView;
                              });
                            },
                            tooltip: _isTableView ? 'Tampilan Kartu' : 'Tampilan Tabel',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Horizontal Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategoryFilter == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: const Color(0xFF0D9488),
                            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCategoryFilter = cat;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Loading or List/Table Content
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(color: Color(0xFF0D9488)),
                            SizedBox(height: 14),
                            Text(
                              'Mengambil data dari Disdag Bojonegoro...',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_filteredItems.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.withAlpha(150)),
                            const SizedBox(height: 12),
                            Text(
                              'Komoditas tidak ditemukan',
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Coba gunakan kata kunci pencarian lain',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_isTableView)
                    _buildTableView(isDark)
                  else
                    _buildCardListView(isDark),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color, bool isDark, {IconData? icon}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: color),
                  const SizedBox(width: 4),
                ],
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardListView(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          final isUp = item.trend == 'up';
          final isDown = item.trend == 'down';
          final trendColor = isUp ? Colors.red : (isDown ? Colors.green : Colors.grey);
          final trendIcon = isUp ? Icons.arrow_upward_rounded : (isDown ? Icons.arrow_downward_rounded : Icons.remove_rounded);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => _showItemDetailModal(item),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Left Category Icon Box
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.shopping_bag_outlined, color: Color(0xFF0D9488), size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Commodity Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.category.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF0D9488),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Satuan: ${item.unit}',
                            style: const TextStyle(color: Colors.grey, fontSize: 11.5),
                          ),
                        ],
                      ),
                    ),

                    // Price & Trend Badge
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.formattedPriceToday,
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: trendColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(trendIcon, size: 12, color: trendColor),
                              const SizedBox(width: 2),
                              Text(
                                item.formattedPercentChange,
                                style: TextStyle(
                                  color: trendColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTableView(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16,
            headingRowColor: WidgetStateProperty.all(
              isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
            ),
            columns: [
              DataColumn(label: Text('Komoditas', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87))),
              DataColumn(label: Text('Satuan', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87))),
              DataColumn(label: Text('Kemarin', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87))),
              DataColumn(label: Text('Sekarang', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87))),
              DataColumn(label: Text('Perubahan', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87))),
            ],
            rows: _filteredItems.map((item) {
              final isUp = item.trend == 'up';
              final isDown = item.trend == 'down';
              final trendColor = isUp ? Colors.red : (isDown ? Colors.green : Colors.grey);

              return DataRow(
                onSelectChanged: (_) => _showItemDetailModal(item),
                cells: [
                  DataCell(
                    Text(item.name, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                  ),
                  DataCell(Text(item.unit, style: const TextStyle(color: Colors.grey))),
                  DataCell(Text(item.formattedPriceYesterday, style: const TextStyle(color: Colors.grey))),
                  DataCell(Text(item.formattedPriceToday, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87))),
                  DataCell(
                    Text(
                      '${item.formattedPriceChange} (${item.formattedPercentChange})',
                      style: TextStyle(color: trendColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
