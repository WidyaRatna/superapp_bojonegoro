import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTapTab;
  final VoidCallback onCenterQrTap;
  final bool isDarkMode;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTapTab,
    required this.onCenterQrTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Bottom Bar Background Card
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              border: isDarkMode ? const Border(top: BorderSide(color: Color(0xFF334155))) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDarkMode ? 40 : 20),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 1. Beranda Tab
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'Beranda',
                ),

                // 2. Layanan Tab
                _buildNavItem(
                  index: 1,
                  icon: Icons.grid_view_rounded,
                  label: 'Layanan',
                ),

                // Space for Center Raised Button
                const SizedBox(width: 54),

                // 3. Telepon Darurat Tab
                _buildNavItem(
                  index: 2,
                  icon: Icons.phone_in_talk_rounded,
                  label: 'Telepon Darurat',
                ),

                // 4. Profil Tab
                _buildNavItem(
                  index: 3,
                  icon: Icons.person_outline_rounded,
                  label: 'Profil',
                ),
              ],
            ),
          ),

          // Center Raised Circular Blue Floating QR Button
          Positioned(
            top: 2,
            child: GestureDetector(
              onTap: onCenterQrTap,
              child: Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0056E0), Color(0xFF0D62F1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D62F1).withAlpha(100),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(
                    color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                    width: 4,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    int badgeCount = 0,
  }) {
    final isSelected = currentIndex == index;
    final activeColor = isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF0D62F1);
    final inactiveColor = isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
    final color = isSelected ? activeColor : inactiveColor;

    return InkWell(
      onTap: () => onTapTab(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Text(
                        '$badgeCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
