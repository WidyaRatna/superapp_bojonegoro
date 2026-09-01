import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../widgets/superapp_header.dart';
import '../services/admin_data_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PerhubunganScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const PerhubunganScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<PerhubunganScreen> createState() => _PerhubunganScreenState();
}

class _PerhubunganScreenState extends State<PerhubunganScreen> {
  String _formatPhoneDisplay(String raw) {
    final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean == '081333555695') return '081 333 555 695';
    if (clean.length == 12) {
      return '${clean.substring(0, 4)} ${clean.substring(4, 7)} ${clean.substring(7, 10)} ${clean.substring(10)}';
    }
    return raw;
  }

  // Helper for opening web URLs with error handling
  Future<void> _openWebUrl(String urlStr) async {
    var formattedUrl = urlStr.trim();
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }
    final Uri uri = Uri.parse(formattedUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', formattedUrl]);
        return;
      } catch (_) {}
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membuka portal $urlStr...'),
          backgroundColor: const Color(0xFF0284C7),
        ),
      );
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final Uri phoneUri = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
        return;
      }
    } catch (_) {}

    final Uri waUri = Uri.parse('https://wa.me/62${cleanPhone.startsWith('0') ? cleanPhone.substring(1) : cleanPhone}');
    try {
      if (await canLaunchUrl(waUri)) {
        await launchUrl(waUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Menghubungi $phoneNumber...'),
          backgroundColor: const Color(0xFF0284C7),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    // Color Palette
    final primaryBlue = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);
    final headerGradient = isDark
        ? const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF072738), Color(0xFF0C4A6E)],
          )
        : const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF0369A1), Color(0xFF0284C7)],
          );
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F9F8);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textMain = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);

    return AnimatedBuilder(
      animation: AdminDataService(),
      builder: (context, _) {
        final perhubunganItems = AdminDataService().perhubunganList;

        return Scaffold(
          backgroundColor: bgColor,
          body: Column(
            children: [
              SuperAppHeader(
                title: 'Layanan Perhubungan',
                subtitle: 'Dinas Perhubungan Kabupaten Bojonegoro',
                gradient: headerGradient,
                isDarkMode: isDark,
                onToggleDarkMode: widget.onToggleDarkMode,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2. Informasi Dinas
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: cardBgColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(isDark ? 40 : 10),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryBlue.withAlpha(isDark ? 35 : 20),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.directions_bus_filled_outlined,
                                  color: primaryBlue,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dinas Perhubungan Kabupaten Bojonegoro',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: textMain,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Jl. Raya Kapas No. 1, Bojonegoro',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    GestureDetector(
                                      onTap: () => _openWebUrl('https://dinhub.bojonegorokab.go.id/'),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'dinhub.bojonegorokab.go.id',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: primaryBlue,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.arrow_outward_rounded,
                                            color: primaryBlue,
                                            size: 13,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Section Title
                        Text(
                          'Layanan Utama',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: textSecondary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Render Perhubungan Items List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: perhubunganItems.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final item = perhubunganItems[index];

                            return InkWell(
                              onTap: () {
                                if (item.phoneNumber.isNotEmpty) {
                                  _makePhoneCall(item.phoneNumber);
                                } else if (item.urlStr.isNotEmpty) {
                                  _openWebUrl(item.urlStr);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Membuka ${item.title}...')),
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: cardBgColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: borderColor, width: 1.2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(isDark ? 40 : 12),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: primaryBlue.withAlpha(isDark ? 35 : 20),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            item.icon,
                                            color: primaryBlue,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.title,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: textMain,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                item.description,
                                                style: TextStyle(
                                                  fontSize: 12.5,
                                                  color: textSecondary,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          color: textSecondary,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                    if (item.phoneNumber.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      Divider(height: 1, thickness: 1, color: borderColor.withAlpha(120)),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            'Butuh bantuan?',
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: textSecondary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          InkWell(
                                            onTap: () => _makePhoneCall(item.phoneNumber),
                                            borderRadius: BorderRadius.circular(4),
                                            child: Text(
                                              '${_formatPhoneDisplay(item.phoneNumber)} · Hubungi',
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.bold,
                                                color: primaryBlue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
