import 'package:flutter/material.dart';
import '../../services/admin_data_service.dart';

class AdminDashboardOverviewScreen extends StatefulWidget {
  final ValueChanged<int> onNavigateTab;

  const AdminDashboardOverviewScreen({
    super.key,
    required this.onNavigateTab,
  });

  @override
  State<AdminDashboardOverviewScreen> createState() => _AdminDashboardOverviewScreenState();
}

class _AdminDashboardOverviewScreenState extends State<AdminDashboardOverviewScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const List<Map<String, dynamic>> _adminServicesList = [
    {
      'title': 'Kependudukan',
      'subtitle': 'Kelola Layanan',
      'icon': Icons.badge_rounded,
      'color': Color(0xFF0D62F1),
      'tabIndex': 1,
    },
    {
      'title': 'Kesehatan',
      'subtitle': 'Kelola Layanan',
      'icon': Icons.medical_services_rounded,
      'color': Color(0xFF10B981),
      'tabIndex': 1,
    },
    {
      'title': 'Pendidikan',
      'subtitle': 'Beasiswa & Sekolah',
      'icon': Icons.school_rounded,
      'color': Color(0xFF8B5CF6),
      'tabIndex': 2,
    },
    {
      'title': 'Pajak & Retribusi',
      'subtitle': 'PBB & E-Payment',
      'icon': Icons.receipt_long_rounded,
      'color': Color(0xFFF59E0B),
      'tabIndex': 1,
    },
    {
      'title': 'Informasi Pangan',
      'subtitle': 'Harga Sembako',
      'icon': Icons.shopping_basket_rounded,
      'color': Color(0xFF06B6D4),
      'tabIndex': 3,
    },
    {
      'title': 'Pertanian',
      'subtitle': 'Info Pupuk & Tani',
      'icon': Icons.agriculture_rounded,
      'color': Color(0xFF059669),
      'tabIndex': 3,
    },
    {
      'title': 'Pariwisata',
      'subtitle': 'Destinasi Wisata',
      'icon': Icons.landscape_rounded,
      'color': Color(0xFFEC4899),
      'tabIndex': 4,
    },
    {
      'title': 'Pengaduan',
      'subtitle': 'SIAP LAPOR',
      'icon': Icons.campaign_rounded,
      'color': Color(0xFFEF4444),
      'tabIndex': 5,
    },
    {
      'title': 'Kontak Instansi',
      'subtitle': 'Direktori OPD',
      'icon': Icons.contact_phone_rounded,
      'color': Color(0xFF6366F1),
      'tabIndex': 6,
    },
    {
      'title': 'Kontak Darurat',
      'subtitle': 'Hotline 24 Jam',
      'icon': Icons.notifications_active_rounded,
      'color': Color(0xFFDC2626),
      'tabIndex': 7,
    },
    {
      'title': 'Lowongan Kerja',
      'subtitle': 'Verifikasi Loker',
      'icon': Icons.work_rounded,
      'color': Color(0xFFD97706),
      'tabIndex': 8,
    },
    {
      'title': 'Sosial',
      'subtitle': 'Bantuan Sosial',
      'icon': Icons.volunteer_activism_rounded,
      'color': Color(0xFF2563EB),
      'tabIndex': 9,
    },
    {
      'title': 'Perhubungan',
      'subtitle': 'Info Jasa Transport',
      'icon': Icons.directions_bus_rounded,
      'color': Color(0xFF0284C7),
      'tabIndex': 1,
    },
    {
      'title': 'Portal Berita',
      'subtitle': 'Artikel & Rilis',
      'icon': Icons.newspaper_rounded,
      'color': Color(0xFF7C3AED),
      'tabIndex': 10,
    },
    {
      'title': 'CCTV',
      'subtitle': 'Streaming Kota',
      'icon': Icons.videocam_rounded,
      'color': Color(0xFF475569),
      'tabIndex': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final adminService = AdminDataService();

    final filteredServices = _adminServicesList.where((item) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final title = (item['title'] as String).toLowerCase();
      final sub = (item['subtitle'] as String).toLowerCase();
      return title.contains(q) || sub.contains(q);
    }).toList();

    return ListenableBuilder(
      listenable: adminService,
      builder: (context, child) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner (SuperApp Royal Blue Card)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0052D4), Color(0xFF0D62F1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D62F1).withAlpha(50),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 420;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 14),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Portal Pengelolaan SuperApp Bojonegoro',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat Datang, Admin!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isNarrow ? 19 : 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Kelola konten 15 layanan publik, berita, wisata, & lowongan kerja secara langsung.',
                                    style: TextStyle(
                                      color: Color(0xFFE0F2FE),
                                      fontSize: 12.5,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isNarrow) ...[
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(30),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.manage_accounts_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),

              // Search Bar (Identical to User Category Screen)
              Container(
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
                    hintText: 'Telusuri layanan yang dikelola...',
                    hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 13.5),
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D62F1), size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // System Metric Summary Cards (Clean & Compact Horizontal Row)
              LayoutBuilder(
                builder: (context, constraints) {
                  final cols = constraints.maxWidth > 750 ? 4 : (constraints.maxWidth > 480 ? 2 : 2);
                  final ratio = constraints.maxWidth < 400 ? 1.75 : 2.0;

                  return GridView.count(
                    crossAxisCount: cols,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: ratio,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildSummaryCard(
                        title: 'Total Layanan',
                        value: '${adminService.totalServices}',
                        icon: Icons.grid_view_rounded,
                        color: const Color(0xFF0D62F1),
                        isDark: isDark,
                      ),
                      _buildSummaryCard(
                        title: 'Berita Published',
                        value: '${adminService.publishedBeritaList.length}',
                        icon: Icons.newspaper_rounded,
                        color: const Color(0xFF10B981),
                        isDark: isDark,
                        onTap: () => widget.onNavigateTab(10),
                      ),
                      _buildSummaryCard(
                        title: 'Pending Loker',
                        value: '${adminService.pendingJobVerifications}',
                        icon: Icons.work_history_rounded,
                        color: const Color(0xFFF59E0B),
                        isDark: isDark,
                        onTap: () => widget.onNavigateTab(8),
                      ),
                      _buildSummaryCard(
                        title: 'Lapor Masuk',
                        value: '${adminService.totalReports}',
                        icon: Icons.campaign_rounded,
                        color: const Color(0xFFEF4444),
                        isDark: isDark,
                        onTap: () => widget.onNavigateTab(5),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Title Section: Seluruh Kategori Layanan Dikelola (15)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Seluruh Kategori Layanan Dikelola (${filteredServices.length})',
                    style: TextStyle(
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Admin Mode',
                    style: TextStyle(
                      color: const Color(0xFF0D62F1),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 15 Service Grid View (100% Visual Parity to User Category Screen Grid)
              LayoutBuilder(
                builder: (context, constraints) {
                  final int cols = constraints.maxWidth > 900
                      ? 8
                      : constraints.maxWidth > 600
                          ? 6
                          : 4; // Standard 4-column layout on mobile (Identical to User)

                  final double aspectRatio = constraints.maxWidth < 380 ? 0.68 : 0.74;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredServices.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 16,
                      childAspectRatio: aspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredServices[index];
                      final title = item['title'] as String;
                      final subtitle = item['subtitle'] as String;
                      final icon = item['icon'] as IconData;
                      final color = item['color'] as Color;
                      final tabIndex = item['tabIndex'] as int;

                      return InkWell(
                        onTap: () => widget.onNavigateTab(tabIndex),
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Circular Icon Badge (Identical to User AllServicesScreen)
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(12),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(icon, color: color, size: 24),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Title Label
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),

                            // Small Action Pill "Kelola →"
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withAlpha(15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                subtitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
