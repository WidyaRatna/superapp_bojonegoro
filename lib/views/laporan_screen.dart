import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile_screen.dart';
import 'layanan_pengaduan_dpmptsp_screen.dart';

class LaporanWargaService {
  static bool dontShowDisclaimerAgain = false;

  static void openLaporanWarga(BuildContext context, bool isDarkMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LayananPengaduanDpmptspScreen(
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }
}

class LaporanScreen extends StatefulWidget {
  final bool isDarkMode;
  final int initialStep; // 1 = Info, 2 = Form, 3 = Review, 4 = Success

  const LaporanScreen({
    super.key,
    required this.isDarkMode,
    this.initialStep = 1,
  });

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  late int _currentStep;
  bool _dontShowAgainCheckbox = false;

  // Form State
  String _selectedCategory = 'Infrastruktur & Jalan';
  bool _isPublicReport = false;
  bool _hasTakenPhoto = false;
  String _photoSource = 'Kamera HP';
  final TextEditingController _descController = TextEditingController(
    text: 'Jalan berlubang cukup dalam di dekat perempatan Mastrip Bojonegoro, membahayakan pengendara motor saat malam hari.',
  );

  final List<String> _categories = [
    'Infrastruktur & Jalan',
    'Kebersihan & Sampah',
    'Pelayanan Publik',
    'Lampu Penerangan',
    'Kesehatan & Medis',
    'Bencana & Banjir',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

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

  // Photo Source Picker (Kamera vs Galeri)
  void _showPhotoOptionPicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Pilih Sumber Foto / Bukti Laporan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Gunakan kamera langsung HP/Laptop atau upload file foto dari galeri.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 18),

