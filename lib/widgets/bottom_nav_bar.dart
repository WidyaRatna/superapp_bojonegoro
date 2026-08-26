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
    final isDark = Theme.of(context).brightness == Brightness.dark || isDarkMode;
    return SizedBox(
      height: 84,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Bottom Bar Background
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: isDark ? const Border(top: BorderSide(color: Color(0xFF334155), width: 1)) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 30 : 15),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 1. Beranda
                _buildNavItem(
                  context: context,
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'Beranda',
                ),

                // 2. Layanan
                _buildNavItem(
                  context: context,
                  index: 1,
                  icon: Icons.grid_view_rounded,
                  label: 'Layanan',
                ),

                // Center Button Clearance Space
                const SizedBox(width: 48),

                // 3. Darurat
                _buildNavItem(
                  context: context,
                  index: 2,
                  icon: Icons.phone_in_talk_rounded,
                  label: 'Darurat',
                ),

                // 4. Profil
                _buildNavItem(
                  context: context,
                  index: 3,
                  icon: Icons.person_outline_rounded,
                  label: 'Profil',
                ),
              ],
            ),
          ),

          // Primary Center Floating Button (Refined & Compact)
          Positioned(
            top: 6,
            child: GestureDetector(
              onTap: onCenterQrTap,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0284C7),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withAlpha(60),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    width: 3,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.campaign_rounded,
                    color: Colors.white,
                    size: 26,
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
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark || isDarkMode;
    final isSelected = currentIndex == index;
    final activeColor = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);
    final inactiveColor = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
    final color = isSelected ? activeColor : inactiveColor;

    return InkWell(
      onTap: () => onTapTab(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
