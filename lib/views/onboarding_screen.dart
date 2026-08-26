import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const OnboardingScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
    AuthService().completeOnboarding();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Main PageView with Hero Photo Upper Section & Integrated Text Below
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildSlide1(isDark),
              _buildSlide2(isDark),
              _buildSlide3(isDark),
            ],
          ),

          // Top Action Bar Overlaid on Hero Image (Dark Mode Toggle Left & "Lewati" Right)
          Positioned(
            top: (topPadding > 0 ? topPadding : 16) + 4,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(80),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: widget.onToggleDarkMode,
                    tooltip: 'Ganti Mode',
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(80),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: _finishOnboarding,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    ),
                    child: const Text(
                      'Lewati',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fixed Bottom Controls Bar (Kembali, Page Dots Indicator, Lanjut/Mulai Button)
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button (Visible on Slide 2 & 3)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _currentPage > 0 ? 1.0 : 0.0,
                  child: IgnorePointer(
                    ignoring: _currentPage == 0,
                    child: TextButton.icon(
                      onPressed: _previousPage,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        size: 18,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                      ),
                      label: Text(
                        'Kembali',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                ),

                // Center 3-Page Indicator Dots (● ○ ○)
                Row(
                  children: List.generate(3, (index) {
                    final isSelected = _currentPage == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: isSelected ? 24 : 8,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0D62F1)
                            : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                // Next / Mulai Button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D62F1),
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == 2 ? 'Mulai' : 'Lanjut',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (_currentPage < 2) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// SLIDE 1 — Semua Layanan (Immersive Hero Photo: Digital Public Service Portal)
  Widget _buildSlide1(bool isDark) {
    return Column(
      children: [
        // Large Immersive Hero Photo (Fills ~58% Screen Height)
        _buildHeroPhotoSection(
          imagePath: 'assets/images/SIMPATDU.jpg',
          alignment: Alignment.center,
          isDark: isDark,
        ),

        // Integrated Typography & Description Section
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Semua Layanan Bojonegoro,\nLebih Mudah',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    height: 1.25,
                    letterSpacing: -0.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Akses berbagai layanan publik Kabupaten Bojonegoro dalam satu aplikasi.',
                  style: TextStyle(
                    fontSize: 14.5,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// SLIDE 2 — Layanan Publik (Immersive Hero Photo: Pelayanan Publik)
  Widget _buildSlide2(bool isDark) {
    return Column(
      children: [
        // Large Immersive Hero Photo (Fills ~58% Screen Height)
        _buildHeroPhotoSection(
          imagePath: 'assets/images/Report-online.jpg',
          alignment: Alignment.topCenter,
          isDark: isDark,
        ),

        // Integrated Typography & Description Section
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Layanan Publik\nLebih Dekat',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    height: 1.25,
                    letterSpacing: -0.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Akses berbagai layanan pemerintah sesuai kebutuhan Anda.',
                  style: TextStyle(
                    fontSize: 14.5,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// SLIDE 3 — Informasi Bojonegoro (Immersive Hero Photo: Kayangan Api / Geopark)
  Widget _buildSlide3(bool isDark) {
    return Column(
      children: [
        // Large Immersive Hero Photo (Fills ~58% Screen Height)
        _buildHeroPhotoSection(
          imagePath: 'assets/images/Khayangan_Api.jpg',
          alignment: Alignment.center,
          isDark: isDark,
        ),

        // Integrated Typography & Description Section
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Informasi Bojonegoro\ndalam Satu Tempat',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    height: 1.25,
                    letterSpacing: -0.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Temukan berita, wisata, agenda, dan informasi resmi daerah dengan mudah.',
                  style: TextStyle(
                    fontSize: 14.5,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Helper: Immersive Hero Photo Section taking 58% Screen Height
  /// Fades seamlessly into screen background without card containers or badges
  Widget _buildHeroPhotoSection({
    required String imagePath,
    required Alignment alignment,
    required bool isDark,
  }) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final Color bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    return SizedBox(
      height: screenHeight * 0.58,
      width: double.infinity,
      child: Stack(
        children: [
          // Full-bleed Photo with Bottom Curve
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                alignment: alignment,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  child: const Center(
                    child: Icon(Icons.account_balance_rounded, size: 64, color: Color(0xFF0D62F1)),
                  ),
                ),
              ),
            ),
          ),

          // Top Gradient Overlay (Ensures top buttons remain clear & visible)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 110,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(120),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Bottom Gradient Fade Transition into Screen Background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 110,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    bgColor.withAlpha(180),
                    bgColor,
                  ],
                  stops: const [0.0, 0.65, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
