import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'simpatdu_image_data.dart';
import 'bphtb_image_data.dart';
import 'epayment_image_data.dart';
import 'wizztara_image_data.dart';
import 'cek_bayar_image_data.dart';
import 'dijamin_minul_image_data.dart';
import 'smart_report_image_data.dart';
import 'epbb_image_data.dart';

class PajakItem {
  final String id;
  final String title;
  final String subtitle;
  final String categoryTag;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;
  final String webUrl;
  final String? whatsappNumber;
  final String fullDescription;
  final List<String> features;
  final String badgeText;

  const PajakItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryTag,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    required this.webUrl,
    this.whatsappNumber,
    required this.fullDescription,
    required this.features,
    required this.badgeText,
  });
}

class PajakScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const PajakScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<PajakScreen> createState() => _PajakScreenState();
}

class _PajakScreenState extends State<PajakScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  final List<String> _filters = [
    'Semua',
    'PBB & BPHTB',
    'Sembilan Pajak',
    'E-Payment',
    'Digitalisasi',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper URL launcher with Windows fallback
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
        SnackBar(content: Text('Membuka portal $urlStr...')),
      );
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    var cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '62${cleanPhone.substring(1)}';
    }
    final Uri waUrl = Uri.parse('https://wa.me/$cleanPhone');
    try {
      if (await canLaunchUrl(waUrl)) {
        await launchUrl(waUrl, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', waUrl.toString()]);
        return;
      } catch (_) {}
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membuka WhatsApp $phone...')),
      );
    }
  }

  List<PajakItem> _getPajakItems() {
    return const [
      PajakItem(
        id: 'simpatdu',
        title: 'SIMPATDU',
        subtitle: 'Sistem Informasi Sembilan Pajak Lainnya',
        categoryTag: 'Sembilan Pajak',
        primaryColor: Color(0xFF10B981), // Green
        secondaryColor: Color(0xFF059669),
        icon: Icons.receipt_long_rounded,
        webUrl: 'https://pajakonlinebojonegorokab.id/',
        badgeText: 'Pajak Daerah',
        fullDescription:
            'SIMPATDU (Sistem Informasi Sembilan Pajak Lainnya) diakses via portal resmi pajakonlinebojonegorokab.id. Meliputi pelayanan pelaporan dan pembayaran 9 Pajak Daerah: Pajak Hotel, Restoran, Hiburan, Reklame, Penerangan Jalan, Parkir, Air Tanah, MBLB, serta Burung Walet di Kabupaten Bojonegoro.',
        features: [
          'Pelaporan Pajak Daerah Online via pajakonlinebojonegorokab.id',
          'Perhitungan Tarif & Tagihan Pajak Otomatis',
          'Penerbitan Surat Pemberitahuan Pajak Daerah (SPTPD)',
          'Monitoring Riwayat & Verifikasi Setoran Pajak Daerah',
        ],
      ),
      PajakItem(
        id: 'bphtb',
        title: 'BPHTB',
        subtitle: 'Sistem Informasi Pajak BPHTB',
        categoryTag: 'PBB & BPHTB',
        primaryColor: Color(0xFF0284C7), // Blue
        secondaryColor: Color(0xFF0369A1),
        icon: Icons.domain_rounded,
        webUrl: 'https://pajakonlinebojonegorokab.id/ebphtb/',
        badgeText: 'Pajak Transaksi Tanah',
        fullDescription:
            'Sistem Informasi Pajak Bea Perolehan Hak atas Tanah dan Bangunan (BPHTB) Kabupaten Bojonegoro. Memudahkan PPAT, Notaris, dan masyarakat dalam proses validasi, verifikasi, dan pembayaran BPHTB secara transparan & akuntabel.',
        features: [
          'E-Validasi BPHTB Online',
          'Pengecekan NOP & NJOP PBB',
          'Integrasi dengan BPN & Notaris/PPAT',
          'Cetak Kode Bayar & Bukti Setor Resmi',
        ],
      ),
      PajakItem(
        id: 'epayment',
        title: 'E-Payment',
        subtitle: 'Pembayaran Online Dengan QRIS',
        categoryTag: 'E-Payment',
        primaryColor: Color(0xFF8B5CF6), // Purple
        secondaryColor: Color(0xFF7C3AED),
        icon: Icons.qr_code_scanner_rounded,
        webUrl: 'https://pajakonlinebojonegorokab.id/epayment/',
        badgeText: 'QRIS & Multi-Payment',
        fullDescription:
            'Kanal e-Payment resmi BAPENDA Bojonegoro untuk kemudahan pembayaran pajak daerah menggunakan QRIS (Semua E-Wallet & Mobile Banking), Transfer Bank, serta Payment Gateway Nasional secara instan.',
        features: [
          'Pembayaran Instan via QRIS Nasional',
          'Dukungan Semua Bank & E-Wallet (Gopay, OVO, Dana, ShopeePay)',
          'Verifikasi Lunas Real-Time',
          'Bebas Antre & Dapat Diakses 24/7',
        ],
      ),
      PajakItem(
        id: 'wizztara',
        title: 'Wizztara',
        subtitle:
            'Whatsapp Instant Zone & Taxpayer Assistant, Layanan Dalam Genggaman',
        categoryTag: 'Digitalisasi',
        primaryColor: Color(0xFFF97316), // Orange
        secondaryColor: Color(0xFFEA580C),
        icon: Icons.chat_rounded,
        webUrl: 'https://pajakonlinebojonegorokab.id/callcenter.php',
        whatsappNumber: '085172330531',
        badgeText: 'Asisten WA Instant',
        fullDescription:
            'Wizztara (Whatsapp Instant Zone & Taxpayer Assistant) adalah inovasi asisten virtual berbasis WhatsApp resmi BAPENDA Bojonegoro. Memberikan layanan konsultasi, cek tagihan, info syarat pajak, dan panduan pembayaran langsung dari genggaman.',
        features: [
          'Chatbot Asisten Pajak Siaga 24 Jam',
          'Cek Tagihan PBB & Pajak Daerah via WA',
          'Konsultasi Petugas Pelayanan BAPENDA',
          'Notifikasi Pengingat Jatuh Tempo Pajak',
        ],
      ),
      PajakItem(
        id: 'cek_pembayaran',
        title: 'CEK PEMBAYARAN',
        subtitle: 'Cek Pembayaran Pajak Anda',
        categoryTag: 'E-Payment',
        primaryColor: Color(0xFF22C55E), // Emerald Green
        secondaryColor: Color(0xFF16A34A),
        icon: Icons.fact_check_rounded,
        webUrl: 'https://pajakonlinebojonegorokab.id/cek-bayar/ceksaja.php',
        badgeText: 'Status & Bukti Bayar',
        fullDescription:
            'Fasilitas pencarian dan verifikasi status pembayaran pajak daerah Bojonegoro. Masukkan Nomor Objek Pajak (NOP) atau Kode Transaksi untuk memastikan setoran pajak Anda sudah tercatat resmi di sistem BAPENDA.',
        features: [
          'Pencarian Status Bayar Berdasarkan NOP / NPWPD',
          'Unduh Bukti Penerimaan Negara / Daerah',
          'Riwayat Pembayaran Pajak Terdahulu',
          'Validasi Keabsahan Resi Pembayaran',
        ],
      ),
      PajakItem(
        id: 'dijamin_minul',
        title: 'DIJAMIN MINUL',
        subtitle: 'Digitalisasi Pajak Mamin & MBLB',
        categoryTag: 'Digitalisasi',
        primaryColor: Color(0xFF9333EA), // Deep Purple
        secondaryColor: Color(0xFF7E22CE),
        icon: Icons.restaurant_rounded,
        webUrl: 'https://pajakonlinebojonegorokab.id/eSPTPDbjn/',
        badgeText: 'Mamin & MBLB Online',
        fullDescription:
            'DIJAMIN MINUL (Digitalisasi Pajak Makanan Minuman & Mineral Bukan Logam dan Batuan) adalah program prioritas BAPENDA Bojonegoro untuk transparansi, kemudahan pelaporan, dan optimalisasi omzet usaha kuliner & tambang MBLB.',
        features: [
          'Pelaporan Omzet Usaha Makanan & Minuman',
          'Pendataan Pajak MBLB Terintegrasi',
          'Monitoring Tapping Box / POS Restoran',
          'Skema Insentif & Kemudahan Pelaporan Usaha',
        ],
      ),
      PajakItem(
        id: 'smart_report',
        title: 'SMART REPORT',
        subtitle: 'Kumpulan Berbagai laporan Pendapatan Pajak',
        categoryTag: 'Digitalisasi',
        primaryColor: Color(0xFF6366F1), // Indigo
        secondaryColor: Color(0xFF4F46E5),
        icon: Icons.analytics_rounded,
        webUrl: 'https://pajakonlinebojonegorokab.id/smartreport/',
        badgeText: 'Dashboard Pendapatan',
        fullDescription:
            'Portal Smart Report menyajikan transparansi data rekapitulasi, grafik realisasi target pendapatan pajak daerah, serta analisis statistik penerimaan pajak Kabupaten Bojonegoro secara berkala.',
        features: [
          'Dashboard Realisasi Target Pajak Daerah',
          'Grafik Penerimaan Per Sektor Pajak',
          'Laporan Statistik Bulanan & Tahunan',
          'Keterbukaan Informasi Publik BAPENDA',
        ],
      ),
      PajakItem(
        id: 'epbb',
        title: 'e-PBB',
        subtitle: 'Cek Pembayaran dan Pelayanan PBB-P2',
        categoryTag: 'PBB & BPHTB',
        primaryColor: Color(0xFF0D9488), // Teal
        secondaryColor: Color(0xFF0F766E),
        icon: Icons.house_rounded,
        webUrl: 'https://pajakonlinebojonegorokab.id/wpbb/',
        badgeText: 'Pajak Bumi & Bangunan',
        fullDescription:
            'Portal e-PBB merupakan sarana pelayanan Pajak Bumi dan Bangunan Perdesaan dan Perkotaan (PBB-P2) Kabupaten Bojonegoro. Digunakan untuk cetak e-SPPT, cek tagihan PBB, mutasi NOP, dan permohonan pembetulan data PBB.',
        features: [
          'Cek Tagihan & Tunggakan PBB-P2',
          'Unduh e-SPPT PBB Digital Resmi',
          'Pengajuan Mutasi & Pemecahan NOP',
          'Informasi Tempat Pembayaran PBB Terdekat',
        ],
      ),
    ];
  }

  List<PajakItem> get _filteredItems {
    final all = _getPajakItems();
    return all.where((item) {
      final matchesQuery = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.categoryTag.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesFilter = _selectedFilter == 'Semua' ||
          item.categoryTag.toLowerCase().contains(_selectedFilter.toLowerCase()) ||
          (_selectedFilter == 'E-Payment' && item.categoryTag == 'E-Payment') ||
          (_selectedFilter == 'PBB & BPHTB' && item.categoryTag == 'PBB & BPHTB') ||
          (_selectedFilter == 'Sembilan Pajak' && item.categoryTag == 'Sembilan Pajak') ||
          (_selectedFilter == 'Digitalisasi' && item.categoryTag == 'Digitalisasi');

      return matchesQuery && matchesFilter;
    }).toList();
  }

  // ignore: unused_element
  void _showDetailModal(PajakItem item) {
    final isDark = widget.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal Header with Close Button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [item.primaryColor, item.secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: item.primaryColor.withAlpha(50),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(item.icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: item.primaryColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.badgeText,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: item.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.cancel_rounded,
                      color: isDark ? Colors.white54 : Colors.black45,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              const SizedBox(height: 12),

              // Description Title & Text
              Text(
                'Deskripsi Layanan',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.fullDescription,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 16),

              // Features List
              Text(
                'Fitur & Fasilitas Utama',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: item.features.map((feat) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: item.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feat,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              if (item.whatsappNumber != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _openWhatsApp(item.whatsappNumber!);
                    },
                    icon: const Icon(Icons.chat_rounded, size: 18),
                    label: const Text(
                      'Hubungi WhatsApp Assistant Wizztara',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _openWebUrl(item.webUrl);
                  },
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: Text(
                    'Buka Portal ${item.title} Official',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final filtered = _filteredItems;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pajak & Retribusi Daerah',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
            Text(
              'BAPENDA Kab. Bojonegoro',
              style: TextStyle(
                fontSize: 12, 
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          if (widget.onToggleDarkMode != null)
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                color: Colors.white,
                onPressed: widget.onToggleDarkMode,
                tooltip: 'Ganti Tema',
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern Header Background (Compact header bar)
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top + kToolbarHeight + 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                          : [const Color(0xFF0D62F1), const Color(0xFF0A47B8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D62F1).withAlpha(isDark ? 20 : 35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
                // Decorative Circle in Header
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(isDark ? 5 : 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Card BADAN PENDAPATAN DAERAH (Outside Header - Modern Transparent Gradient)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF1E293B).withAlpha(210),
                            const Color(0xFF0F172A).withAlpha(190),
                          ]
                        : [
                            Colors.white.withAlpha(210),
                            const Color(0xFFE0F2FE).withAlpha(170),
                            const Color(0xFFDBEAFE).withAlpha(150),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withAlpha(25)
                        : const Color(0xFF0D62F1).withAlpha(40),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D62F1).withAlpha(isDark ? 20 : 25),
                      blurRadius: 20,
                      spreadRadius: -2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          // Modern Crisp Icon Box (Clean & Minimalist Squircle)
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)]
                                    : [const Color(0xFF0D62F1), const Color(0xFF1D4ED8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0D62F1).withAlpha(isDark ? 30 : 45),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.account_balance_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BADAN PENDAPATAN DAERAH',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      size: 13,
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF0D62F1),
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        'Jl. Teuku Umar No. 12, Bojonegoro',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () => _openWebUrl('https://pajakonlinebojonegorokab.id/'),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isDark
                                            ? [
                                                const Color(0xFF3B82F6).withAlpha(40),
                                                const Color(0xFF1D4ED8).withAlpha(30),
                                              ]
                                            : [
                                                const Color(0xFF0D62F1).withAlpha(20),
                                                const Color(0xFF3B82F6).withAlpha(15),
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: (isDark ? Colors.white : const Color(0xFF0D62F1)).withAlpha(35),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.language_rounded,
                                          color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF0D62F1),
                                          size: 13,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'pajakonlinebojonegorokab.id',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF0D62F1),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_outward_rounded,
                                          color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF0D62F1),
                                          size: 11,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Rest of Body content (Search, Filters, Grid)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            const SizedBox(height: 16),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 30 : 10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: 'Cari layanan pajak (SIMPATDU, BPHTB, PBB, Wizztara...)...',
                  hintStyle: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(Icons.search_rounded,
                      size: 20, color: Color(0xFF0D62F1)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Horizontal Filter Chips with Mouse/Touch ScrollConfiguration
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: Row(
                  children: _filters.map((f) {
                    final isSel = _selectedFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        selected: isSel,
                        label: Text(f),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          color: isSel
                              ? Colors.white
                              : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                        ),
                        selectedColor: const Color(0xFF0D62F1),
                        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: isSel
                                ? const Color(0xFF0D62F1)
                                : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                            width: 1.2,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedFilter = f);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title & Count Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PILIKAN LAYANAN PAJAK DAERAH',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D62F1).withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${filtered.length} Layanan',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D62F1),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Grid of 8 Pajak Cards (Matching Screenshot Layout)
            if (filtered.isEmpty) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 50,
                        color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Layanan pajak tidak ditemukan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Coba kata kunci pencarian atau filter yang lain.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 650 ? 2 : 1;
                  final itemWidth =
                      (constraints.maxWidth - ((crossAxisCount - 1) * 14)) / crossAxisCount;

                  return Wrap(
                    spacing: 14,
                    runSpacing: 16,
                    children: filtered.map((item) {
                      return SizedBox(
                        width: itemWidth,
                        child: _buildPajakCard(item, isDark),
                      );
                    }).toList(),
                  );
                },
              ),
            ],

            const SizedBox(height: 20),

            // Official Pajak Online Banner Box
            InkWell(
              onTap: () => _openWebUrl('https://pajakonlinebojonegorokab.id/'),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E3A8A).withAlpha(160), const Color(0xFF1E293B)]
                        : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF0D62F1).withAlpha(90),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D62F1).withAlpha(25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D62F1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.public_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INFO SELENGKAPNYA PAJAK ONLINE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Kunjungi portal resmi Pajak Online Kab. Bojonegoro:',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'pajakonlinebojonegorokab.id ↗️',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0D62F1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D62F1).withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_rounded,
                          color: Color(0xFF0D62F1), size: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPajakCard(PajakItem item, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 60 : 20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openWebUrl(item.webUrl),
            child: SizedBox(
              height: 200,
              child: Column(
                children: [
                  // Top Image Graphic Area
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: item.id == 'bphtb'
                          ? const Color(0xFF8ED6F5)
                          : (item.id == 'simpatdu'
                              ? const Color(0xFF4CAF50)
                              : item.primaryColor.withAlpha(40)),
                      child: _buildCardGraphicBanner(item, isDark),
                    ),
                  ),

                  // Bottom Colored Banner Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: item.primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(40),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Square Action Button [ ↗ ]
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withAlpha(70)),
                          ),
                          child: const Icon(
                            Icons.north_east_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardGraphicBanner(PajakItem item, bool isDark) {
    if (item.id == 'simpatdu') {
      return Image.memory(
        simpatduImageBytes,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/simpatdu_banner.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF82C46C), Color(0xFF4CAF50), Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      );
    }

    if (item.id == 'bphtb') {
      return Image.memory(
        bphtbImageBytes,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/BPHTB.jpg',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7DD3FC), Color(0xFF0284C7), Color(0xFF0369A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      );
    }

    if (item.id == 'epayment') {
      return Image.memory(
        epaymentImageBytes,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/epayment.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E1B4B), Color(0xFF4338CA), Color(0xFF6D28D9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      );
    }

    if (item.id == 'wizztara') {
      return Image.memory(
        wizztaraImageBytes,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/Wizztara.jpeg',
          fit: BoxFit.cover,
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF7ED), Color(0xFFFED7AA), Color(0xFFF97316)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      );
    }

    if (item.id == 'cek_pembayaran') {
      return Image.memory(
        cekBayarImageBytes,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/cek bayar.jpg',
          fit: BoxFit.cover,
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFEF3C7), Color(0xFFF59E0B), Color(0xFFD97706)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      );
    }

    if (item.id == 'dijamin_minul') {
      return Image.memory(
        dijaminMinulImageBytes,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/dijamin minul.jpg',
          fit: BoxFit.cover,
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFAF5FF), Color(0xFFE9D5FF), Color(0xFF9333EA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      );
    }

    if (item.id == 'smart_report') {
      return Image.memory(
        smartReportImageBytes,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/Report-online.jpg',
          fit: BoxFit.cover,
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0F2FE), Color(0xFF818CF8), Color(0xFF4F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      );
    }

    // Default: e-PBB
    return Image.memory(
      epbbImageBytes,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/E-pbb.jpg',
        fit: BoxFit.cover,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFCCFBF1), Color(0xFF0D9488), Color(0xFF0F766E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}
