import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CctvLocation {
  final String id;
  final String title;
  final String locationName;
  final String category;
  final bool isOnline;
  final String streamUrl;
  final IconData icon;

  const CctvLocation({
    required this.id,
    required this.title,
    required this.locationName,
    required this.category,
    required this.isOnline,
    required this.streamUrl,
    required this.icon,
  });
}

class CctvScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const CctvScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<CctvScreen> createState() => _CctvScreenState();
}

class _CctvScreenState extends State<CctvScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Simpang Kota',
    'Area Publik',
    'Terminal & Pasar',
  ];

  final List<CctvLocation> _cctvList = const [
    CctvLocation(
      id: '1',
      title: 'CCTV Simpang 4 Adipura',
      locationName: 'Jl. Ahmad Yani - Jl. Veteran, Kota Bojonegoro',
      category: 'Simpang Kota',
      isOnline: true,
      streamUrl: 'https://bojonegorokab.go.id/gis-cctv/0',
      icon: Icons.traffic_rounded,
    ),
    CctvLocation(
      id: '2',
      title: 'CCTV Alun-Alun Bojonegoro',
      locationName: 'Pusat Kota / Kawasan Alun-Alun Kab. Bojonegoro',
      category: 'Area Publik',
      isOnline: true,
      streamUrl: 'https://bojonegorokab.go.id/gis-cctv/0',
      icon: Icons.park_rounded,
    ),
    CctvLocation(
      id: '3',
      title: 'CCTV Terminal Type A Rajekwesi',
      locationName: 'Kawasan Terminal Bus Rajekwesi Bojonegoro',
      category: 'Terminal & Pasar',
      isOnline: true,
      streamUrl: 'https://bojonegorokab.go.id/gis-cctv/0',
      icon: Icons.directions_bus_rounded,
    ),
    CctvLocation(
      id: '4',
      title: 'CCTV Pasar Kota Bojonegoro',
      locationName: 'Area Pintu Masuk Utama Pasar Kota',
      category: 'Terminal & Pasar',
      isOnline: true,
      streamUrl: 'https://bojonegorokab.go.id/gis-cctv/0',
      icon: Icons.storefront_rounded,
    ),
    CctvLocation(
      id: '5',
      title: 'CCTV Simpang 4 Balen',
      locationName: 'Jl. Raya Bojonegoro - Babat (Balen)',
      category: 'Simpang Kota',
      isOnline: true,
      streamUrl: 'https://bojonegorokab.go.id/gis-cctv/0',
      icon: Icons.alt_route_rounded,
    ),
    CctvLocation(
      id: '6',
      title: 'CCTV Kawasan Dander Park',
      locationName: 'Kawasan Wisata Dander, Bojonegoro',
      category: 'Area Publik',
      isOnline: false,
      streamUrl: 'https://bojonegorokab.go.id/gis-cctv/0',
      icon: Icons.nature_people_rounded,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openStreamUrl(String urlStr) async {
    var formattedUrl = urlStr.trim();
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }
    final Uri uri = Uri.parse(formattedUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', formattedUrl]);
        return;
      } catch (_) {}
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membuka streaming CCTV $urlStr...'),
          backgroundColor: const Color(0xFF0284C7),
        ),
      );
    }
  }

  List<CctvLocation> get _filteredCctv {
    return _cctvList.where((cctv) {
      final matchesQuery = cctv.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          cctv.locationName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Semua' || cctv.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final double topPadding = MediaQuery.of(context).padding.top;

    final primaryBlue = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);
    final headerBgColor = isDark ? const Color(0xFF072738) : const Color(0xFF0369A1);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textMain = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12, (topPadding > 0 ? topPadding : 16) + 4, 16, 20),
            decoration: BoxDecoration(
              color: headerBgColor,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Pantau CCTV Bojonegoro',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Dishub & Kominfo Kab. Bojonegoro',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE0F2FE),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onToggleDarkMode != null)
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: widget.onToggleDarkMode,
                    tooltip: 'Ganti Tema',
                  ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Input
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: TextStyle(fontSize: 13.5, color: textMain),
                      decoration: InputDecoration(
                        hintText: 'Cari titik CCTV lalu lintas / lokasi...',
                        hintStyle: TextStyle(fontSize: 13, color: textSecondary),
                        prefixIcon: Icon(Icons.search_rounded, color: textSecondary, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Category Filter Chips
                  SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = _selectedCategory == cat;
                        return InkWell(
                          onTap: () => setState(() => _selectedCategory = cat),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryBlue
                                  : (isDark ? const Color(0xFF1E293B) : Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? primaryBlue : borderColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected ? Colors.white : textMain,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title & Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kamera CCTV Live',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textMain,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: primaryBlue.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_filteredCctv.length} Lokasi',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // CCTV Grid List
                  if (_filteredCctv.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.videocam_off_outlined, size: 40, color: textSecondary),
                          const SizedBox(height: 10),
                          Text(
                            'Kamera CCTV tidak ditemukan',
                            style: TextStyle(fontSize: 13, color: textMain, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredCctv.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final item = _filteredCctv[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Video Preview Thumbnail Container
                              Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            item.icon,
                                            size: 38,
                                            color: Colors.white38,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: item.isOnline
                                                      ? const Color(0xFF22C55E)
                                                      : const Color(0xFFEF4444),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                item.isOnline ? 'LIVE STREAMING' : 'OFFLINE',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: item.isOnline
                                                      ? const Color(0xFF4ADE80)
                                                      : const Color(0xFFFCA5A5),
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Play Button Overlay
                                  Positioned.fill(
                                    child: Center(
                                      child: Material(
                                        color: Colors.black45,
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
                                          onTap: () => _openStreamUrl(item.streamUrl),
                                          child: const Padding(
                                            padding: EdgeInsets.all(14),
                                            child: Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Online Badge Top Right
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: item.isOnline ? const Color(0xFF166534) : const Color(0xFF991B1B),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item.isOnline ? 'ONLINE' : 'MAINTENANCE',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Info Section
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w600,
                                        color: textMain,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 13,
                                          color: textSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            item.locationName,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: textSecondary,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryBlue,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          elevation: 0,
                                        ),
                                        onPressed: () => _openStreamUrl(item.streamUrl),
                                        icon: const Icon(Icons.videocam_rounded, size: 16),
                                        label: const Text(
                                          'Tonton Live Stream',
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
