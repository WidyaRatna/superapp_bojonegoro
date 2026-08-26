import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const WelcomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  void _continueAsGuest(BuildContext context) {
    AuthService().loginAsGuest();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          isDarkMode: isDarkMode,
          onToggleDarkMode: onToggleDarkMode,
        ),
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          isDarkMode: isDarkMode,
          onToggleDarkMode: onToggleDarkMode,
        ),
      ),
    );
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(
          isDarkMode: isDarkMode,
          onToggleDarkMode: onToggleDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || isDarkMode;
    final double topPadding = MediaQuery.of(context).padding.top;
    final double screenHeight = MediaQuery.of(context).size.height;
    final Color bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Dark Mode Toggle Icon (Top Right, Compact Padding)
            Padding(
              padding: EdgeInsets.fromLTRB(16, topPadding > 0 ? 0 : 4, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: isDark ? Colors.amber : const Color(0xFF0D62F1),
                      size: 22,
                    ),
                    onPressed: onToggleDarkMode,
                    tooltip: 'Ganti Mode',
                  ),
                ],
              ),
            ),

            // Main Content Area (Compact Vector Hero + Title + Description + Actions)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 1. Compact Modern Vector Hero Graphic (3 Relevant Public Service Icons)
                        SizedBox(
                          height: screenHeight * 0.22,
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Ambient Background Glow Circles
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF0D62F1).withAlpha(isDark ? 30 : 16),
                                ),
                              ),
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF0D62F1).withAlpha(isDark ? 35 : 18),
                                    width: 1.5,
                                  ),
                                ),
                              ),

                              // Central Modern Glassmorphic Vector Emblem
                              Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xFF0052D4), Color(0xFF0D62F1), Color(0xFF2563EB)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0D62F1).withAlpha(isDark ? 70 : 35),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.grid_view_rounded,
                                  color: Colors.white,
                                  size: 38,
                                ),
                              ),

                              // 3 Relevant Public Service Icon Nodes
                              Positioned(
                                top: 12,
                                left: 48,
                                child: _buildVectorNode(Icons.badge_rounded, const Color(0xFF0D62F1), isDark),
                              ),
                              Positioned(
                                top: 12,
                                right: 48,
                                child: _buildVectorNode(Icons.local_hospital_rounded, const Color(0xFF10B981), isDark),
                              ),
                              Positioned(
                                bottom: 12,
                                child: _buildVectorNode(Icons.campaign_rounded, const Color(0xFFD97706), isDark),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 2. Title
                        Text(
                          'Selamat Datang di\nSuperApp Bojonegoro',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            height: 1.25,
                            letterSpacing: -0.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        // 3. Subtitle Description
                        Text(
                          'Akses berbagai layanan dan informasi Kabupaten Bojonegoro dalam satu aplikasi.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            height: 1.45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),

                        // 4. Action Button 1: Masuk (Primary Royal Blue)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () => _navigateToLogin(context),
                            icon: const Icon(Icons.login_rounded, color: Colors.white, size: 20),
                            label: const Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D62F1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 5. Action Button 2: Daftar (Outlined Royal Blue)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () => _navigateToRegister(context),
                            icon: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF0D62F1), size: 20),
                            label: const Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D62F1),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF0D62F1), width: 1.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 6. Action Button 3: Lanjutkan sebagai Tamu (Text Button with Arrow)
                        TextButton.icon(
                          onPressed: () => _continueAsGuest(context),
                          icon: Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                          label: Text(
                            'Lanjutkan sebagai Tamu',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper: Clean Vector Accent Node Widget
  Widget _buildVectorNode(IconData icon, Color color, bool isDark) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withAlpha(80),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(isDark ? 40 : 20),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 19),
    );
  }
}
