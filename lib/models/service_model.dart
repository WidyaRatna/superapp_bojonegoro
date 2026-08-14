import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<String> subServices;

  ServiceCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.subServices,
  });
}

final List<ServiceCategory> sampleServices = [
  ServiceCategory(
    id: 'kependudukan',
    title: 'Kependudukan',
    icon: Icons.badge_rounded,
    color: const Color(0xFF2563EB), // Vibrant blue
    subServices: [
      'Data Jumlah Penduduk',
      'Persyaratan Layanan',
    ],
  ),
  ServiceCategory(
    id: 'kesehatan',
    title: 'Kesehatan',
    icon: Icons.medical_services_rounded,
    color: const Color(0xFFEF4444), // Coral Red
    subServices: [
      'Antrean Online RSUD',
      'Layanan Ambulans Darurat (081132277119)',
      'Stok Darah PMI Bojonegoro',
      'Cek Fasilitas BPJS Kesehatan',
      'Layanan Telemedicine Gratis',
    ],
  ),
  ServiceCategory(
    id: 'pendidikan',
    title: 'Pendidikan',
    icon: Icons.school_rounded,
    color: const Color(0xFF8B5CF6), // Royal Purple
    subServices: [
      'Pendaftaran Beasiswa Daerah',
      'Informasi Perpustakaan Daerah',
    ],
  ),
  ServiceCategory(
    id: 'perpajakan',
    title: 'Pajak & Retribusi',
    icon: Icons.request_quote_rounded,
    color: const Color(0xFFF59E0B), // Amber / Gold
    subServices: [
      'Cek Tagihan PBB-P2',
      'Bayar Pajak Kendaraan (SAMSAT)',
      'Pajak Restoran & Reklame',
      'E-SPTPD Bojonegoro',
    ],
  ),
  ServiceCategory(
    id: 'umkm',
    title: 'Informasi Pangan',
    icon: Icons.shopping_basket_rounded,
    color: const Color(0xFF0D9488), // Teal
    subServices: [
      'Info Harga Sembako Hari Ini',
      'Cek Harga Beras, Minyak & Telur',
      'Harga Pangan Pasar Tradisional',
      'Ketersediaan Komoditas Daerah',
    ],
  ),
  ServiceCategory(
    id: 'pertanian',
    title: 'Pertanian',
    icon: Icons.grass_rounded,
    color: const Color(0xFF059669), // Forest Green
    subServices: [
      'Pupuk Bersubsidi',
      'Pengaduan Pertanian',
      'Info Harga Komoditas Tani',
      'Klaim Asuransi Pertanian',
    ],
  ),
  ServiceCategory(
    id: 'pariwisata',
    title: 'Pariwisata',
    icon: Icons.theater_comedy_rounded,
    color: const Color(0xFF06B6D4), // Cyan
    subServices: [
      'Tempat Rekreasi (Alam & Taman)',
      'Tempat Sejarah & Budaya',
    ],
  ),
  ServiceCategory(
    id: 'pengaduan',
    title: 'Pengaduan',
    icon: Icons.chat_bubble_rounded,
    color: const Color(0xFFF43F5E), // Rose Pink
    subServices: [
      'Layanan Pengaduan DPMPTSP Kab. Bojonegoro',
      'Form Online Wadul Bupati',
      'Website SP4N-LAPOR! (lapor.go.id)',
      'Hotline WA / SMS (+62 822 3309 9988)',
      'Email Pengaduan (dpmptsp.kabbjn@gmail.com)',
      'Media Surat & Tatap Muka (MPP)',
    ],
  ),
  ServiceCategory(
    id: 'kontak_instansi',
    title: 'Kontak Instansi',
    icon: Icons.contact_phone_rounded,
    color: const Color(0xFF475569), // Slate Steel Blue
    subServices: [
      'Direktori Dinas Kab. Bojonegoro',
      'Kontak Kantor Kecamatan & Desa',
      'Informasi Jam Pelayanan Publik',
    ],
  ),
  ServiceCategory(
    id: 'kontak_darurat',
    title: 'Kontak Darurat',
    icon: Icons.notifications_active_rounded,
    color: const Color(0xFFDC2626), // Crimson Red
    subServices: [
      'Ambulans Gawat Darurat',
      'Pemadam Kebakaran (Damkar)',
      'Kepolisian (Polres Bojonegoro)',
      'Call Center 112 Bojonegoro',
    ],
  ),
  ServiceCategory(
    id: 'tenaga_kerja',
    title: 'Lowongan Pekerjaan',
    icon: Icons.work_rounded,
    color: const Color(0xFF0D9488), // Ocean Teal
    subServices: [
      'Pembuatan Kartu Kuning (AK-1)',
      'Lowongan Kerja Disnaker',
      'Pelatihan Kerja Gratis BLK',
      'Program Magang Industri',
    ],
  ),
  ServiceCategory(
    id: 'sosial',
    title: 'Sosial',
    icon: Icons.volunteer_activism_rounded,
    color: const Color(0xFF7C3AED), // Violet
    subServices: [
      'Cek Bansos PKH & BPNT',
      'Pendaftaran DTKS Kemensos',
      'Bantuan Penyandang Disabilitas',
      'Layanan Rumah Singgah Sosial',
    ],
  ),
  ServiceCategory(
    id: 'perhubungan',
    title: 'Perhubungan',
    icon: Icons.directions_bus_rounded,
    color: const Color(0xFF0284C7), // Sky Blue
    subServices: [
      'Uji Berkala (Kir) Kendaraan',
      'Jadwal Angkutan Umum Daerah',
      'Pengaduan Lampu Jalan & Rambu',
    ],
  ),
  ServiceCategory(
    id: 'portal_berita',
    title: 'Portal Berita',
    icon: Icons.newspaper_rounded,
    color: const Color(0xFF1D4ED8), // Royal Blue
    subServices: [
      'Berita Terkini Bojonegoro',
      'Pengumuman Resmi Pemkab',
      'Majalah & Warta Daerah',
    ],
  ),
  ServiceCategory(
    id: 'pengadaan',
    title: 'Pengadaan',
    icon: Icons.shopping_cart_rounded,
    color: const Color(0xFF4F46E5), // Indigo
    subServices: [
      'Layanan LPSE Bojonegoro',
      'Katalog Rencana Pengadaan (SiRUP)',
      'Info Lelang & Tender Publik',
    ],
  ),
  ServiceCategory(
    id: 'lainnya',
    title: 'Lainnya',
    icon: Icons.grid_view_rounded,
    color: const Color(0xFF64748B), // Slate Grey
    subServices: [
      'Seluruh Katalog Layanan Daerah',
      'Bantuan Teknis Aplikasi',
    ],
  ),
];


