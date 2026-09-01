import 'package:flutter/material.dart';
import 'bojonegoro_logo.dart';
import '../views/profile_screen.dart';
import '../services/notification_service.dart';

/// Primary Wave Clipper for Top Header bottom edge (Smooth & Organic)
class HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 24);

    final firstControlPoint = Offset(size.width * 0.35, size.height);
    final firstEndPoint = Offset(size.width * 0.65, size.height - 18);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.85, size.height - 32);
    final secondEndPoint = Offset(size.width, size.height - 14);
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
    this.temperature = '25,1°C',
    this.weatherCondition = 'Cerah',
    this.windSpeed = '5,8 km/jam',
    this.onWeatherTap,
  });

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double headerHeight = 215 + (topPadding > 0 ? topPadding : 16);
    final bool effectiveDark = Theme.of(context).brightness == Brightness.dark || isDarkMode;

    return ClipPath(
      clipper: HeaderWaveClipper(),
      child: Container(
        height: headerHeight,
        width: double.infinity,
        color: const Color(0xFF071927),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            // Full Width Background Photo with Soft Dark Overlay
            Positioned.fill(
              child: Image.asset(
                'assets/images/bojonegoro_gate.jpg',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.35),
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: const Color(0xFF0B192C));
                },
              ),
            ),

            // Soft Dark Gradient Overlay for easy legibility
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha(160),
                      Colors.black.withAlpha(120),
                      const Color(0xFF0F172A).withAlpha(220),
                    ],
                  ),
                ),
              ),
            ),

            // Foreground Header Content protected against flex overflow
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
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
                            const BojonegoroLogoWidget(size: 40),
                            const SizedBox(width: 10),

                            // Greeting Text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Selamat datang di',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xFFCBD5E1),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  Text(
                                    'Kab. Bojonegoro',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Theme Toggle
                            InkWell(
                              onTap: onToggleTheme,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(25),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  effectiveDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
                                  color: effectiveDark ? Colors.amber : Colors.white,
                                  size: 19,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Notification Bell
                            AnimatedBuilder(
                              animation: NotificationService.instance,
                              builder: (context, child) {
                                final unreadCount = NotificationService.instance.unreadCount;
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    InkWell(
                                      onTap: onNotificationTap,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(25),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.notifications_none_rounded,
                                          color: Colors.white,
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                    if (unreadCount > 0)
                                      Positioned(
                                        right: 2,
                                        top: 2,
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFEF4444),
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 14,
                                            minHeight: 14,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$unreadCount',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(width: 8),

                            // User Profile Avatar
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
                                  16,
                                  20,
                                  avatarImagePath: UserProfileData.avatarImagePath,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: effectiveDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: effectiveDark ? Border.all(color: const Color(0xFF334155), width: 1) : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: onSearchChanged,
                            style: TextStyle(
                              color: effectiveDark ? Colors.white : const Color(0xFF0F172A),
                              fontSize: 13.5,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: 'Cari layanan, informasi, berita...',
                              hintStyle: TextStyle(
                                color: effectiveDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                fontSize: 13,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: effectiveDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                size: 19,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.campaign_rounded,
                                  color: effectiveDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                                  size: 21,
                                ),
                                onPressed: onQrTap,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Streamlined Weather Info Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: GestureDetector(
                          onTap: onWeatherTap,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.wb_sunny_rounded,
                                color: Color(0xFFFBBF24),
                                size: 15,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '$temperature · $weatherCondition · $windSpeed',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}