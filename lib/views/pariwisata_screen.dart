import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'khayangan_api_data.dart';
import 'negeri_atas_angin_data.dart';
import 'kebun_belimbing_data.dart';
import 'gofun_data.dart';
import 'bendungan_gerak_data.dart';
import 'waduk_pacal_data.dart';
import 'samin_bojonegoro_data.dart';
import 'museum_rajekwesi_data.dart';
import 'wali_kidangan_data.dart';
import 'klenteng_hok_swie_bio_data.dart';
import 'makam_jojonegoro_data.dart';
import 'masjid_annahdla_data.dart';
import 'masjid_agung_darussalam_data.dart';
import 'teksas_wonocolo_data.dart';
import '../services/admin_data_service.dart';

class TourismSpot {
  final String id;
  final String title;
  final String category; // 'rekreasi' or 'sejarah_budaya'
  final String categoryLabel;
  final String description;
  final String address;
  final String openHours;
  final String ticketPrice;
  final List<String> facilities;
  final IconData icon;
  final Color themeColor;
  final String mapQuery;
  final String? imagePath;
  final String? imageUrl;
  final String? transportInfo;
  final List<String>? tips;

  TourismSpot({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryLabel,
    required this.description,
    required this.address,
    required this.openHours,
    required this.ticketPrice,
    required this.facilities,
    required this.icon,
    required this.themeColor,
    required this.mapQuery,
    this.imagePath,
    this.imageUrl,
    this.transportInfo,
    this.tips,
  });
}

class PariwisataScreen extends StatefulWidget {
  final bool isDarkMode;

  const PariwisataScreen({super.key, required this.isDarkMode});

  @override
  State<PariwisataScreen> createState() => _PariwisataScreenState();
}

class _PariwisataScreenState extends State<PariwisataScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

  List<TourismSpot> get _spots {
    return AdminDataService()
        .pariwisataList
        .where((item) => item.isPublished)
        .map(_itemToSpot)
        .toList();
  }

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

  List<TourismSpot> _getFilteredSpots(String category) {
    return _spots.where((spot) {
      final matchesCategory = spot.category == category ||
          (category == 'religi' && (spot.category == 'religi' || spot.id == 'klenteng_hok_swie_bio' || spot.id == 'makam_jojonegoro')) ||
          (category == 'sejarah_budaya' && (spot.category == 'sejarah_budaya' || spot.id == 'wali_kidangan' || spot.id == 'makam_jojonegoro' || spot.id == 'masjid_agung_darussalam' || spot.id == 'teksas_wonocolo')) ||
          ((spot.id == 'kayangan_api' || spot.id == 'teksas_wonocolo') && (category == 'rekreasi' || category == 'sejarah_budaya'));
      final matchesQuery = _searchQuery.isEmpty ||
          spot.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          spot.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          spot.address.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _openDetailScreen(TourismSpot spot) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TourismDetailScreen(
          spot: spot,
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
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
                          Color(0xFF0B2545), // Dark Royal Blue
                          Color(0xFF0A5560), // Dark Teal
                        ]
                      : const [
                          Color(0xFF0D62F1), // Royal Blue SuperApp
                          Color(0xFF06B6D4), // Cyan Pariwisata
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kTextTabBarHeight + 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: isDark
                        ? const [
                            Color(0xFF0B2545), // Dark Royal Blue
                            Color(0xFF0A5560), // Dark Teal
                          ]
                        : const [
                            Color(0xFF0D62F1), // Royal Blue
                            Color(0xFF06B6D4), // Cyan
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
          body: Column(
            children: [
              // Search Input Bar
              Container(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(fontSize: 13.5, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    hintText: 'Cari destinasi wisata atau lokasi...',
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Tab View List Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSpotList(_getFilteredSpots('rekreasi'), isDark),
                    _buildSpotList(_getFilteredSpots('sejarah_budaya'), isDark),
                    _buildSpotList(_getFilteredSpots('religi'), isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpotList(List<TourismSpot> spots, bool isDark) {
    if (spots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 54, color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8)),
            const SizedBox(height: 12),
            Text(
              'Destinasi tidak ditemukan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Coba kata kunci pencarian yang lain.',
              style: TextStyle(fontSize: 12.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: spots.length,
      itemBuilder: (context, index) {
        final spot = spots[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 30 : 10),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _openDetailScreen(spot),
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSpotImageWidget(spot, height: 170, borderRadius: const BorderRadius.vertical(top: Radius.circular(18))),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Row(
                        children: [
                          Expanded(
                            child: Container(
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
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () => _openDetailScreen(spot),
                            style: TextButton.styleFrom(
                              foregroundColor: spot.themeColor,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                            icon: const Text('Detail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            label: const Icon(Icons.arrow_forward_rounded, size: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Image Loader Helper for Local Asset & Network Fallback
Widget buildSpotImageWidget(TourismSpot spot, {double height = 200, BorderRadius? borderRadius}) {
  Widget placeholder = _buildImagePlaceholder(spot, height);

  if (spot.id == 'kayangan_api') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        khayanganApiBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'atas_angin') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        negeriAtasAnginBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'belimbing_ngringinrejo') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        kebunBelimbingBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'gofun_bojonegoro') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        gofunBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'bendungan_gerak') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        bendunganGerakBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'waduk_pacal') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        wadukPacalBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'samin_bojonegoro') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        saminBojonegoroBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'museum_rajekwesi') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        museumRajekwesiBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'wali_kidangan') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        waliKidanganBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'klenteng_hok_swie_bio') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        klentengHokSwieBioBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'masjid_agung_darussalam') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        masjidAgungDarussalamBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'makam_jojonegoro') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        makamJojonegoroBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'masjid_margomulyo') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        masjidAnNahdlaBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'teksas_wonocolo') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        teksasWonocoloBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.imagePath != null) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.asset(
        spot.imagePath!,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          if (spot.imageUrl != null) {
            return Image.network(
              spot.imageUrl!,
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, err, stack) => placeholder,
            );
          }
          return placeholder;
        },
      ),
    );
  } else if (spot.imageUrl != null) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.network(
        spot.imageUrl!,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, err, stack) => placeholder,
      ),
    );
  }
  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(16),
    child: placeholder,
  );
}

