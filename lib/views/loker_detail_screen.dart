import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/loker_model.dart';

class LokerDetailScreen extends StatefulWidget {
  final LokerItem loker;
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const LokerDetailScreen({
    super.key,
    required this.loker,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<LokerDetailScreen> createState() => _LokerDetailScreenState();
}

class _LokerDetailScreenState extends State<LokerDetailScreen> {
  bool _localDark = false;

  @override
  void initState() {
    super.initState();
    _localDark = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(covariant LokerDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      setState(() {
        _localDark = widget.isDarkMode;
      });
    }
  }

  void _toggleDarkMode() {
    setState(() {
      _localDark = !_localDark;
    });
    if (widget.onToggleDarkMode != null) {
      widget.onToggleDarkMode!();
    }
  }

  bool _isDarkModeActive(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark || _localDark;
  }

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri url = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', 'tel:$cleanPhone']);
        return;
      } catch (_) {}
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menghubungi $phoneNumber...')),
      );
    }
  }

  Future<void> _openWhatsApp(BuildContext context, String phone, String jobTitle) async {
    var cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '62${cleanPhone.substring(1)}';
    }
    final message = Uri.encodeComponent('Halo, saya tertarik dengan lowongan pekerjaan "$jobTitle" yang diinformasikan di SuperApp Bojonegoro.');
    final Uri url = Uri.parse('https://wa.me/$cleanPhone?text=$message');
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', 'https://wa.me/$cleanPhone?text=$message']);
        return;
      } catch (_) {}
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membuka WhatsApp ($phone)...')),
      );
    }
  }

  Future<void> _openEmail(BuildContext context, String email, String jobTitle) async {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty) return;
    final Uri url = Uri.parse('mailto:$cleanEmail?subject=${Uri.encodeComponent("Lamaran Pekerjaan: $jobTitle")}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', 'mailto:$cleanEmail']);
        return;
      } catch (_) {}
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membuka email ke $cleanEmail...')),
      );
    }
  }

  Future<void> _openInstagram(BuildContext context, String handle) async {
    var cleanHandle = handle.trim().replaceAll('@', '');
    if (cleanHandle.isEmpty) return;
    final Uri url = Uri.parse('https://instagram.com/$cleanHandle');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membuka profil Instagram @$cleanHandle...')),
      );
    }
  }

  Future<void> _openWebsite(String webUrl) async {
    var urlStr = webUrl.trim();
    if (urlStr.isEmpty) return;
    if (!urlStr.startsWith('http://') && !urlStr.startsWith('https://')) {
      urlStr = 'https://$urlStr';
    }
    final Uri url = Uri.parse(urlStr);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', urlStr]);
        return;
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDarkModeActive(context);
    final double topPadding = MediaQuery.of(context).padding.top;
    final isAparat = widget.loker.postedByRole.contains('Aparat');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Premium Ocean Sapphire Header Bar
          Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16, (topPadding > 0 ? topPadding : 16) + 4, 16, 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? const [
                            Color(0xFF064E3B),
                            Color(0xFF047857),
                            Color(0xFF059669),
                          ]
                        : const [
                            Color(0xFF047857),
                            Color(0xFF059669),
                            Color(0xFF10B981),
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF059669).withAlpha(70),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Rincian Lowongan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: isDark ? Colors.amber : Colors.white,
                        size: 20,
                      ),
                      onPressed: _toggleDarkMode,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -15,
                top: 5,
                child: IgnorePointer(
                  child: Icon(
                    Icons.work_rounded,
                    size: 110,
                    color: Colors.white.withAlpha(15),
                  ),
                ),
              ),
            ],
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster Image Banner (If available)
                  if (widget.loker.posterImagePath.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                        child: Image.file(
                          File(widget.loker.posterImagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image_rounded, size: 48, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],

                  // Role & Job Type Badges
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isAparat
                              ? const Color(0xFF059669).withAlpha(isDark ? 35 : 15)
                              : const Color(0xFF0284C7).withAlpha(isDark ? 35 : 15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isAparat
                                ? const Color(0xFF059669).withAlpha(30)
                                : const Color(0xFF0284C7).withAlpha(30),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          widget.loker.postedByRole,
                          style: TextStyle(
                            color: isAparat ? const Color(0xFF059669) : const Color(0xFF0284C7),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.loker.jobType,
                          style: TextStyle(
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.loker.postedDate,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Job Title & Company Name
                  Text(
                    widget.loker.title,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.loker.companyName,
                    style: const TextStyle(
                      color: Color(0xFF059669),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Location & Salary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                Icons.location_on_rounded,
                                widget.loker.locationKecamatan,
                                isDark,
                              ),
                            ),
                            Container(height: 24, width: 1, color: Colors.grey.withAlpha(80)),
                            Expanded(
                              child: _buildInfoItem(
                                Icons.payments_rounded,
                                widget.loker.salaryRange,
                                isDark,
                              ),
                            ),
                          ],
                        ),
                        if (widget.loker.fullAddress.isNotEmpty) ...[
                          const Divider(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.home_work_rounded, size: 18, color: Color(0xFF059669)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.loker.fullAddress,
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (widget.loker.contactName.isNotEmpty) ...[
                          const Divider(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.person_pin_rounded, size: 18, color: Color(0xFF059669)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Penanggung Jawab: ${widget.loker.contactName}',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description Section
                  Text(
                    'Deskripsi Pekerjaan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.loker.description,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                      fontSize: 13.5,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Qualifications & Requirements Section
                  Text(
                    'Kualifikasi & Persyaratan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...widget.loker.requirements.map(
                    (req) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: 18, color: Color(0xFF059669)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              req,
                              style: TextStyle(
                                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Social Media & Links Section (If provided)
                  if (widget.loker.instagram.isNotEmpty || widget.loker.email.isNotEmpty || widget.loker.website.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Media Sosial & Kontak Resmi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        if (widget.loker.instagram.isNotEmpty)
                          ActionChip(
                            avatar: const Icon(Icons.camera_alt_rounded, size: 18, color: Color(0xFFE1306C)),
                            label: Text(widget.loker.instagram),
                            onPressed: () => _openInstagram(context, widget.loker.instagram),
                          ),
                        if (widget.loker.email.isNotEmpty)
                          ActionChip(
                            avatar: const Icon(Icons.email_rounded, size: 18, color: Color(0xFF059669)),
                            label: Text(widget.loker.email),
                            onPressed: () => _openEmail(context, widget.loker.email, widget.loker.title),
                          ),
                        if (widget.loker.website.isNotEmpty)
                          ActionChip(
                            avatar: const Icon(Icons.language_rounded, size: 18, color: Color(0xFF0D9488)),
                            label: Text(widget.loker.website),
                            onPressed: () => _openWebsite(widget.loker.website),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Pinned Bottom Contact Action Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => _makePhoneCall(context, widget.loker.contactPhone),
                      icon: const Icon(Icons.phone_rounded, color: Color(0xFF059669)),
                      label: const Text('Telepon', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 14.5)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF059669), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _openWhatsApp(context, widget.loker.contactWhatsapp, widget.loker.title),
                      icon: const Icon(Icons.chat_rounded, color: Colors.white),
                      label: const Text('WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.5)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
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

  Widget _buildInfoItem(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2563EB)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
