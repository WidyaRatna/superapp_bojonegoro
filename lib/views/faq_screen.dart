import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  final bool isDarkMode;

  const FaqScreen({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode;

    final List<Map<String, String>> faqList = [
      {
        'question': 'Bagaimana cara mengajukan layanan?',
        'answer':
            'Pilih menu Layanan, kemudian pilih layanan yang dibutuhkan, lengkapi data yang diminta, lalu kirim pengajuan.',
      },
      {
        'question': 'Bagaimana cara membuat laporan pengaduan?',
        'answer':
            'Buka menu Lapor Warga, isi formulir, tambahkan bukti jika diperlukan, lalu kirim laporan.',
      },
      {
        'question': 'Bagaimana cara melihat status layanan?',
        'answer':
            'Status pengajuan dapat dilihat melalui menu Riwayat Layanan pada halaman Profil.',
      },
      {
        'question': 'Bagaimana cara melihat perkembangan laporan?',
        'answer':
            'Buka menu Riwayat Pengaduan untuk melihat status terbaru laporan yang telah dikirim.',
      },
      {
        'question': 'Apakah data pribadi saya aman?',
        'answer':
            'Ya. Data pengguna dikelola sesuai kebijakan privasi dan hanya digunakan untuk keperluan pelayanan publik.',
      },
      {
        'question': 'Bagaimana jika saya mengalami kendala saat menggunakan aplikasi?',
        'answer':
            'Hubungi menu Bantuan atau kirim laporan melalui fitur bantuan agar dapat ditindaklanjuti oleh tim pengembang.',
      },
      {
        'question': 'Mengapa saya tidak menerima notifikasi?',
        'answer':
            'Pastikan izin notifikasi telah diaktifkan pada pengaturan aplikasi maupun perangkat.',
      },
      {
        'question': 'Bagaimana cara menghubungi layanan darurat?',
        'answer':
            'Buka menu Layanan Darurat untuk melihat daftar nomor penting seperti Call Center 112, Damkar, BPBD, RSUD, dan layanan darurat lainnya.',
      },
    ];

    final List<Map<String, String>> contactList = [
      {
        'title': 'Call Center 112 Bojonegoro',
        'desc': 'Layanan siaga bebas pulsa 24 jam untuk kondisi darurat medis, kebakaran & bencana.',
      },
      {
        'title': 'Email Resmi Dinkominfo',
        'desc': 'Kirim pesan atau pertanyaan ke email resmi: dinkominfo@bojonegorokab.go.id',
      },
      {
        'title': 'Telepon Kantor Dinkominfo',
        'desc': 'Hubungi kantor Dinkominfo Kabupaten Bojonegoro di nomor (0353) 881826',
      },
      {
        'title': 'Laporkan Masalah Teknis',
        'desc': 'Menemukan kendala pada fitur aplikasi? Kirim laporan singkat melalui menu Bantuan.',
      },
    ];

    final List<Map<String, String>> infoCenterList = [
      {
        'title': 'Panduan Pengguna SuperApp',
        'desc': 'Pelajari panduan lengkap penggunaan fitur layanan publik digital Kabupaten Bojonegoro.',
      },
      {
        'title': 'Status Sistem & Server',
        'desc': 'Cek ketersediaan server & pembaruan sistem secara berkala untuk kenyamanan akses layanan.',
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pusat Bantuan & FAQ',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION 1: Frequently Asked Questions (FAQ)
            _buildSectionTitle('Frequently Asked Questions (FAQ)', isDark),
            const SizedBox(height: 12),
            ...faqList.map((item) => _buildFaqBulletItem(
                  question: item['question']!,
                  answer: item['answer']!,
                  isDark: isDark,
                )),
            const SizedBox(height: 24),

            // SECTION 2: Hubungi Kami
            _buildSectionTitle('Hubungi Kami', isDark),
            const SizedBox(height: 12),
            ...contactList.map((item) => _buildFaqBulletItem(
                  question: item['title']!,
                  answer: item['desc']!,
                  isDark: isDark,
                )),
            const SizedBox(height: 24),

            // SECTION 3: Pusat Informasi
            _buildSectionTitle('Pusat Informasi', isDark),
            const SizedBox(height: 12),
            ...infoCenterList.map((item) => _buildFaqBulletItem(
                  question: item['title']!,
                  answer: item['desc']!,
                  isDark: isDark,
                )),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
      ),
    );
  }

  Widget _buildFaqBulletItem({
    required String question,
    required String answer,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
              height: 1.3,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$question ',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      height: 1.4,
                    ),
                  ),
                  TextSpan(
                    text: answer,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
