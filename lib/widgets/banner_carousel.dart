import 'dart:async';
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

  final List<Map<String, String>> _banners = [
    {
      'title': 'Bojonegoro\nMaju & Sejahtera',
      'subtitle': 'Bersama membangun Bojonegoro yang lebih baik',
      'buttonText': 'Lihat Layanan >',
    },
    {
      'title': 'Festival Budaya\nBojonegoro 2026',
      'subtitle': 'Saksikan ragam seni & bazar kuliner khas daerah',
      'buttonText': 'Jadwal Acara >',
    },
    {
      'title': 'Layanan Digital\nTerpadu 24 Jam',
      'subtitle': 'Urus dokumen & perizinan langsung dari HP Anda',
      'buttonText': 'Panduan App >',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % _banners.length;
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
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0066FF),
                        Color(0xFF0052D4),
                        Color(0xFF4364F7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D62F1).withAlpha(100),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        // Decorative Sky Clouds
                        Positioned(
                          right: 15,
                          top: 12,
                          child: Icon(
                            Icons.cloud_rounded,
                            color: Colors.white.withAlpha(45),
                            size: 44,
                          ),
                        ),
                        Positioned(
                          right: 90,
                          top: 8,
                          child: Icon(
                            Icons.cloud_rounded,
                            color: Colors.white.withAlpha(30),
                            size: 32,
                          ),
                        ),

                        // Green Hills / Foliage Landscape Curve at Bottom Right
                        Positioned(
                          right: -10,
                          bottom: -20,
                          child: Container(
                            width: 170,
                            height: 70,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withAlpha(180),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(80),
                                topRight: Radius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 30,
                          bottom: -25,
                          child: Container(
                            width: 120,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF059669).withAlpha(220),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(60),
                              ),
                            ),
                          ),
                        ),

                        // Landmark Silhouettes on Right Side (Tugu Bojonegoro & Oil Rig / Pump)
                        Positioned(
                          right: 70,
                          bottom: 14,
                          child: Icon(
                            Icons.account_balance_rounded,
                            color: Colors.white.withAlpha(200),
                            size: 75,
                          ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 12,
                          child: Icon(
                            Icons.precision_manufacturing_rounded,
                            color: const Color(0xFF1E293B).withAlpha(220),
                            size: 65,
                          ),
                        ),

                        // Main Text & Button Content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    banner['title']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      height: 1.2,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    banner['subtitle']!,
                                    style: const TextStyle(
                                      color: Color(0xFFE0F2FE),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              // Interactive Action Pill Button
                              ElevatedButton(
                                onPressed: widget.onViewServicesTap,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0041C4),
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: Text(
                                  banner['buttonText']!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
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
        const SizedBox(height: 12),

        // Indicator Dots (Active Blue, Inactive Grey)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 10 : 8,
              height: _currentPage == index ? 10 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? const Color(0xFF0D62F1)
                    : const Color(0xFFCBD5E1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
