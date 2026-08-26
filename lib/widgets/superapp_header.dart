import 'package:flutter/material.dart';

/// Reusable Standard Header Component for SuperApp Bojonegoro Service Screens.
/// Ensures 100% visual consistency across all service screens (Header height,
/// rounded bottom radius 22px, title typography, back button, dark mode toggle).
class SuperAppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Gradient? gradient;
  final Color? backgroundColor;
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const SuperAppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.gradient,
    this.backgroundColor,
    required this.isDarkMode,
    this.onToggleDarkMode,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final bool effectiveDark = Theme.of(context).brightness == Brightness.dark || isDarkMode;

    // Default SuperApp Bojonegoro Royal Blue Gradient
    final defaultGradient = effectiveDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF071B36), Color(0xFF0F2B66)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0052D4), Color(0xFF0D62F1)],
          );

    final effectiveGradient = gradient ?? (backgroundColor == null ? defaultGradient : null);

    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;
    final bottomPadding = hasSubtitle ? 14.0 : 10.0;
    final topOffset = hasSubtitle ? 4.0 : 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12, (topPadding > 0 ? topPadding : 12.0) + topOffset, 12, bottomPadding),
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        color: effectiveGradient == null ? backgroundColor : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(effectiveDark ? 50 : 25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
            onPressed: onBackPressed ?? () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: effectiveDark ? const Color(0xFF93C5FD) : const Color(0xFFDBEAFE),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ...?actions,
          if (onToggleDarkMode != null)
            IconButton(
              icon: Icon(
                effectiveDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
                color: effectiveDark ? Colors.amber : Colors.white,
                size: 20,
              ),
              onPressed: onToggleDarkMode,
            ),
        ],
      ),
    );
  }
}
