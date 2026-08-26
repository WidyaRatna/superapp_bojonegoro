import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../widgets/superapp_header.dart';
import 'package:url_launcher/url_launcher.dart';

class LayananPengaduanDpmptspScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const LayananPengaduanDpmptspScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<LayananPengaduanDpmptspScreen> createState() => _LayananPengaduanDpmptspScreenState();
}

class _LayananPengaduanDpmptspScreenState extends State<LayananPengaduanDpmptspScreen> {

  // URL Launching Helpers
  Future<void> _makePhoneCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanPhone.isEmpty) return;
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

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menghubungi $phone...')),
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

  Future<void> _openEmail(String email) async {
    final Uri mailUrl = Uri.parse('mailto:$email');
    try {
      if (await canLaunchUrl(mailUrl)) {
        await launchUrl(mailUrl);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', 'mailto:$email']);
        return;
      } catch (_) {}
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membuka Email $email...')),
      );
    }
  }

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
        SnackBar(content: Text('Membuka website $urlStr...')),
      );
    }
  }

  List<_KanalOption> _getKanalOptions() {
    const primaryColor = Color(0xFF0D62F1);
    return [
      _KanalOption(
        icon: Icons.language_rounded,
        iconBgColor: primaryColor,
        title: 'Website SP4N-LAPOR!',
        subtitle: 'Lapor keluhan publik secara resmi nasional via portal lapor.go.id.',
        buttonText: 'Buka Portal SP4N-LAPOR!',
        onTap: () => _openWebUrl('https://www.lapor.go.id/'),
        tag: 'ONLINE NASIONAL',
        badgeText: 'Kanal #1',
      ),
      _KanalOption(
        icon: Icons.public_rounded,
        iconBgColor: primaryColor,
        title: 'Website Buku Tamu DPMPTSP',
        subtitle: 'Akses portal pengaduan langsung DPMPTSP Kabupaten Bojonegoro.',
        buttonText: 'Kunjungi Website DPMPTSP',
        onTap: () => _openWebUrl('https://dpmptsp.bojonegorokab.go.id/bukutamu/add'),
        tag: 'PORTAL RESMI',
        badgeText: 'Kanal #2',
      ),
      _KanalOption(
        icon: Icons.chat_rounded,
        iconBgColor: primaryColor,
        title: 'Hotline WhatsApp Pengaduan',
        subtitle: 'Hubungi petugas siaga pengaduan ke +62 822 3309 9988.',
        buttonText: 'Chat WhatsApp Petugas',
        onTap: () => _openWhatsApp('082233099988'),
        tag: 'RESPON CEPAT',
        badgeText: 'Kanal #3',
      ),
      _KanalOption(
        icon: Icons.email_rounded,
        iconBgColor: primaryColor,
        title: 'Email Pengaduan Resmi',
        subtitle: 'Kirim dokumen & berkas keluhan ke dpmptsp.kabbjn@gmail.com.',
        buttonText: 'Kirim Surat Email',
        onTap: () => _openEmail('dpmptsp.kabbjn@gmail.com'),
        tag: 'DOKUMEN RESMI',
        badgeText: 'Kanal #4',
      ),
      _KanalOption(
        icon: Icons.location_on_rounded,
        iconBgColor: primaryColor,
        title: 'Media Langsung / Tatap Muka',
        subtitle: 'Datang langsung ke kantor DPMPTSP (MPP Jl. Veteran No. 227).',
        buttonText: 'Petunjuk Lokasi Google Maps',
        onTap: () => _openWebUrl('https://maps.google.com/?q=DPMPTSP+Kabupaten+Bojonegoro+Jl+Veteran+No+227'),
        tag: 'KANTOR MPP',
        badgeText: 'Kanal #5',
      ),
      _KanalOption(
        icon: Icons.mark_unread_chat_alt_rounded,
        iconBgColor: primaryColor,
        title: 'Kotak Pengaduan / Surat',
        subtitle: 'Kirim surat resmi ke Mal Pelayanan Publik (MPP) Lt. 1 & 2.',
        buttonText: 'Hubungi Telepon MPP',
        onTap: () => _makePhoneCall('03535256661'),
        tag: 'SURAT FISIK',
        badgeText: 'Kanal #6',
      ),
      _KanalOption(
        icon: Icons.camera_alt_rounded,
        iconBgColor: primaryColor,
        title: 'Instagram Resmi DPMPTSP',
        subtitle: 'Pengaduan & informasi layanan melalui DM Instagram DPMPTSP.',
        buttonText: 'Kunjungi Instagram DPMPTSP',
        onTap: () => _openWebUrl('https://www.instagram.com/dpmptspbojonegoro/'),
        tag: 'MEDIA SOSIAL',
        badgeText: 'Kanal #7',
      ),
      _KanalOption(
        icon: Icons.alternate_email_rounded,
        iconBgColor: primaryColor,
        title: 'Twitter / X DPMPTSP',
        subtitle: 'Pengaduan & masukan publik melalui akun Twitter/X resmi.',
        buttonText: 'Kunjungi Twitter / X',
        onTap: () => _openWebUrl('https://twitter.com/dpmptspbjn'),
        tag: 'MEDIA SOSIAL',
        badgeText: 'Kanal #8',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
    final channels = _getKanalOptions();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Layanan Pengaduan DPMPTSP',
            subtitle: 'Kabupaten Bojonegoro',
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
                  // SECTION 1: Jadwal & SOP
                  Text(
                    'Jadwal & SOP Pengaduan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Informasi operasional & alur mekanisme pelayanan pengaduan:',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Jadwal Tatap Muka (Information Bar)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_rounded, color: Color(0xFF0D62F1), size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Jadwal Tatap Muka: Senin - Jumat (08.00 - 15.00 WIB)',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Alur Mekanisme & SOP (Menu Card with Kependudukan Style)
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0D62F1).withAlpha(isDark ? 30 : 12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SopPengaduanDpmptspScreen(isDarkMode: isDark),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D62F1).withAlpha(isDark ? 40 : 18),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF0D62F1).withAlpha(30), width: 1),
                                ),
                                child: const Icon(Icons.account_tree_rounded, color: Color(0xFF0D62F1), size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0D62F1).withAlpha(isDark ? 35 : 15),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: const Color(0xFF0D62F1).withAlpha(30), width: 1),
                                      ),
                                      child: const Text(
                                        'STANDAR OPERASIONAL',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0D62F1),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Alur Mekanisme & SOP Pengaduan',
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Lihat bagan alur & prosedur resmi penanganan keluhan',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0D62F1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // SECTION 2: PILIH KANAL PENGADUAN
                  Text(
                    'Pilih Kanal Pengaduan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Silakan pilih 8 metode pengaduan publik DPMPTSP di bawah ini:',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 8 Compact Service Cards following Kependudukan pattern
                  for (int i = 0; i < channels.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildKanalCard(
                        option: channels[i],
                        isDark: isDark,
                      ),
                    ),
                  ],

                  const SizedBox(height: 10),

                  // SECTION 3: INFORMASI & KETENTUAN
                  _buildInformasiKetentuanBox(isDark),

                  const SizedBox(height: 12),

                  // Commitment Banner
                  _buildCommitmentBanner(isDark),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Compact Kependudukan-Style Service Card
  Widget _buildKanalCard({
    required _KanalOption option,
    required bool isDark,
  }) {
    const primaryColor = Color(0xFF0D62F1);

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
            color: primaryColor.withAlpha(isDark ? 30 : 12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: option.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Icon Container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(isDark ? 40 : 18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryColor.withAlpha(30), width: 1),
                  ),
                  child: Icon(option.icon, color: primaryColor, size: 24),
                ),
                const SizedBox(width: 12),
                // Center Content Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge Label: Nomor & Kategori Kanal
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: primaryColor.withAlpha(isDark ? 35 : 15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: primaryColor.withAlpha(30), width: 1),
                        ),
                        child: Text(
                          '${option.badgeText} • ${option.tag}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Title
                      Text(
                        option.title,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Subtitle
                      Text(
                        option.subtitle,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Right Action: Circular Arrow Button
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Official Notice Box
  Widget _buildInformasiKetentuanBox(bool isDark) {
    const primaryColor = Color(0xFF0D62F1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withAlpha(isDark ? 30 : 12),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha(isDark ? 40 : 18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: primaryColor.withAlpha(30), width: 1),
                ),
                child: const Icon(Icons.info_outline_rounded, color: primaryColor, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                'Informasi & Ketentuan Pengaduan',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Melalui pengaduan ini, pengguna jasa dapat menyampaikan keluhan maupun komentar terhadap fasilitas gedung, pelayanan, pelanggaran kode etik, serta hal-hal yang terkait dengan pelaksanaan prosedur pelayanan di Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu Kabupaten Bojonegoro. Pengaduan ini disampaikan secara langsung atau melalui email dengan mengisi formulir pengaduan secara lengkap, agar petugas kami dapat menindaklanjuti pengaduan yang telah disampaikan. Apabila data yang disampaikan tidak benar, pengaduan tidak akan diproses lebih lanjut.',
            style: TextStyle(
              fontSize: 11.5,
              height: 1.45,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  // Commitment Motto Banner
  Widget _buildCommitmentBanner(bool isDark) {
    const primaryColor = Color(0xFF0D62F1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined, color: primaryColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Pengaduan Anda akan membantu kami meningkatkan kualitas pelayanan dan menegakkan integritas pegawai.',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E3A8A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KanalOption {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onTap;
  final String tag;
  final String badgeText;

  const _KanalOption({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onTap,
    required this.tag,
    required this.badgeText,
  });
}

class _SopStep {
  final String stepNumber;
  final String role;
  final String duration;
  final String output;
  final String description;

  const _SopStep({
    required this.stepNumber,
    required this.role,
    required this.duration,
    required this.output,
    required this.description,
  });
}

class SopPengaduanDpmptspScreen extends StatefulWidget {
  final bool isDarkMode;

  const SopPengaduanDpmptspScreen({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<SopPengaduanDpmptspScreen> createState() => _SopPengaduanDpmptspScreenState();
}

class _SopPengaduanDpmptspScreenState extends State<SopPengaduanDpmptspScreen>
    with SingleTickerProviderStateMixin {
  late TabController _sopTabController;

  @override
  void initState() {
    super.initState();
    _sopTabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _sopTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF0D62F1),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alur & SOP Pengaduan Resmi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'DPMPTSP Kabupaten Bojonegoro',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_tree_rounded, color: Color(0xFF10B981), size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STANDAR OPERASIONAL PROSEDUR (SOP)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Sesuaikan kanal lapor & ketuk nomer/kartu untuk pembesar teks',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // SOP Tab Header Hint Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PILIH KANAL ALUR PENGADUAN',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0D62F1),
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D62F1).withAlpha(15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swipe_rounded, color: Color(0xFF0D62F1), size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Geser Tab 👈 👉',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D62F1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Ultra Modern SOP Tab Switcher (8 Dragable Tabs: Tatap Muka, Surat, LAPOR, Website, Email, WhatsApp, Instagram, Twitter)
            Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 40 : 10),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.stylus,
                    },
                  ),
                  child: TabBar(
                    controller: _sopTabController,
                    isScrollable: true,
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: const Color(0xFF0D62F1),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0D62F1).withAlpha(50),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                    labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                    padding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 14),
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_alt_rounded, size: 14),
                            SizedBox(width: 6),
                            Text('Tatap Muka'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mark_as_unread_rounded, size: 14),
                            SizedBox(width: 6),
                            Text('Surat'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.campaign_rounded, size: 14),
                            SizedBox(width: 6),
                            Text('LAPOR'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.language_rounded, size: 14),
                            SizedBox(width: 6),
                            Text('Website'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mark_email_read_rounded, size: 14),
                            SizedBox(width: 6),
                            Text('Email'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chat_bubble_rounded, size: 14),
                            SizedBox(width: 6),
                            Text('WhatsApp'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt_rounded, size: 14),
                            SizedBox(width: 6),
                            Text('Instagram'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '𝕏',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                            ),
                            SizedBox(width: 6),
                            Text('Twitter'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // SOP Tab Content Box
            SizedBox(
              height: 1450,
              child: TabBarView(
                controller: _sopTabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildAlurTatapMukaTab(isDark),
                  _buildSopSuratTab(isDark),
                  _buildSopLaporTab(isDark),
                  _buildSopWebsiteTab(isDark),
                  _buildSopEmailTab(isDark),
                  _buildSopWhatsappTab(isDark),
                  _buildSopInstagramTab(isDark),
                  _buildSopTwitterTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 8 Official SOP Tab Views
  Widget _buildAlurTatapMukaTab(bool isDark) {
    return _buildSopContainer(
      isDark: isDark,
      title: 'SOP Penanganan Pengaduan Melalui Tatap Muka',
      steps: const [
        _SopStep(
          stepNumber: '1',
          role: 'Masyarakat',
          duration: '-',
          output: 'Pengaduan',
          description: 'Masyarakat membuat pengaduan melalui tatap muka',
        ),
        _SopStep(
          stepNumber: '2',
          role: 'Staf Pengaduan',
          duration: '15 Menit',
          output: 'Berkas Pengaduan Lengkap',
          description: 'Menerima dan mencatat pengaduan dari masyarakat yang didapat dari tatap muka',
        ),
        _SopStep(
          stepNumber: '3',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Pengaduan telah diterima',
          description: 'Pengaduan yang bukan kewenangan DPMPTSP. Menerima pengaduan yang diserahkan staf pengaduan kemudian meneruskan kepada OPD terkait apabila bukan kewenangan DPMPTSP untuk menjawab pengaduan. Selanjutnya OPD menindaklanjuti pengaduan langsung kepada masyarakat',
        ),
        _SopStep(
          stepNumber: '4',
          role: 'Penata Perizinan Ahli Muda',
          duration: '30 Menit',
          output: 'Berkas Pengaduan Lengkap dan konsep jawaban',
          description: 'Pengaduan kewenangan DPMPTSP. Menyusun berkas pengaduan, menganalisis serta memverifikasi berkas pengaduan untuk dijadikan konsep jawaban pengaduan',
        ),
        _SopStep(
          stepNumber: '5',
          role: 'Penata Perizinan Ahli Madya',
          duration: '15 Menit',
          output: 'konsep jawaban',
          description: 'Penata Perizinan Ahli Madya menerima dan memverifikasi rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '6',
          role: 'Kepala Dinas',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Kepala Dinas Menerima dan menyetujui rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '7',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Penata Perizinan Ahli Muda menerima persetujuan jawaban pengaduan kemudian menyampaikan jawaban kepada staf pengaduan untuk disampaikan kepada masyarakat',
        ),
      ],
    );
  }

  Widget _buildSopSuratTab(bool isDark) {
    return _buildSopContainer(
      isDark: isDark,
      title: 'SOP Penanganan Pengaduan Melalui Surat',
      steps: const [
        _SopStep(
          stepNumber: '1',
          role: 'Masyarakat',
          duration: '-',
          output: 'Pengaduan',
          description: 'Masyarakat membuat pengaduan melalui kotak pengaduan',
        ),
        _SopStep(
          stepNumber: '2',
          role: 'Staf Pengaduan',
          duration: '15 Menit',
          output: 'Berkas Pengaduan Lengkap',
          description: 'Menerima dan mencatat pengaduan dari masyarakat yang didapat dari kotak pengaduan',
        ),
        _SopStep(
          stepNumber: '3',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Pengaduan telah diterima',
          description: 'Pengaduan yang bukan kewenangan DPMPTSP. Menerima pengaduan yang diserahkan staf pengaduan kemudian meneruskan kepada OPD terkait apabila bukan kewenangan DPMPTSP untuk menjawab pengaduan. Selanjutnya OPD menindaklanjuti pengaduan langsung kepada masyarakat',
        ),
        _SopStep(
          stepNumber: '4',
          role: 'Penata Perizinan Ahli Muda',
          duration: '1 Hari',
          output: 'Berkas Pengaduan Lengkap dan konsep jawaban',
          description: 'Pengaduan kewenangan DPMPTSP. Menyusun berkas pengaduan, menganalisis serta memverifikasi berkas pengaduan untuk dijadikan konsep jawaban pengaduan',
        ),
        _SopStep(
          stepNumber: '5',
          role: 'Penata Perizinan Ahli Madya',
          duration: '15 Menit',
          output: 'konsep jawaban',
          description: 'Penata Perizinan Ahli Madya menerima dan memverifikasi rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '6',
          role: 'Kepala Dinas',
          duration: '1 Hari',
          output: 'Jawaban pengaduan',
          description: 'Kepala Dinas Menerima dan menyetujui rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '7',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Penata Perizinan Ahli Muda menerima persetujuan jawaban pengaduan kemudian menyampaikan jawaban kepada staf pengaduan untuk disampaikan kepada masyarakat',
        ),
      ],
    );
  }

  Widget _buildSopLaporTab(bool isDark) {
    return _buildSopContainer(
      isDark: isDark,
      title: 'SOP Penanganan Pengaduan Melalui LAPOR',
      steps: const [
        _SopStep(
          stepNumber: '1',
          role: 'Masyarakat',
          duration: '-',
          output: 'Pengaduan',
          description: 'Masyarakat membuat pengaduan melalui kanal Lapor',
        ),
        _SopStep(
          stepNumber: '2',
          role: 'Tim Adm Kab',
          duration: '15 Menit',
          output: 'Berkas Pengaduan Lengkap',
          description: 'Menerima dan mencatat pengaduan dari Tim Admin Kabupaten yang didapat dari kanal Lapor',
        ),
        _SopStep(
          stepNumber: '3',
          role: 'Penata Perizinan Ahli Muda',
          duration: '30 Menit',
          output: 'Berkas Pengaduan Lengkap dan konsep jawaban',
          description: 'Menyusun berkas pengaduan, menganalisis serta memverifikasi berkas pengaduan untuk dijadikan konsep jawaban pengaduan',
        ),
        _SopStep(
          stepNumber: '4',
          role: 'Penata Perizinan Ahli Madya',
          duration: '15 Menit',
          output: 'konsep jawaban',
          description: 'Penata Perizinan Ahli Madya menerima dan memverifikasi rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '5',
          role: 'Kepala Dinas',
          duration: '14 Hari',
          output: 'Jawaban pengaduan',
          description: 'Kepala Dinas Menerima dan menyetujui rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '6',
          role: 'Penata Perizinan Ahli Muda',
          duration: '30 Menit',
          output: 'Jawaban pengaduan',
          description: 'Penata Perizinan Ahli Muda menerima persetujuan jawaban pengaduan kemudian menyampaikan jawaban kepada staf pengaduan untuk disampaikan kepada Tim Admin Kabupaten untuk disampaikan kepada masyarakat',
        ),
        _SopStep(
          stepNumber: '7',
          role: 'Tim Adm Kab',
          duration: '-',
          output: 'Respon masyarakat terhadap Jawaban pengaduan',
          description: 'Direspon oleh Tim Admin Kabupaten dan tindak lanjut oleh masyarakat',
        ),
      ],
    );
  }

  Widget _buildSopWebsiteTab(bool isDark) {
    return _buildSopContainer(
      isDark: isDark,
      title: 'SOP Penanganan Pengaduan Melalui Website',
      steps: const [
        _SopStep(
          stepNumber: '1',
          role: 'Masyarakat',
          duration: '-',
          output: 'Pengaduan',
          description: 'Masyarakat membuat pengaduan melalui Website',
        ),
        _SopStep(
          stepNumber: '2',
          role: 'Staf Pengaduan',
          duration: '15 Menit',
          output: 'Berkas Pengaduan Lengkap',
          description: 'Menerima dan mencatat pengaduan dari masyarakat yang didapat dari kanal Website',
        ),
        _SopStep(
          stepNumber: '3',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Pengaduan telah diterima',
          description: 'Pengaduan yang bukan kewenangan DPMPTSP. Menerima pengaduan yang diserahkan staf pengaduan kemudian meneruskan kepada OPD terkait apabila bukan kewenangan DPMPTSP untuk menjawab pengaduan. Selanjutnya OPD menindaklanjuti pengaduan langsung kepada masyarakat',
        ),
        _SopStep(
          stepNumber: '4',
          role: 'Penata Perizinan Ahli Muda',
          duration: '30 Menit',
          output: 'Berkas Pengaduan Lengkap dan konsep jawaban',
          description: 'Pengaduan kewenangan DPMPTSP. Menyusun berkas pengaduan, menganalisis serta memverifikasi berkas pengaduan untuk dijadikan konsep jawaban pengaduan',
        ),
        _SopStep(
          stepNumber: '5',
          role: 'Penata Perizinan Ahli Madya',
          duration: '15 Menit',
          output: 'konsep jawaban',
          description: 'Penata Perizinan Ahli Madya menerima dan memverifikasi rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '6',
          role: 'Kepala Dinas',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Kepala Dinas Menerima dan menyetujui rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '7',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Penata Perizinan Ahli Muda menerima persetujuan jawaban pengaduan kemudian menyampaikan jawaban kepada staf pengaduan untuk disampaikan kepada masyarakat',
        ),
      ],
    );
  }

  Widget _buildSopEmailTab(bool isDark) {
    return _buildSopContainer(
      isDark: isDark,
      title: 'SOP Penanganan Pengaduan Melalui Email',
      steps: const [
        _SopStep(
          stepNumber: '1',
          role: 'Masyarakat',
          duration: '-',
          output: 'Pengaduan',
          description: 'Masyarakat membuat pengaduan melalui Email',
        ),
        _SopStep(
          stepNumber: '2',
          role: 'Staf Pengaduan',
          duration: '15 Menit',
          output: 'Berkas Pengaduan Lengkap',
          description: 'Menerima dan mencatat pengaduan dari masyarakat yang didapat dari kanal Email',
        ),
        _SopStep(
          stepNumber: '3',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Pengaduan telah diterima',
          description: 'Pengaduan yang bukan kewenangan DPMPTSP. Menerima pengaduan yang diserahkan staf pengaduan kemudian meneruskan kepada OPD terkait apabila bukan kewenangan DPMPTSP untuk menjawab pengaduan. Selanjutnya OPD menindaklanjuti pengaduan langsung kepada masyarakat',
        ),
        _SopStep(
          stepNumber: '4',
          role: 'Penata Perizinan Ahli Muda',
          duration: '30 Menit',
          output: 'Berkas Pengaduan Lengkap dan konsep jawaban',
          description: 'Pengaduan kewenangan DPMPTSP. Menyusun berkas pengaduan, menganalisis serta memverifikasi berkas pengaduan untuk dijadikan konsep jawaban pengaduan',
        ),
        _SopStep(
          stepNumber: '5',
          role: 'Penata Perizinan Ahli Madya',
          duration: '15 Menit',
          output: 'konsep jawaban',
          description: 'Penata Perizinan Ahli Madya menerima dan memverifikasi rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '6',
          role: 'Kepala Dinas',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Kepala Dinas Menerima dan menyetujui rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '7',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Penata Perizinan Ahli Muda menerima persetujuan jawaban pengaduan kemudian menyampaikan jawaban kepada staf pengaduan untuk disampaikan kepada masyarakat',
        ),
      ],
    );
  }

  Widget _buildSopWhatsappTab(bool isDark) {
    return _buildSopContainer(
      isDark: isDark,
      title: 'SOP Penanganan Pengaduan Melalui WhatsApp',
      steps: const [
        _SopStep(
          stepNumber: '1',
          role: 'Masyarakat',
          duration: '-',
          output: 'Pengaduan',
          description: 'Masyarakat membuat pengaduan melalui Whatsapp',
        ),
        _SopStep(
          stepNumber: '2',
          role: 'Staf Pengaduan',
          duration: '15 Menit',
          output: 'Berkas Pengaduan Lengkap',
          description: 'Menerima dan mencatat pengaduan dari masyarakat yang didapat dari kanal Whatsapp',
        ),
        _SopStep(
          stepNumber: '3',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Pengaduan telah diterima',
          description: 'Pengaduan yang bukan kewenangan DPMPTSP. Menerima pengaduan yang diserahkan staf pengaduan kemudian meneruskan kepada OPD terkait apabila bukan kewenangan DPMPTSP untuk menjawab pengaduan. Selanjutnya OPD menindaklanjuti pengaduan langsung kepada masyarakat',
        ),
        _SopStep(
          stepNumber: '4',
          role: 'Penata Perizinan Ahli Muda',
          duration: '30 Menit',
          output: 'Berkas Pengaduan Lengkap dan konsep jawaban',
          description: 'Pengaduan kewenangan DPMPTSP. Menyusun berkas pengaduan, menganalisis serta memverifikasi berkas pengaduan untuk dijadikan konsep jawaban pengaduan',
        ),
        _SopStep(
          stepNumber: '5',
          role: 'Penata Perizinan Ahli Madya',
          duration: '15 Menit',
          output: 'konsep jawaban',
          description: 'Penata Perizinan Ahli Madya menerima dan memverifikasi rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '6',
          role: 'Kepala Dinas',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Kepala Dinas Menerima dan menyetujui rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '7',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Penata Perizinan Ahli Muda menerima persetujuan jawaban pengaduan kemudian menyampaikan jawaban kepada staf pengaduan untuk disampaikan kepada masyarakat',
        ),
      ],
    );
  }

  Widget _buildSopInstagramTab(bool isDark) {
    return _buildSopContainer(
      isDark: isDark,
      title: 'SOP Penanganan Pengaduan Melalui Instagram',
      steps: const [
        _SopStep(
          stepNumber: '1',
          role: 'Masyarakat',
          duration: '-',
          output: 'Pengaduan',
          description: 'Masyarakat membuat pengaduan melalui Instagram',
        ),
        _SopStep(
          stepNumber: '2',
          role: 'Staf Pengaduan',
          duration: '15 Menit',
          output: 'Berkas Pengaduan Lengkap',
          description: 'Menerima dan mencatat pengaduan dari masyarakat yang didapat dari kanal Instagram',
        ),
        _SopStep(
          stepNumber: '3',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Pengaduan telah diterima',
          description: 'Pengaduan yang bukan kewenangan DPMPTSP. Menerima pengaduan yang diserahkan staf pengaduan kemudian meneruskan kepada OPD terkait apabila bukan kewenangan DPMPTSP untuk menjawab pengaduan. Selanjutnya OPD menindaklanjuti pengaduan langsung kepada masyarakat',
        ),
        _SopStep(
          stepNumber: '4',
          role: 'Penata Perizinan Ahli Muda',
          duration: '30 Menit',
          output: 'Berkas Pengaduan Lengkap dan konsep jawaban',
          description: 'Pengaduan kewenangan DPMPTSP. Menyusun berkas pengaduan, menganalisis serta memverifikasi berkas pengaduan untuk dijadikan konsep jawaban pengaduan',
        ),
        _SopStep(
          stepNumber: '5',
          role: 'Penata Perizinan Ahli Madya',
          duration: '15 Menit',
          output: 'konsep jawaban',
          description: 'Penata Perizinan Ahli Madya menerima dan memverifikasi rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '6',
          role: 'Kepala Dinas',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Kepala Dinas Menerima dan menyetujui rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '7',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Penata Perizinan Ahli Muda menerima persetujuan jawaban pengaduan kemudian menyampaikan jawaban kepada staf pengaduan untuk disampaikan kepada masyarakat',
        ),
      ],
    );
  }

  Widget _buildSopTwitterTab(bool isDark) {
    return _buildSopContainer(
      isDark: isDark,
      title: 'SOP Penanganan Pengaduan Melalui Twitter / X',
      steps: const [
        _SopStep(
          stepNumber: '1',
          role: 'Masyarakat',
          duration: '-',
          output: 'Pengaduan',
          description: 'Masyarakat membuat pengaduan melalui Twitter / X',
        ),
        _SopStep(
          stepNumber: '2',
          role: 'Staf Pengaduan',
          duration: '15 Menit',
          output: 'Berkas Pengaduan Lengkap',
          description: 'Menerima dan mencatat pengaduan dari masyarakat yang didapat dari kanal Twitter / X',
        ),
        _SopStep(
          stepNumber: '3',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Pengaduan telah diterima',
          description: 'Pengaduan yang bukan kewenangan DPMPTSP. Menerima pengaduan yang diserahkan staf pengaduan kemudian meneruskan kepada OPD terkait apabila bukan kewenangan DPMPTSP untuk menjawab pengaduan. Selanjutnya OPD menindaklanjuti pengaduan langsung kepada masyarakat',
        ),
        _SopStep(
          stepNumber: '4',
          role: 'Penata Perizinan Ahli Muda',
          duration: '30 Menit',
          output: 'Berkas Pengaduan Lengkap dan konsep jawaban',
          description: 'Pengaduan kewenangan DPMPTSP. Menyusun berkas pengaduan, menganalisis serta memverifikasi berkas pengaduan untuk dijadikan konsep jawaban pengaduan',
        ),
        _SopStep(
          stepNumber: '5',
          role: 'Penata Perizinan Ahli Madya',
          duration: '15 Menit',
          output: 'konsep jawaban',
          description: 'Penata Perizinan Ahli Madya menerima dan memverifikasi rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '6',
          role: 'Kepala Dinas',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Kepala Dinas Menerima dan menyetujui rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
        ),
        _SopStep(
          stepNumber: '7',
          role: 'Penata Perizinan Ahli Muda',
          duration: '15 Menit',
          output: 'Jawaban pengaduan',
          description: 'Penata Perizinan Ahli Muda menerima persetujuan jawaban pengaduan kemudian menyampaikan jawaban kepada staf pengaduan untuk disampaikan kepada masyarakat',
        ),
      ],
    );
  }

  Widget _buildSopContainer({
    required bool isDark,
    required String title,
    required List<_SopStep> steps,
  }) {
    return _InteractiveSopContainer(
      isDark: isDark,
      title: title,
      steps: steps,
    );
  }
}

class _InteractiveSopContainer extends StatelessWidget {
  final bool isDark;
  final String title;
  final List<_SopStep> steps;

  const _InteractiveSopContainer({
    required this.isDark,
    required this.title,
    required this.steps,
  });

  void _showStepDetailDialog(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) {
        final dialogPageController = PageController(initialPage: initialIndex);
        int dialogCurrentIndex = initialIndex;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final currentStep = steps[dialogCurrentIndex];

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              elevation: 16,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Container(
                padding: const EdgeInsets.all(18),
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Header Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF0D62F1), Color(0xFF0284C7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            currentStep.stepNumber,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0D62F1).withAlpha(25),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      currentStep.role,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0D62F1),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981).withAlpha(25),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '⏱️ ${currentStep.duration}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.cancel_rounded,
                            color: isDark ? Colors.white54 : Colors.black45,
                            size: 24,
                          ),
                          tooltip: 'Tutup',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), height: 1),
                    const SizedBox(height: 12),

                    // Swipeable Card View Inside Dialog
                    SizedBox(
                      height: 290,
                      child: PageView.builder(
                        controller: dialogPageController,
                        onPageChanged: (idx) {
                          setStateDialog(() {
                            dialogCurrentIndex = idx;
                          });
                        },
                        itemCount: steps.length,
                        itemBuilder: (context, idx) {
                          final stepItem = steps[idx];

                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.swipe_rounded, color: Color(0xFF0D62F1), size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'DETAIL PROSEDUR (LANGKAH ${stepItem.stepNumber} DARI ${steps.length})',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w900,
                                        color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0D62F1),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Large Text Box for Seniors (15.5px Bold)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Text(
                                    stepItem.description,
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      height: 1.45,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Output Box
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withAlpha(15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF10B981).withAlpha(40),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.task_alt_rounded, color: Color(0xFF10B981), size: 16),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'Hasil / Output: ${stepItem.output}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Gesture Hint & Swipe Navigation Controls
                    Row(
                      children: [
                        IconButton(
                          onPressed: dialogCurrentIndex > 0
                              ? () {
                                  dialogPageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
                          tooltip: 'Langkah Sebelumnya',
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Langkah ${dialogCurrentIndex + 1} dari ${steps.length}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '👈 Geser kartu kiri / kanan 👉',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: dialogCurrentIndex < steps.length - 1
                              ? () {
                                  dialogPageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                          tooltip: 'Langkah Selanjutnya',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Close Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D62F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                        label: const Text(
                          'Mengerti & Tutup',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0D62F1),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D62F1).withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_rounded, color: Color(0xFF0D62F1), size: 12),
                    SizedBox(width: 4),
                    Text(
                      'Ketuk Nomer / Langkah',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D62F1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Vertical Scrollable List extending downwards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Container(
                height: 10,
                width: 2,
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              ),
            ),
            itemBuilder: (context, index) {
              final s = steps[index];

              return InkWell(
                onTap: () => _showStepDetailDialog(context, index),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A).withAlpha(120) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0D62F1), Color(0xFF0284C7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          s.stepNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D62F1).withAlpha(20),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    s.role,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0D62F1),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withAlpha(20),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '⏱️ ${s.duration}',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              s.description,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withAlpha(15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Output: ${s.output}',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D62F1).withAlpha(15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.zoom_in_rounded, color: Color(0xFF0D62F1), size: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
    );
  }
}
