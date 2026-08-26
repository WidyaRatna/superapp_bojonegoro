import 'package:flutter/material.dart';
import '../widgets/superapp_header.dart';
import 'package:url_launcher/url_launcher.dart';

// Helper for making phone calls with system dialer app
Future<void> _makeCall(BuildContext context, String number, String name) async {
  final String cleanNumber = number.replaceAll(RegExp(r'[^0-9+]'), '');
  final Uri telUri = Uri.parse('tel:$cleanNumber');
  try {
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri, mode: LaunchMode.externalApplication);
      return;
    } else {
      await launchUrl(telUri);
      return;
    }
  } catch (_) {}

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menghubungkan panggilan darurat ke $name ($number)... 📞'),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// Helper for launching Play Store URL
Future<void> _launchPlayStoreUrl(BuildContext context, String urlString) async {
  final Uri uri = Uri.parse(urlString);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membuka Google Play Store: $urlString'),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}

// =============================================================================
// MAIN SCREEN: EMERGENCY SCREEN (HAS 3 SEPARATE MENU CARDS)
// =============================================================================
class EmergencyScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const EmergencyScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    final emergencyGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF7F1D1D), Color(0xFF991B1B)],
          )
        : const LinearGradient(
            colors: [Color(0xFF991B1B), Color(0xFFDC2626)],
          );

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Layanan Kontak Darurat',
            subtitle: 'Kabupaten Bojonegoro • Siaga 24 Jam',
            gradient: emergencyGradient,
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Menu Utama Layanan Darurat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // CARD MENU 1: SIAGA BRO PSC 119 & AMBULANS (Soft Red)
                  _buildCategoryMenuCard(
                    context,
                    title: 'SIAGA BRO PSC 119 & Ambulans',
                    categoryLabel: 'Layanan kegawatdaruratan medis 24 Jam (Gratis)',
                    icon: Icons.airport_shuttle_rounded,
                    color: const Color(0xFFDC2626),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AmbulansDetailScreen(
                            isDarkMode: widget.isDarkMode,
                            onToggleDarkMode: widget.onToggleDarkMode,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // CARD MENU 2: PEMADAM KEBAKARAN (DAMKAR) (Soft Orange)
                  _buildCategoryMenuCard(
                    context,
                    title: 'Pemadam Kebakaran (Damkar)',
                    categoryLabel: 'Dinas Pemadam Kebakaran & Penyelamatan',
                    icon: Icons.local_fire_department_rounded,
                    color: const Color(0xFFEA580C),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DamkarDetailScreen(
                            isDarkMode: widget.isDarkMode,
                            onToggleDarkMode: widget.onToggleDarkMode,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // CARD MENU 3: KEPOLISIAN (POLRES BOJONEGORO) (Soft Blue)
                  _buildCategoryMenuCard(
                    context,
                    title: 'Kepolisian (Polres & Polsek)',
                    categoryLabel: 'Sentra Pelayanan Kepolisian Terpadu (SPKT)',
                    icon: Icons.local_police_rounded,
                    color: const Color(0xFF2563EB),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KepolisianDetailScreen(
                            isDarkMode: widget.isDarkMode,
                            onToggleDarkMode: widget.onToggleDarkMode,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryMenuCard(
    BuildContext context, {
    required String title,
    required String categoryLabel,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 25 : 6),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Soft Pastel Icon Container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withAlpha(isDark ? 35 : 15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color.withAlpha(30),
                      width: 1.0,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        categoryLabel,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Small Right Chevron in Slate Gray
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// DETAIL SCREEN 1: AMBULANS & SIAGA BRO PSC 119 (FULL 1 LAYAR PENUH)
// =============================================================================
class AmbulansDetailScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const AmbulansDetailScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFDC2626),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Layanan Ambulans Darurat',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text(
              'SIAGA BRO PSC 119 Bojonegoro • 24 Jam',
              style: TextStyle(color: Color(0xFFFCA5A5), fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amber : Colors.white,
            ),
            onPressed: onToggleDarkMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFFECACA),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDC2626).withAlpha(isDark ? 40 : 25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Subtitle Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626).withAlpha(25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.airport_shuttle_rounded, color: Color(0xFFDC2626), size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SIAGA BRO PSC 119 Bojonegoro',
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                fontSize: 17.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'LAYANAN KEGAWATDARURATAN MEDIS 24 JAM (GRATIS)',
                              style: TextStyle(
                                color: Color(0xFFDC2626),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // TOMBOL 1: TOMBOL EMERGENCY CALL TELEPON
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 3,
                    ),
                    icon: const Icon(Icons.call_rounded, size: 22),
                    label: const Text(
                      'Emergency Call: 081132277119',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    onPressed: () {
                      _makeCall(context, '081132277119', 'SIAGA BRO PSC 119 Bojonegoro');
                    },
                  ),
                  const SizedBox(height: 12),

                  // TOMBOL 2: TOMBOL LINK APLIKASI PLAY STORE
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                      side: BorderSide(
                        color: isDark ? const Color(0xFF475569) : const Color(0xFFDC2626),
                        width: 1.5,
                      ),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.shop_two_rounded, size: 20, color: Color(0xFFDC2626)),
                    label: Text(
                      'Buka Aplikasi Emergency Button (Play Store)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    onPressed: () {
                      _launchPlayStoreUrl(context, 'https://play.google.com/store/apps/details?id=id.psc_119.bojonegoro.eb&hl=id');
                    },
                  ),
                  const SizedBox(height: 20),

                  // Kondisi Box Notice (Fixed Text Overflow with Expanded)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFFCA5A5),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Segera Hubungi SIAGA BRO PSC 119 Jika Mengalami/Melihat:',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: isDark ? Colors.white : const Color(0xFF991B1B),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildConditionItem('🚦', 'Korban Kecelakaan Lalu-Lintas', isDark),
                        _buildConditionItem('🔥', 'Korban Kebakaran', isDark),
                        _buildConditionItem('🏥', 'Kegawatdaruratan Medis di Rumah, Tempat Kerja & Tempat Umum', isDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionItem(String emoji, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF7F1D1D),
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DETAIL SCREEN 2: PEMADAM KEBAKARAN (DAMKAR) (FULL 1 LAYAR PENUH)
// =============================================================================
class DamkarDetailScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const DamkarDetailScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFEA580C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pemadam Kebakaran (Damkar)',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text(
              'Dinas Pemadam Kebakaran & Penyelamatan • Siaga 24 Jam',
              style: TextStyle(color: Color(0xFFFFEDD5), fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amber : Colors.white,
            ),
            onPressed: onToggleDarkMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFFED7AA),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEA580C).withAlpha(isDark ? 40 : 25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEA580C).withAlpha(25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFEA580C), size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pemadam Kebakaran (Damkar)',
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                fontSize: 17.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Dinas Pemadam Kebakaran & Penyelamatan Bojonegoro',
                              style: TextStyle(
                                color: Color(0xFFEA580C),
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  Text(
                    'Pilih Posko Damkar Terdekat untuk Panggilan Darurat:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildDirectPhoneCard(
                    context,
                    title: 'Call Center Damkar 113',
                    subtitle: 'Telepon: (0353) 113 • Bebas Pulsa (24 Jam)',
                    icon: Icons.phone_in_talk_rounded,
                    color: const Color(0xFFDC2626),
                    phone: '(0353) 113',
                  ),
                  _buildDirectPhoneCard(
                    context,
                    title: 'Pos Damkar Kota Bojonegoro',
                    subtitle: 'Telepon: 0823-3066-8443 • Posko Utama Kota',
                    icon: Icons.fire_truck_rounded,
                    color: const Color(0xFFEA580C),
                    phone: '0823-3066-8443',
                  ),
                  _buildDirectPhoneCard(
                    context,
                    title: 'Pos Damkar Padangan',
                    subtitle: 'Telepon: 0811-3471-448 • Posko Wilayah Barat',
                    icon: Icons.fort_rounded,
                    color: const Color(0xFFD97706),
                    phone: '0811-3471-448',
                  ),
                  _buildDirectPhoneCard(
                    context,
                    title: 'Pos Damkar Baureno',
                    subtitle: 'Telepon: 0811-3471-446 • Posko Wilayah Timur',
                    icon: Icons.shield_rounded,
                    color: const Color(0xFFC05621),
                    phone: '0811-3471-446',
                  ),
                  _buildDirectPhoneCard(
                    context,
                    title: 'Pos Damkar Sumberrejo',
                    subtitle: 'Telepon: 0823-4943-0066 • Posko Sumberrejo',
                    icon: Icons.local_fire_department_rounded,
                    color: const Color(0xFFEA580C),
                    phone: '0823-4943-0066',
                  ),
                  _buildDirectPhoneCard(
                    context,
                    title: 'Pos Damkar Ngasem',
                    subtitle: 'Telepon: 0823-4943-0055 • Posko Ngasem',
                    icon: Icons.local_fire_department_rounded,
                    color: const Color(0xFFD97706),
                    phone: '0823-4943-0055',
                  ),
                  _buildDirectPhoneCard(
                    context,
                    title: 'Pos Damkar Ngambon',
                    subtitle: 'Telepon: 0811-3487-039 • Posko Ngambon',
                    icon: Icons.local_fire_department_rounded,
                    color: const Color(0xFFC05621),
                    phone: '0811-3487-039',
                  ),
                  _buildDirectPhoneCard(
                    context,
                    title: 'Pos Damkar Sekar',
                    subtitle: 'Telepon: 0811-3487-038 • Posko Sekar',
                    icon: Icons.local_fire_department_rounded,
                    color: const Color(0xFFEA580C),
                    phone: '0811-3487-038',
                  ),
                  _buildDirectPhoneCard(
                    context,
                    title: 'Pos Damkar Temayang',
                    subtitle: 'Telepon: 0811-3471-447 • Posko Temayang',
                    icon: Icons.local_fire_department_rounded,
                    color: const Color(0xFFD97706),
                    phone: '0811-3471-447',
                  ),
                  _buildDirectPhoneCard(
                    context,
                    title: 'Pos Damkar Kedungadem',
                    subtitle: 'Telepon: 0811-3487-037 • Posko Kedungadem',
                    icon: Icons.local_fire_department_rounded,
                    color: const Color(0xFFC05621),
                    phone: '0811-3487-037',
                  ),
                  _buildDirectPhoneCard(
                    context,
                    title: 'Pos Damkar Ngraho',
                    subtitle: 'Telepon: 0821-3121-9971 • Posko Ngraho',
                    icon: Icons.local_fire_department_rounded,
                    color: const Color(0xFFEA580C),
                    phone: '0821-3121-9971',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// DETAIL SCREEN 3: KEPOLISIAN (POLRES & POLSEK) (FULL 1 LAYAR PENUH)
// =============================================================================
class KepolisianDetailScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const KepolisianDetailScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF1E40AF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kepolisian Bojonegoro',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text(
              'Sentra Pelayanan Kepolisian Terpadu (SPKT) • Siaga 24 Jam',
              style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amber : Colors.white,
            ),
            onPressed: onToggleDarkMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E40AF).withAlpha(isDark ? 40 : 25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E40AF).withAlpha(25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.local_police_rounded, color: Color(0xFF1E40AF), size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kepolisian (Polres Bojonegoro)',
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                fontSize: 17.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Sentra Pelayanan Kepolisian Terpadu (SPKT) Presisi',
                              style: TextStyle(
                                color: Color(0xFF1E40AF),
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  Text(
                    'Pilih Layanan Kepolisian untuk Panggilan Darurat:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildDirectPhoneCard(
                    context,
                    title: 'Call Center Kepolisian 110',
                    subtitle: 'Layanan Call Center 110 Polri Bebas Pulsa (24 Jam)',
                    icon: Icons.phone_in_talk_rounded,
                    color: const Color(0xFF1E40AF),
                    phone: '110',
                  ),
                  _buildDirectPhoneCard(
                    context,
                    title: 'SPKT Polres Bojonegoro',
                    subtitle: 'Telepon: (0353) 884300 • Pengaduan & Laporan Kriminal',
                    icon: Icons.shield_rounded,
                    color: const Color(0xFF2563EB),
                    phone: '(0353) 884300',
                  ),
                  const SizedBox(height: 14),

                  // Alamat Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E40AF).withAlpha(25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.location_on_rounded, color: Color(0xFF1E40AF), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alamat Markas Polres Bojonegoro',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Jalan MH. Thamrin No. 46, Kec. Bojonegoro, Kab. Bojonegoro, Jawa Timur 62113',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  height: 1.35,
                                ),
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Widget helper for Direct Phone Call List Items
Widget _buildDirectPhoneCard(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData icon,
  required Color color,
  required String phone,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
      ),
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        onTap: () {
          _makeCall(context, phone, title);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11.5,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        trailing: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          icon: const Icon(Icons.call_rounded, color: Colors.white, size: 14),
          label: Text(
            phone,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            _makeCall(context, phone, title);
          },
        ),
      ),
    ),
  );
}