            // Option 1: Kamera HP / Laptop (Foto Mendadak)
            InkWell(
              onTap: () {
                Navigator.pop(ctx);
                _openCameraSimulator();
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D62F1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ambil Foto Langsung (Kamera HP/Laptop)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Buka Kamera HP/Laptop untuk jepret foto kejadian secara mendadak',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Option 2: Unggah File / Galeri (Memori Perangkat)
            InkWell(
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _hasTakenPhoto = true;
                  _photoSource = 'Galeri Perangkat';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Foto / Dokumen berhasil dipilih dari Galeri HP! 📁'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.photo_library_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unggah dari Galeri / File HP',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Pilih file foto atau dokumen bukti dari penyimpanan HP/Laptop',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Camera Viewfinder Simulator Dialog
  void _openCameraSimulator() {
    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          height: 480,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(dialogCtx),
                  ),
                  const Text(
                    'Kamera Laporan Warga',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.flash_on_rounded, color: Colors.amber),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF0D62F1), width: 2),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white38, width: 1.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_rounded, color: Colors.white54, size: 48),
                          SizedBox(height: 10),
                          Text(
                            'Arahkan kamera ke lokasi kejadian',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: Color(0xFF10B981), size: 12),
                              SizedBox(width: 4),
                              Text(
                                'GPS Auto: Bojonegoro',
                                style: TextStyle(color: Colors.white, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _hasTakenPhoto = true;
                    _photoSource = 'Kamera Perangkat';
                  });
                  Navigator.pop(dialogCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Foto kejadian berhasil diambil! 📸'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                },
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF0D62F1), width: 4),
                  ),
                  child: const Center(
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFF0D62F1),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ketuk untuk Mengambil Foto',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _getStepTitle {
    switch (_currentStep) {
      case 1:
        return 'Informasi Laporan';
      case 2:
        return 'Isi Form Laporan';
      case 3:
        return 'Tinjau Laporan';
      case 4:
        return 'Laporan Selesai';
      default:
        return 'Form Laporan Warga';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: _currentStep == 4
          ? null // No AppBar on Success Screen
          : AppBar(
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF0052D4),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () {
                  if (_currentStep > 1) {
                    setState(() {
                      _currentStep--;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStepTitle,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text(
                    'Langkah $_currentStep dari 3 • Wadul Bupati Bojonegoro',
                    style: const TextStyle(color: Color(0xFFDBEAFE), fontSize: 11),
                  ),
                ],
              ),
            ),
      body: SafeArea(
        child: _buildCurrentStepWidget(isDark),
      ),
    );
  }

  Widget _buildCurrentStepWidget(bool isDark) {
    switch (_currentStep) {
      case 1:
        return _buildDisclaimerView(isDark);
      case 2:
        return _buildFormView(isDark);
      case 3:
        return _buildReviewView(isDark);
      case 4:
        return _buildSuccessView(isDark);
      default:
        return _buildDisclaimerView(isDark);
    }
  }

  // STEP 1: Halaman Informasi (Muncul Sekali)
  Widget _buildDisclaimerView(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D62F1).withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.assignment_late_rounded, color: Color(0xFF0D62F1), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingin membuat laporan?',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Baca informasi berikut sebelum mengirim laporan.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          _buildDisclaimerPoint(
            icon: '📌',
            title: 'Tindak Lanjut Laporan',
            description:
                'Laporan yang dikirim akan diteruskan kepada Organisasi Perangkat Daerah (OPD) yang berwenang sesuai dengan jenis permasalahan yang dilaporkan.',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _buildDisclaimerPoint(
            icon: '📍',
            title: 'Lokasi Laporan',
            description:
                'Lokasi laporan akan diambil secara otomatis apabila pengguna memberikan izin akses lokasi.',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _buildDisclaimerPoint(
            icon: '📷',
            title: 'Bukti Pendukung',
            description:
                'Tambahkan foto atau dokumen pendukung agar laporan lebih jelas dan memudahkan petugas dalam melakukan verifikasi.',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _buildDisclaimerPoint(
            icon: '🔒',
            title: 'Privasi Laporan',
            description:
                'Secara default laporan akan dikirim sebagai Privat sehingga hanya dapat dilihat oleh pelapor dan petugas yang berwenang.',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _buildDisclaimerPoint(
            icon: '🌐',
            title: 'Laporan Publik',
            description:
                'Apabila ingin laporan dapat dilihat oleh masyarakat, ubah jenis laporan menjadi Publik sebelum mengirim laporan.',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _buildDisclaimerPoint(
            icon: '⚠️',
            title: 'Ketentuan Laporan',
            description:
                'Pastikan laporan yang dikirim sesuai dengan kondisi sebenarnya, tidak mengandung unsur SARA, ujaran kebencian, maupun informasi yang tidak dapat dipertanggungjawabkan.',
            isDark: isDark,
          ),

          // Layanan Pengaduan DPMPTSP & SP4N-LAPOR! Resmi
          _buildDpmptspLayananSection(isDark),

          const SizedBox(height: 16),
          Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),

          InkWell(
            onTap: () {
              setState(() {
                _dontShowAgainCheckbox = !_dontShowAgainCheckbox;
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                Checkbox(
                  value: _dontShowAgainCheckbox,
                  activeColor: const Color(0xFF0D62F1),
                  onChanged: (val) {
                    setState(() {
                      _dontShowAgainCheckbox = val ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'Saya telah membaca dan memahami informasi di atas. Jangan tampilkan halaman ini lagi.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D62F1),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                if (_dontShowAgainCheckbox) {
                  LaporanWargaService.dontShowDisclaimerAgain = true;
                }
                setState(() {
                  _currentStep = 2;
                });
              },
              child: const Text(
                'Lanjutkan ke Form Laporan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDisclaimerPoint({
    required String icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDpmptspLayananSection(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D62F1).withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge & Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D62F1), Color(0xFF0284C7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D62F1).withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'KANAL PENGADUAN RESMI',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0D62F1),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'LAYANAN PENGADUAN DPMPTSP KABUPATEN BOJONEGORO',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, size: 14, color: Color(0xFF10B981)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Jadwal Tatap Muka: Senin - Jumat (08.00 - 15.00 WIB)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Open Dedicated Screen Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                side: const BorderSide(color: Color(0xFF0D62F1), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LayananPengaduanDpmptspScreen(
                      isDarkMode: isDark,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.open_in_new_rounded, color: Color(0xFF0D62F1), size: 18),
              label: const Text(
                'Buka Halaman Lengkap & SOP Pengaduan DPMPTSP',
                style: TextStyle(
                  color: Color(0xFF0D62F1),
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Intro Statement
          Text(
            'Dalam rangka memberikan pelayanan yang baik kepada masyarakat terkait masalah pelayanan, disediakan beberapa cara untuk menangani keluhan/pengaduan masyarakat selama rentang pemrosesan perizinan dan non perizinan yang diajukan, antara lain :',
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 14),

          // 1. Website lapor.go.id
          _buildKanalPengaduanItem(
            icon: Icons.language_rounded,
            iconBgColor: const Color(0xFF0D62F1),
            title: 'Website lapor.go.id',
            value: 'https://www.lapor.go.id/',
            subtitle: 'Kabupaten Bojonegoro yang khusus menangani keluhan masyarakat, dengan alamat website : https://www.lapor.go.id/',
            buttonLabel: 'Buka Web',
            onTap: () => _openWebUrl('https://www.lapor.go.id/'),
            isDark: isDark,
          ),
          const SizedBox(height: 10),

          // 2. Media Surat / tertulis
          _buildKanalPengaduanItem(
            icon: Icons.mark_unread_chat_alt_rounded,
            iconBgColor: const Color(0xFFF59E0B),
            title: 'Media Surat / Tertulis',
            value: 'Kantor DPMPTSP Kab. Bojonegoro',
            subtitle: 'Surat di alamatkan ke kantor DPMPTSP Kabupaten Bojonegoro Jl. Veteran No. 227, Mal Pelayanan Publik Kabupaten Bojonegoro (Telp: 0353-5256661)',
            buttonLabel: 'Telepon MPP',
            onTap: () => _makePhoneCall('03535256661'),
            isDark: isDark,
          ),
          const SizedBox(height: 10),

          // 3. Email
          _buildKanalPengaduanItem(
            icon: Icons.email_rounded,
            iconBgColor: const Color(0xFFEF4444),
            title: 'Email Pengaduan',
            value: 'dpmptsp.kabbjn@gmail.com',
            subtitle: 'Email terkait keluhan dan pelayanan DPMPTSP Kabupaten Bojonegoro dapat di kirim ke alamat email : dpmptsp.kabbjn@gmail.com',
            buttonLabel: 'Kirim Email',
            onTap: () => _openEmail('dpmptsp.kabbjn@gmail.com'),
            isDark: isDark,
          ),
          const SizedBox(height: 10),

          // 4. Media Langsung / Tatap Muka
          _buildKanalPengaduanItem(
            icon: Icons.location_on_rounded,
            iconBgColor: const Color(0xFF10B981),
            title: 'Media Langsung / Tatap Muka',
            value: 'Mal Pelayanan Publik (MPP) Bojonegoro',
            subtitle: 'Masyarakat dapat langsung datang ke kantor DPMPTSP Kabupaten Bojonegoro dengan tujuan untuk mengajukan keluhan, maka akan diterima petugas pengaduan untuk dicatat isi dari pengaduan tersebut.',
            buttonLabel: 'Alamat Klik Disini',
            onTap: () => _openWebUrl('https://maps.google.com/?q=DPMPTSP+Kabupaten+Bojonegoro+Jl+Veteran+No+227'),
            isDark: isDark,
          ),
          const SizedBox(height: 10),

          // 5. Nomor Layanan Pengaduan
          _buildKanalPengaduanItem(
            icon: Icons.chat_rounded,
            iconBgColor: const Color(0xFF22C55E),
            title: 'Nomor Layanan Pengaduan',
            value: '+62 822 3309 9988',
            subtitle: 'Masyarakat dapat menghubungi layanan pengaduan lewat WA/SMS ke nomor : +62 822 3309 9988',
            buttonLabel: 'Chat WA',
            onTap: () => _openWhatsApp('082233099988'),
            isDark: isDark,
          ),
          const SizedBox(height: 10),

          // 6. Website DPMPTSP Kabupaten Bojonegoro
          _buildKanalPengaduanItem(
            icon: Icons.public_rounded,
            iconBgColor: const Color(0xFF8B5CF6),
            title: 'Website DPMPTSP Kab. Bojonegoro',
            value: 'dpmptsp.bojonegorokab.go.id/bukutamu/add',
            subtitle: 'Formulir Pengaduan / Buku Tamu Website DPMPTSP Kab. Bojonegoro',
            buttonLabel: 'Klik Website',
            onTap: () => _openWebUrl('https://dpmptsp.bojonegorokab.go.id/bukutamu/add'),
            isDark: isDark,
          ),
          const SizedBox(height: 14),

          // Detailed Explanatory Paragraph Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Color(0xFF0D62F1), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Informasi & Ketentuan Pengaduan',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Melalui pengaduan ini, pengguna jasa dapat menyampaikan keluhan maupun komentar terhadap fasilitas gedung, pelayanan, pelanggaran kode etik, serta hal-hal yang terkait dengan pelaksanaan prosedur pelayanan di Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu Kabupaten Bojonegoro. Pengaduan ini disampaikan secara langsung atau melalui email dengan mengisi formulir pengaduan dibawah secara lengkap, agar petugas kami dapat menindaklanjuti pengaduan yang telah disampaikan. Apabila data yang disampaikan tidak benar, pengaduan tidak akan diproses lebih lanjut.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.45,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Commitment Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E3A8A).withAlpha(120), const Color(0xFF1E293B)]
                    : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF0D62F1).withAlpha(50),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: Color(0xFF0D62F1), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pengaduan anda akan membantu Kami meningkatkan kualitas pelayanan dan menegakkan integritas pegawai',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E40AF),
                      height: 1.35,
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

  Widget _buildKanalPengaduanItem({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String value,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconBgColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: iconBgColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: onTap,
            child: Text(
              buttonLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // STEP 2: Form Laporan
  Widget _buildFormView(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bukti Foto / Dokumen Kejadian',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hasTakenPhoto
                    ? const Color(0xFF10B981)
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                width: _hasTakenPhoto ? 2 : 1.5,
              ),
            ),
            child: InkWell(
              onTap: _showPhotoOptionPicker,
              borderRadius: BorderRadius.circular(20),
              child: _hasTakenPhoto
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFDCFCE7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 36),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Foto Kejadian Terlampir 📸',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Sumber: $_photoSource (Ketuk untuk ganti)',
                              style: const TextStyle(color: Color(0xFF10B981), fontSize: 11.5, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D62F1).withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF0D62F1), size: 30),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ketuk untuk Ambil Foto atau Upload File',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Kamera HP/Laptop atau dari Galeri Perangkat',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Kategori Pengaduan (Geser Kesamping Kiri/Kanan)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: ScrollConfiguration(
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
                  children: _categories.map((cat) {
                  final isSel = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      selected: isSel,
                      label: Text(cat),
                      labelStyle: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                        color: isSel
                            ? Colors.white
                            : (isDark ? Colors.white70 : const Color(0xFF334155)),
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
                          setState(() {
                            _selectedCategory = cat;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

          Text(
            'Detail Laporan / Keluhan',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              ),
            ),
            child: TextField(
              controller: _descController,
              maxLines: 4,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 13.5,
              ),
              decoration: const InputDecoration(
                hintText: 'Tuliskan penjelasan rinci mengenai kejadian, alur masalah, dan lokasi...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _isPublicReport ? Icons.public_rounded : Icons.lock_outline_rounded,
                      color: _isPublicReport ? const Color(0xFF10B981) : const Color(0xFF64748B),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isPublicReport ? 'Laporan Publik (Terbuka)' : 'Laporan Privat (Rahasia)',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          _isPublicReport
                              ? 'Dapat dilihat oleh masyarakat umum'
                              : 'Hanya dapat dilihat pelapor & petugas OPD',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Switch(
                  value: _isPublicReport,
                  activeTrackColor: const Color(0xFF10B981),
                  onChanged: (val) {
                    setState(() {
                      _isPublicReport = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D62F1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              icon: const Icon(Icons.rate_review_rounded, color: Colors.white, size: 20),
              label: const Text(
                'Lanjut ke Tinjau Laporan',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (_descController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Harap isi detail laporan terlebih dahulu.')),
                  );
                  return;
                }
                setState(() {
                  _currentStep = 3;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // STEP 3: Tinjau Laporan (Review Summary Page)
  Widget _buildReviewView(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Tinjau Laporan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.rate_review_rounded, color: Color(0xFFF59E0B), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tinjau Laporan Anda',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pastikan seluruh data pengaduan sudah sesuai sebelum dikirim.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pelapor Info
                Row(
                  children: [
                    buildAvatarCircle(
                      UserProfileData.avatarType,
                      20,
                      24,
                      avatarImagePath: UserProfileData.avatarImagePath,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserProfileData.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'NIK: 3522081234560001 • Terverifikasi',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                const SizedBox(height: 12),

                // Details List
                _buildReviewRow('Kategori Pengaduan', _selectedCategory, isDark, isBold: true),
                const SizedBox(height: 12),
                _buildReviewRow(
                    'Status Privasi',
                    _isPublicReport ? 'Publik (Dapat Dilihat Umum)' : 'Privat (Rahasia Petugas OPD)',
                    isDark),
                const SizedBox(height: 12),
                _buildReviewRow('Lokasi Kejadian', 'Jl. Mastrip, Kab. Bojonegoro (GPS Terverifikasi)', isDark),
                const SizedBox(height: 12),
                _buildReviewRow('Bukti Foto Attached',
                    _hasTakenPhoto ? 'Ada BuktiFoto ($_photoSource)' : 'Tidak Ada Foto Bukti', isDark),
                const SizedBox(height: 14),

                Text(
                  'Isi Laporan / Keluhan:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    _descController.text,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons: Edit vs Confirm Send
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: const Text('Ubah Data'),
                  onPressed: () {
                    setState(() {
                      _currentStep = 2;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D62F1),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  label: const Text(
                    'Kirim Laporan',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    setState(() {
                      _currentStep = 4;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, bool isDark, {bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ),
        const Text(': '),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }

  // STEP 4: Berhasil Dikirim (Success Screen)
  Widget _buildSuccessView(bool isDark) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Animated Checkmark Circle
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withAlpha(80),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF10B981),
                size: 64,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Laporan Berhasil Dikirim!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Laporan Anda telah diteruskan ke Dinas / OPD terkait Kab. Bojonegoro untuk verifikasi.',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Ticket Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nomor Tiket Laporan:',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D62F1).withAlpha(20),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '#BOJO-2026-8891',
                          style: TextStyle(
                            color: Color(0xFF0D62F1),
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled_rounded, color: Color(0xFFF59E0B), size: 18),
                      const SizedBox(width: 10),
                      Text(
                        'Estimasi Respon OPD: 1x24 Jam Kerja',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D62F1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Kembali ke Beranda',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