Widget _buildImagePlaceholder(TourismSpot spot, double height) {
  return Container(
    width: double.infinity,
    height: height,
    color: spot.themeColor.withAlpha(25),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(spot.icon, size: 44, color: spot.themeColor),
          const SizedBox(height: 6),
          Text(
            spot.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: spot.themeColor, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}

// === FULL 1 LAYAR PENUH DETAIL SCREEN ===
class TourismDetailScreen extends StatelessWidget {
  final TourismSpot spot;
  final bool isDarkMode;

  const TourismDetailScreen({
    super.key,
    required this.spot,
    required this.isDarkMode,
  });

  void _openGoogleMaps(String query) async {
    final Uri url = Uri.parse(
      query.startsWith('http') ? query : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Full-screen Slivers Header Image with Back Button
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: spot.themeColor,
            leading: CircleAvatar(
              backgroundColor: Colors.black.withAlpha(120),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                spot.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 10)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  buildSpotImageWidget(spot, height: 280, borderRadius: BorderRadius.zero),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Detail Content (Full 1 Layar Page)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: spot.themeColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(spot.icon, color: spot.themeColor, size: 24),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: spot.themeColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          spot.categoryLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: spot.themeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Tentang Destinasi Wisata',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    spot.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 14),

                  // Information Cards
                  _buildDetailCard(Icons.location_on_rounded, 'Alamat Lengkap', spot.address, spot.themeColor, isDark),
                  const SizedBox(height: 12),
                  _buildDetailCard(Icons.access_time_filled_rounded, 'Jam Operasional', spot.openHours, spot.themeColor, isDark),
                  const SizedBox(height: 12),
                  _buildDetailCard(Icons.confirmation_number_rounded, 'Harga Tiket Masuk', spot.ticketPrice, spot.themeColor, isDark),
                  const SizedBox(height: 20),

                  Text(
                    'Fasilitas Lengkap:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: spot.facilities.map((fasi) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 14, color: spot.themeColor),
                            const SizedBox(width: 6),
                            Text(
                              fasi,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (spot.transportInfo != null) ...[
                    const SizedBox(height: 20),
                    _buildDetailCard(Icons.directions_car_rounded, 'Akses & Transportasi', spot.transportInfo!, spot.themeColor, isDark),
                  ],
                  if (spot.tips != null && spot.tips!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Tips & Saran Pengunjung:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: spot.themeColor.withAlpha(15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: spot.themeColor.withAlpha(40),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: spot.tips!.map((tip) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.lightbulb_rounded, size: 16, color: spot.themeColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    tip,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openGoogleMaps(spot.mapQuery),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: spot.themeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.map_rounded, size: 22),
                      label: const Text(
                        'Petunjuk Arah (Google Maps)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String title, String value, Color color, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
