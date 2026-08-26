import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService instance = NotificationService._internal();

  factory NotificationService() {
    return instance;
  }

  NotificationService._internal() {
    _initDefaultNotifications();
  }

  List<NotificationItem> _items = [];

  List<NotificationItem> get notifications => List.unmodifiable(_items);

  int get unreadCount => _items.where((item) => !item.isRead).length;

  void _initDefaultNotifications() {
    final now = DateTime.now();
    _items = [
      NotificationItem(
        id: 'notif_1',
        title: 'Pengumuman Baru',
        description: 'Ada informasi dan pengumuman terbaru dari Pemerintah Kabupaten Bojonegoro.',
        categoryLabel: 'Pengumuman',
        category: NotificationCategory.pengumuman,
        timeAgo: '5 menit lalu',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      NotificationItem(
        id: 'notif_2',
        title: 'Informasi Layanan',
        description: 'Terdapat informasi terbaru mengenai layanan publik Kabupaten Bojonegoro.',
        categoryLabel: 'Layanan',
        category: NotificationCategory.layanan,
        timeAgo: '2 jam lalu',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationItem(
        id: 'notif_3',
        title: 'Berita Terbaru',
        description: 'Baca informasi dan berita terbaru seputar Kabupaten Bojonegoro.',
        categoryLabel: 'Berita',
        category: NotificationCategory.berita,
        timeAgo: 'Kemarin',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: false,
      ),
    ];
  }

  void markAsRead(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1 && !_items[index].isRead) {
      _items[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    bool updated = false;
    for (var item in _items) {
      if (!item.isRead) {
        item.isRead = true;
        updated = true;
      }
    }
    if (updated) {
      notifyListeners();
    }
  }

  void removeNotification(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void resetToDefault() {
    _initDefaultNotifications();
    notifyListeners();
  }
}
