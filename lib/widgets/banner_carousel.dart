import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class BannerCarouselWidget extends StatefulWidget {
  final VoidCallback onViewServicesTap;

  const BannerCarouselWidget({
    super.key,
    required this.onViewServicesTap,
  });

  @override
  State<BannerCarouselWidget> createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  final List<Map<String, dynamic>> _posters = [
    {
      'category': 'LAYANAN PUBLIK',
      'title': 'Layanan Digital\nTerpadu 24 Jam',
      'subtitle': 'Urus dokumen & perizinan langsung dari HP Anda',
      'cta': 'Buka Layanan →',
      'icon': Icons.devices_rounded,
      'gradientColors': [Color(0xFF072738), Color(0xFF0369A1)],
      'accentColor': Color(0xFF38BDF8),
    },
    {
      'category': 'PENGUMUMAN RESMI',
      'title': 'Super App Kab. Bojonegoro',
      'subtitle': 'Integrasi 16+ layanan publik dalam satu aplikasi',
      'cta': 'Pelajari Selengkapnya →',
      'icon': Icons.campaign_rounded,
      'gradientColors': [Color(0xFF064E3B), Color(0xFF0F766E)],
      'accentColor': Color(0xFF2DD4BF),
    },
    {
      'category': 'PROGRAM UNGGULAN',
      'title': 'Bojonegoro Berdaya',
      'subtitle': 'Bantuan tani, beasiswa pelajar & fasilitas UMKM',
      'cta': 'Cek Program →',
      'icon': Icons.stars_rounded,
      'gradientColors': [Color(0xFF1E1B4B), Color(0xFF4338CA)],
      'accentColor': Color(0xFF818CF8),
    },
    {
      'category': 'AGENDA DAERAH',
      'title': 'Festival Budaya 2026',
      'subtitle': 'Pentas seni tradisional & bazar kuliner khas Bojonegoro',
      'cta': 'Jadwal Kegiatan →',
      'icon': Icons.festival_rounded,
      'gradientColors': [Color(0xFF78350F), Color(0xFFB45309)],
      'accentColor': Color(0xFFFBBF24),
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % _posters.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Swipeable PageView Poster Carousel
        SizedBox(
          height: 140,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _posters.length,
              itemBuilder: (context, index) {
                final poster = _posters[index];
                final gradientColors = poster['gradientColors'] as List<Color>;
                final accentColor = poster['accentColor'] as Color;
                final icon = poster['icon'] as IconData;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: widget.onViewServicesTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: gradientColors,
                        ),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Category Tag Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: accentColor.withAlpha(40),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    poster['category'] as String,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: accentColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Title
                                Text(
                                  poster['title'] as String,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.2,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Subtitle
                                Text(
                                  poster['subtitle'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFFCBD5E1),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Decorative Right Poster Icon Box
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              icon,
                              color: accentColor,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Carousel Dot Indicators (● ○ ○ ○)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_posters.length, (index) {
            final isActive = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
