import 'package:flutter/material.dart';
import 'bojonegoro_logo.dart';
import '../views/profile_screen.dart';

/// Primary Wave Clipper for Top Header bottom edge (Smooth & Organic)
class HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);

    // Smooth wave: first dip down, then rise up gently to the right
    final firstControlPoint = Offset(size.width * 0.32, size.height - 2);
    final firstEndPoint = Offset(size.width * 0.62, size.height - 22);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.85, size.height - 42);
    final secondEndPoint = Offset(size.width, size.height - 18);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Secondary Wave Clipper for background depth effect (Smooth Glow)
class HeaderSecondaryWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 15);

    final firstControlPoint = Offset(size.width * 0.4, size.height - 45);
    final firstEndPoint = Offset(size.width * 0.72, size.height - 12);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.9, size.height - 2);
    final secondEndPoint = Offset(size.width, size.height - 28);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopHeaderWidget extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;
  final VoidCallback onQrTap;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final String temperature;
  final String weatherCondition;
  final String windSpeed;
  final VoidCallback? onWeatherTap;

  const TopHeaderWidget({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onNotificationTap,
    required this.onProfileTap,
    required this.onQrTap,
    required this.isDarkMode,
    required this.onToggleTheme,
    this.temperature = '25.1°C',
    this.weatherCondition = 'Cerah',
    this.windSpeed = '5.8 km/h',
    this.onWeatherTap,
  });

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double headerHeight = 225 + (topPadding > 0 ? topPadding : 16);

    return ClipPath(
      clipper: HeaderWaveClipper(),
      child: Container(
        height: headerHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF0052D4),
        ),
        child: Stack(
          children: [
            // Full Width Edge-to-Edge Background Photo of Bojonegoro Welcome Gate
            Positioned.fill(
              child: Image.asset(
                'assets/images/bojonegoro_gate.jpg',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.35),
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),

            // Smooth 3-Stop Dark & Royal Blue Gradient Overlay for High Legibility & Seamless Bottom Wave Blend
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDarkMode
                        ? [
                            Colors.black.withAlpha(170),
                            Colors.black.withAlpha(110),
                            const Color(0xFF030712).withAlpha(210),
                          ]
                        : [
                            Colors.black.withAlpha(150),
                            Colors.black.withAlpha(90),
                            const Color(0xFF003CB3).withAlpha(180),
                          ],
                  ),
                ),
              ),
            ),

                // Foreground Header Content (Row + Search Bar + Weather Row)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: topPadding > 0 ? topPadding : 16),
                      const SizedBox(height: 4),

                      // Top Header Row: Crest Logo + "Selamat datang di Kab. Bojonegoro", Bell & Profile Avatar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            // Official Crest Logo
                            const BojonegoroLogoWidget(size: 42),
                            const SizedBox(width: 10),

                            // Header Text: "Selamat datang di" / "Kab. Bojonegoro"
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Selamat datang di',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Kab. Bojonegoro',
                                    style: TextStyle(
                                      color: Color(0xFFDBEAFE),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Dark Mode / Light Mode Toggle Button
                            InkWell(
                              onTap: onToggleTheme,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(35),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isDarkMode ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
                                  color: isDarkMode ? Colors.amber : Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Notification Bell with Badge '3'
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                InkWell(
                                  onTap: onNotificationTap,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(35),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.notifications_none_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  top: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEF4444),
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 15,
                                      minHeight: 15,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '3',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),

                            // User Avatar Profile (CircleAvatar with white border)
                            GestureDetector(
                              onTap: onProfileTap,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: buildAvatarCircle(
                                  UserProfileData.avatarType,
                                  17,
                                  22,
                                  avatarImagePath: UserProfileData.avatarImagePath,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Floating White Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: isDarkMode ? Border.all(color: const Color(0xFF334155)) : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(35),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: onSearchChanged,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                              fontSize: 13.5,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: 'Cari layanan, informasi, berita...',
                              hintStyle: TextStyle(
                                color: isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                fontSize: 13.5,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  color: isDarkMode ? const Color(0xFF3B82F6) : const Color(0xFF64748B),
                                  size: 20,
                                ),
                                onPressed: onQrTap,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Weather Update Today ("Cuaca Hari Ini & Kecepatan Angin")
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: GestureDetector(
                          onTap: onWeatherTap,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Cuaca Hari Ini Item
                              Row(
                                children: [
                                  Builder(
                                    builder: (context) {
                                      final isNight = isDarkMode || (DateTime.now().hour >= 18 || DateTime.now().hour < 6);
                                      final weatherIcon = isNight ? Icons.nights_stay_rounded : Icons.wb_sunny_rounded;
                                      final weatherColor = isNight ? const Color(0xFFFDE047) : const Color(0xFFFBBF24);

                                      return Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: weatherColor.withAlpha(50),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          weatherIcon,
                                          color: weatherColor,
                                          size: 19,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        temperature,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black45,
                                              blurRadius: 4,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Cuaca Hari Ini • $weatherCondition',
                                        style: const TextStyle(
                                          color: Color(0xFFE2E8F0),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Kecepatan Angin Item
                              Row(
                                children: [
                                  const Icon(
                                    Icons.air_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        windSpeed,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black45,
                                              blurRadius: 4,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Text(
                                        'Kecepatan Angin',
                                        style: TextStyle(
                                          color: Color(0xFFE2E8F0),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    }