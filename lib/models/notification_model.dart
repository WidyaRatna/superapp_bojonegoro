import 'package:flutter/material.dart';

enum NotificationCategory {
  pengumuman,
  layanan,
  berita,
}

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String categoryLabel;
  final NotificationCategory category;
  final String timeAgo;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryLabel,
    required this.category,
    required this.timeAgo,
    required this.timestamp,
    this.isRead = false,
  });

  IconData get categoryIcon {
    switch (category) {
      case NotificationCategory.pengumuman:
        return Icons.campaign_rounded;
      case NotificationCategory.layanan:
        return Icons.info_rounded;
      case NotificationCategory.berita:
        return Icons.newspaper_rounded;
    }
  }

  Color get categoryColor {
    switch (category) {
      case NotificationCategory.pengumuman:
        return const Color(0xFFB45309); // Soft Amber
      case NotificationCategory.layanan:
        return const Color(0xFF1D4ED8); // Soft Blue
      case NotificationCategory.berita:
        return const Color(0xFF047857); // Soft Emerald
    }
  }

  Color getCategoryBgColor(bool isDarkMode) {
    if (isDarkMode) {
      switch (category) {
        case NotificationCategory.pengumuman:
          return const Color(0xFF78350F).withAlpha(80);
        case NotificationCategory.layanan:
          return const Color(0xFF1E40AF).withAlpha(80);
        case NotificationCategory.berita:
          return const Color(0xFF065F46).withAlpha(80);
      }
    } else {
      switch (category) {
        case NotificationCategory.pengumuman:
          return const Color(0xFFFEF3C7);
        case NotificationCategory.layanan:
          return const Color(0xFFEFF6FF);
        case NotificationCategory.berita:
          return const Color(0xFFECFDF5);
      }
    }
  }
}
