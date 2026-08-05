import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../models/service_model.dart';
import '../widgets/top_header.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/popular_services.dart';
import '../widgets/news_section.dart';
import '../widgets/news_detail_sheet.dart';
import '../widgets/bottom_nav_bar.dart';
import 'all_services_screen.dart';
import 'profile_screen.dart';
import 'laporan_screen.dart';
import 'emergency_screen.dart';
import 'pendidikan_screen.dart';
import 'kesehatan_screen.dart';
import 'kependudukan_screen.dart';
import 'pariwisata_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentNavIndex = 0;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter news articles based on search query
  List<NewsItem> get _filteredNews {
    if (_searchQuery.trim().isEmpty) return sampleNews;
    final query = _searchQuery.toLowerCase();
    return sampleNews.where((news) {
      return news.title.toLowerCase().contains(query) ||
          news.category.toLowerCase().contains(query) ||
          news.snippet.toLowerCase().contains(query);
    }).toList();
  }

  // Filter services based on search query
  List<ServiceCategory> get _homeGridServices {
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      return sampleServices.where((service) {
        final titleMatches = service.title.toLowerCase().contains(query);
        final subMatches =
            service.subServices.any((sub) => sub.toLowerCase().contains(query));
        return titleMatches || subMatches;
      }).toList();
    }
    final top7 = sampleServices.where((s) => s.id != 'lainnya').take(7).toList();
    final lainnya = sampleServices.firstWhere(
      (s) => s.id == 'lainnya',
      orElse: () => ServiceCategory(
        id: 'lainnya',
        title: 'Lainnya',
        icon: Icons.grid_view_rounded,
        color: const Color(0xFF64748B),
        subServices: [],
      ),
    );
    return [...top7, lainnya];
  }

  // Open All Services Category Screen ("Kategori Layanan") - Full Page Route
  void _openAllServicesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllServicesScreen(
          allServices: sampleServices,
          onServiceTap: _handleServiceTap,
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openPendidikanScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PendidikanScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openKesehatanScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KesehatanScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openKependudukanScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KependudukanScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _openPariwisataScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PariwisataScreen(
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
  }

  void _handleServiceTap(ServiceCategory category) {
    if (category.id == 'lainnya') {
      _openAllServicesScreen();
    } else if (category.id == 'pendidikan') {
      _openPendidikanScreen();
    } else if (category.id == 'kesehatan') {
      _openKesehatanScreen();
    } else if (category.id == 'kependudukan') {
      _openKependudukanScreen();
    } else if (category.id == 'pariwisata') {
      _openPariwisataScreen();
    } else if (category.id == 'kontak_darurat' || category.id == 'darurat') {
      _showEmergencyContactsModal();
    } else {
      _showServiceModal(category);
    }
  }

  // Open Service Detail Bottom Sheet
  void _showServiceModal(ServiceCategory category) {
    final isDark = widget.isDarkMode;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
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
            const SizedBox(height: 16),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: category.color.withAlpha(30),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(category.icon, color: category.color, size: 28),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Layanan ${category.title}',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${category.subServices.length} sub-layanan online tersedia',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            Column(
              children: category.subServices.map((subItem) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      title: Text(
                        subItem,
                        style: TextStyle(
                          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0D62F1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        if (category.id == 'pendidikan') {
                          _openPendidikanScreen();
                        } else if (category.id == 'kesehatan') {
                          _openKesehatanScreen();
                        } else if (category.id == 'kependudukan') {
                          _openKependudukanScreen();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Membuka formulir "$subItem"...'),
                              backgroundColor: const Color(0xFF0D62F1),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // Open Full News Detail Article Sheet
  void _openNewsDetail(NewsItem news) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewsDetailSheet(news: news),
    );
  }

  // Entrypoint for Laporan Warga button
  void _openLaporanWargaModal() {
    LaporanWargaService.openLaporanWarga(context, widget.isDarkMode);
  }

  // Telepon Darurat Screen Navigation (Full Screen)
  void _showEmergencyContactsModal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmergencyScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  // Profile Screen Navigation
  void _showProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  // Shared Weather Data
  final String _weatherTemp = '25.1°C';
  final String _windSpeed = '5.8 km/h';
  final String _deviceLocation = 'Bojonegoro, Jawa Timur';

  bool get _isNightWeather =>
      widget.isDarkMode || (DateTime.now().hour >= 18 || DateTime.now().hour < 6);
  IconData get _weatherIcon =>
      _isNightWeather ? Icons.nights_stay_rounded : Icons.light_mode_rounded;
  Color get _weatherColor =>
      _isNightWeather ? const Color(0xFFFDE047) : const Color(0xFFFBBF24);
  String get _weatherCondition => _isNightWeather ? 'Malam • Cerah' : 'Cerah';

  // Weather Details Dialog Modal with Modern Weather Icons & Dynamic GPS Location
  void _showWeatherDetailsModal() {
    final isDark = widget.isDarkMode;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Handle Bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),

            // Modal Header with Modern Sun/Moon Badge & Dynamic GPS Location Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isNightWeather
                              ? const [Color(0xFF1E293B), Color(0xFF334155)]
                              : const [Color(0xFFFBF7EE), Color(0xFFFEF3C7)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _weatherColor.withAlpha(80),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        _weatherIcon,
                        color: _isNightWeather
                            ? const Color(0xFFFDE047)
                            : const Color(0xFFD97706),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Cuaca Terkini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF064E3B).withAlpha(180)
                        : const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF10B981).withAlpha(80),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.near_me_rounded,
                        color: Color(0xFF10B981),
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _deviceLocation,
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF6EE7B7)
                              : const Color(0xFF166534),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Modern Weather Temperature Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isNightWeather
                      ? const [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF312E81)]
                      : const [Color(0xFF0052D4), Color(0xFF0D62F1), Color(0xFF1E6CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: (_isNightWeather
                            ? const Color(0xFF312E81)
                            : const Color(0xFF0D62F1))
                        .withAlpha(80),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _weatherTemp,
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.my_location_rounded,
                              color: Color(0xFF93C5FD), size: 13),
                          const SizedBox(width: 4),
                          Text(
                            '$_weatherCondition • GPS Otomatis HP',
                            style: const TextStyle(
                              color: Color(0xFFDBEAFE),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Ultra-Modern Glowing Sun/Moon Badge Graphic
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _weatherColor.withAlpha(140),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _weatherIcon,
                        size: 40,
                        color: _weatherColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Weather Metrics Grid (Angin, Kelembaban, AQI, UV) with Modern Icons
            Row(
              children: [
                _buildWeatherMetricCard('Kecepatan Angin', _windSpeed,
                    Icons.air_rounded, const Color(0xFF0284C7), isDark),
                const SizedBox(width: 10),
                _buildWeatherMetricCard('Kelembaban', '72%',
                    Icons.water_drop_rounded, const Color(0xFF059669), isDark),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildWeatherMetricCard('Kualitas Udara', 'AQI 34 (Baik)',
                    Icons.eco_rounded, const Color(0xFF10B981), isDark),
                const SizedBox(width: 10),
                _buildWeatherMetricCard('Indeks UV', '3 (Sedang)',
                    Icons.wb_twilight_rounded, const Color(0xFFF59E0B), isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherMetricCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Quick Info Cards Widget ("Informasi Cepat") - Modern 3-Card Design (PPID removed)
  Widget _buildQuickInfoSection(bool isDark) {
    final quickItems = [
      {
        'id': 'pangan',
        'title': 'Harga Pangan',
        'subtitle': 'Update Hari Ini',
        'icon': Icons.shopping_basket_rounded,
        'color': const Color(0xFF10B981), // Emerald Green
        'bgColor': isDark ? const Color(0xFF064E3B).withAlpha(150) : const Color(0xFFECFDF5),
        'onTap': () {
          final panganCategory = sampleServices.firstWhere(
            (s) => s.id == 'umkm',
            orElse: () => sampleServices.first,
          );
          _showServiceModal(panganCategory);
        },
      },
      {
        'id': 'cuaca',
        'title': 'Cuaca Daerah',
        'subtitle': '$_weatherTemp • $_weatherCondition',
        'icon': _weatherIcon,
        'color': _weatherColor,
        'bgColor': isDark ? const Color(0xFF78350F).withAlpha(150) : const Color(0xFFFEFCE8),
        'onTap': _showWeatherDetailsModal,
      },
      {
        'id': 'darurat',
        'title': 'Panggilan Darurat',
        'subtitle': 'Call Center 112',
        'icon': Icons.phone_in_talk_rounded,
        'color': const Color(0xFFEF4444), // Coral Red
        'bgColor': isDark ? const Color(0xFF7F1D1D).withAlpha(150) : const Color(0xFFFEF2F2),
        'onTap': _showEmergencyContactsModal,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Informasi Cepat',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Live Update',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3-Equal Columns Row (Ultra-Modern Cards)
          Row(
            children: quickItems.map((item) {
              final color = item['color'] as Color;
              final bgColor = item['bgColor'] as Color;
              final onTap = item['onTap'] as VoidCallback;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: color.withAlpha(60),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withAlpha(20),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Circular Icon Container with Soft Glow
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A) : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: color.withAlpha(40),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                item['icon'] as IconData,
                                color: color,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Title
                          Text(
                            item['title'] as String,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),

                          // Subtitle Pill / Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withAlpha(30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item['subtitle'] as String,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDark ? color : color.withAlpha(230),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Scrollable Page Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Curved Top Blue Header with Greeting, Search Bar & Theme Toggle
                TopHeaderWidget(
                  searchController: _searchController,
                  onSearchChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onNotificationTap: _showEmergencyContactsModal,
                  onProfileTap: _showProfile,
                  onQrTap: _openLaporanWargaModal,
                  isDarkMode: isDark,
                  onToggleTheme: widget.onToggleDarkMode,
                  temperature: _weatherTemp,
                  weatherCondition: _weatherCondition,
                  windSpeed: _windSpeed,
                  onWeatherTap: _showWeatherDetailsModal,
                ),

                // 2. Banner Slider Carousel (Placed neatly below top header)
                const SizedBox(height: 16),
                BannerCarouselWidget(
                  onViewServicesTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menampilkan daftar lengkap layanan daerah...'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // 3. Layanan Populer Section (2x4 Grid)
                PopularServicesWidget(
                  services: _homeGridServices,
                  onServiceTap: _handleServiceTap,
                  onViewAllTap: _openAllServicesScreen,
                  isDarkMode: isDark,
                ),
                const SizedBox(height: 24),

                // 4. Informasi Cepat Section
                _buildQuickInfoSection(isDark),
                const SizedBox(height: 26),

                // 5. News & Information Feed Section
                NewsSectionWidget(
                  newsList: _filteredNews,
                  onNewsTap: _openNewsDetail,
                  isDarkMode: isDark,
                ),

                // Bottom padding to clear floating nav bar
                const SizedBox(height: 60),
              ],
            ),
          ),

          // Floating Curved Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentNavIndex,
              onTapTab: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
                if (index == 2) {
                  _showEmergencyContactsModal();
                } else if (index == 3) {
                  _showProfile();
                }
              },
              onCenterQrTap: _openLaporanWargaModal,
              isDarkMode: isDark,
            ),
          ),
        ],
      ),
    );
  }
}