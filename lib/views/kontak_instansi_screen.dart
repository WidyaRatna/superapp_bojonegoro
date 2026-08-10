import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InstansiItem {
  final String id;
  final String name;
  final String category; // BADAN, DINAS, SETDA, KECAMATAN, RSUD, BUMD, SETWAN
  final String address;
  final String phone;
  final String whatsapp;
  final String email;
  final String website;
  final String operationalHours;

  const InstansiItem({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.phone,
    this.whatsapp = '',
    this.email = '',
    this.website = '',
    this.operationalHours = 'Senin - Jumat: 07.30 - 15.30 WIB',
  });
}

final List<InstansiItem> sampleInstansiList = [
  // BADAN
  const InstansiItem(
    id: 'bappeda',
    name: 'BAPPEDA (Badan Perencanaan Pembangunan Daerah)',
    category: 'BADAN',
    address: 'Jl. P. Mastrip No. 5, Kota Bojonegoro',
    phone: '(0353) 881456',
    email: 'bappeda@bojonegorokab.go.id',
    website: 'bappeda.bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'bpkad',
    name: 'BPKAD (Badan Pengelola Keuangan & Aset Daerah)',
    category: 'BADAN',
    address: 'Jl. P. Mastrip No. 3, Kota Bojonegoro',
    phone: '(0353) 881321',
    email: 'bpkad@bojonegorokab.go.id',
    website: 'bpkad.bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'bapenda',
    name: 'BAPENDA (Badan Pendapatan Daerah)',
    category: 'BADAN',
    address: 'Jl. Chusus No. 1, Kota Bojonegoro',
    phone: '(0353) 881554',
    whatsapp: '08113554100',
    email: 'bapenda@bojonegorokab.go.id',
    website: 'bapenda.bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'bpbd',
    name: 'BPBD (Badan Penanggulangan Bencana Daerah)',
    category: 'BADAN',
    address: 'Jl. Raya Kapas No. 1, Kec. Kapas, Bojonegoro',
    phone: '(0353) 887811',
    whatsapp: '08113356112',
    email: 'bpbd@bojonegorokab.go.id',
    website: 'bpbd.bojonegorokab.go.id',
    operationalHours: '24 Jam Nonstop (Layanan Darurat)',
  ),
  const InstansiItem(
    id: 'bkpp',
    name: 'BKPP (Badan Kepegawaian, Pendidikan & Pelatihan)',
    category: 'BADAN',
    address: 'Jl. Teuku Umar No. 42, Kota Bojonegoro',
    phone: '(0353) 881776',
    email: 'bkpp@bojonegorokab.go.id',
    website: 'bkpp.bojonegorokab.go.id',
  ),

  // DINAS (22 Dinas Resmi Pemkab Bojonegoro)
  const InstansiItem(
    id: 'dinas_pendidikan',
    name: 'DINAS PENDIDIKAN',
    category: 'DINAS',
    address: 'Jl. Patimura No. 9, Bojonegoro',
    phone: '(0353) 881580',
    email: 'diknasbjn@gmail.com',
    website: 'disdik.bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_kesehatan',
    name: 'DINAS KESEHATAN',
    category: 'DINAS',
    address: 'Area Kantor Pemerintah Kabupaten Bojonegoro Jalan Dr. Cipto, Mojokampung, Kabupaten Bojonegoro',
    phone: '(0353) 881350',
    whatsapp: '081132277119',
    email: 'dinaskesehatan@bojonegorokab.go.id',
    website: 'dinkes.bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_pu_bina_marga',
    name: 'DINAS PEKERJAAN UMUM BINA MARGA DAN PENATAAN RUANG',
    category: 'DINAS',
    address: 'Jl. Raya Kapas No. 5, Kec. Kapas, Bojonegoro',
    phone: '(0353) 881772',
    email: 'dpubinamarga@bojonegorokab.go.id',
    website: 'dpubinamarga.bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_pu_sda',
    name: 'DINAS PEKERJAAN UMUM SUMBER DAYA AIR',
    category: 'DINAS',
    address: 'Jl Basuki Rahcmad no. 4a Bojonegoro',
    phone: '(0353) 881491',
    email: 'pengairan.bjn@gmail.com',
  ),
  const InstansiItem(
    id: 'dinas_perkim_cipta_karya',
    name: 'DINAS PERUMAHAN, KAWASAN PERMUKIMAN DAN CIPTA KARYA',
    category: 'DINAS',
    address: 'Jalan Lettu Soeyitno Nomor 39b Bojonegoro',
    phone: '(0353) 887444',
    email: 'dpkpck@bojonegorokab.go.id / ciptakaryadpkpck@gmail.com',
  ),
  const InstansiItem(
    id: 'dinas_sosial',
    name: 'DINAS SOSIAL',
    category: 'DINAS',
    address: 'Jl. Dr Wahidin No. 40 Bojonegoro',
    phone: '(0353) 888918',
    email: 'dinsos@bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_damkar',
    name: 'DINAS PEMADAM KEBAKARAN',
    category: 'DINAS',
    address: 'Jl. Ahmad Yani No. 06 Bojonegoro',
    phone: '(0353) 113',
    email: 'damkarbojonegoro@gmail.com',
    operationalHours: '24 Jam Nonstop (Layanan Darurat)',
  ),
  const InstansiItem(
    id: 'satpol_pp',
    name: 'SATUAN POLISI PAMONG PRAJA',
    category: 'DINAS',
    address: 'Jl. P. Mas Tumapel No. 1 Bojonegoro',
    phone: '082228911677',
    email: 'satpolkabbjn@gmail.com',
  ),
  const InstansiItem(
    id: 'dinas_p3akb',
    name: 'DINAS PEMBERDAYAAN PEREMPUAN, PERLINDUNGAN ANAK DAN KELUARGA BERENCANA',
    category: 'DINAS',
    address: 'Jln. Pattimura No. 01 Bojonegoro',
    phone: '(0353) 889515',
    email: 'dp3akb@bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_dukcapil',
    name: 'DINAS KEPENDUDUKAN DAN PENCATATAN SIPIL',
    category: 'DINAS',
    address: 'Jl. Patimura 26 A Bojonegoro',
    phone: '(0353) 881256',
    whatsapp: '085771440833 (KTP/KK) | 081249827497 (Akta) | 081388168631 (Konsultasi)',
    email: 'dinasdukcapil@bojonegorokab.go.id / dispendukcapilbjn@gmail.com',
    website: 'disdukcapil.bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_pmd',
    name: 'DINAS PEMBERDAYAAN MASYARAKAT DAN DESA',
    category: 'DINAS',
    address: 'Jln. Panglima Sudirman No. 161 Kelurahan Klangon Kecamatan Bojonegoro',
    phone: '(0353) 881512',
    email: 'dinpmd@bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_perhubungan',
    name: 'DINAS PERHUBUNGAN',
    category: 'DINAS',
    address: 'Jalan Pattimura No.36 A Bojonegoro',
    phone: '(0353) 885219',
    email: 'dishubbjn@gmail.com',
    website: 'dishub.bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_kominfo',
    name: 'DINAS KOMUNIKASI DAN INFORMATIKA',
    category: 'DINAS',
    address: 'Jl. P. Mas Tumapel No. 1 Bojonegoro Gedung Pemkab Lantai 3',
    phone: '(0353) 881826',
    email: 'dinkominfo@bojonegorokab.go.id',
    website: 'diskominfo.bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_dispora',
    name: 'DINAS KEPEMUDAAN DAN OLAHRAGA',
    category: 'DINAS',
    address: 'Jl. Pattimura No. 36 Bojonegoro (IG: @dinpora_bojonegoro)',
    phone: '(0353) 881257',
    email: 'disporabjn@gmail.com',
  ),
  const InstansiItem(
    id: 'dinas_dpmptsp',
    name: 'DINAS PENANAMAN MODAL DAN PELAYANAN TERPADU SATU PINTU',
    category: 'DINAS',
    address: 'Mal Pelayanan Publik, Jl. Veteran No. 227, Bojonegoro 62119',
    phone: '(0353) 525 6661',
    whatsapp: '082233099988',
    email: 'dpmptsp@bojonegorokab.go.id, dpmptsp.kabbjn@gmail.com',
    website: 'dpmptsp.bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_perpustakaan',
    name: 'DINAS PERPUSTAKAAN DAN KEARSIPAN',
    category: 'DINAS',
    address: 'Jl Patimura no. 1A Bojonegoro',
    phone: '(0353) 891907',
    email: 'perpus.arsip.bjn@gmail.com',
  ),
  const InstansiItem(
    id: 'dinas_lh',
    name: 'DINAS LINGKUNGAN HIDUP',
    category: 'DINAS',
    address: 'Jl. Dr. Wahidin No.40 Bojonegoro - Jawa Timur',
    phone: '081359241645',
    whatsapp: '081359241645',
    email: 'dlh.bojonegoro@gmail.com',
  ),
  const InstansiItem(
    id: 'dinas_disnaker',
    name: 'DINAS PERINDUSTRIAN DAN TENAGA KERJA',
    category: 'DINAS',
    address: 'Jl. Patimura No.10, Sumbang, Kec. Bojonegoro, Kabupaten Bojonegoro, Jawa Timur 62115',
    phone: '(0353) 881900',
    email: 'disnaker@bojonegorokab.go.id',
    website: 'disnaker.bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_disbudpar',
    name: 'DINAS KEBUDAYAAN DAN PARIWISATA',
    category: 'DINAS',
    address: 'Jl. Teuku Umar No. 80 Bojonegoro',
    phone: '(0353) 881571',
    email: 'dinbudpar@bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_dagkop',
    name: 'DINAS PERDAGANGAN, KOPERASI DAN USAHA MIKRO',
    category: 'DINAS',
    address: 'Jl. Ahmad Yani Nomor 39 Kapas Kecamatan Bojonegoro Jawa Timur',
    phone: '(0353) 881089',
    email: 'dinasperdaganganbjn@gmail.com',
  ),
  const InstansiItem(
    id: 'dinas_pertanian',
    name: 'DINAS KETAHANAN PANGAN DAN PERTANIAN',
    category: 'DINAS',
    address: 'Jalan Raya Sukowati No. 412 Kapas, Bojonegoro',
    phone: '(0353) 881410',
    email: 'dinaspertanian@bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'dinas_peternakan',
    name: 'DINAS PETERNAKAN DAN PERIKANAN',
    category: 'DINAS',
    address: 'Jl. Basuki Rahmad No. 02 - Kode Pos 62115 - Kab. Bojonegoro - Prov. Jawa Timur',
    phone: '(0353) 881172',
    email: 'dinasnakkan@bojonegorokab.go.id',
  ),

  // SETDA
  const InstansiItem(
    id: 'setda_utama',
    name: 'Sekretariat Daerah (SETDA) Kab. Bojonegoro',
    category: 'SETDA',
    address: 'Jl. P. Mastrip No. 1, Kota Bojonegoro',
    phone: '(0353) 881001',
    email: 'setda@bojonegorokab.go.id',
    website: 'bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'setda_hukum',
    name: 'Bagian Hukum & HAM SETDA',
    category: 'SETDA',
    address: 'Gedung Pemkab Bojonegoro Lt. 3, Jl. P. Mastrip No. 1',
    phone: '(0353) 881002',
    email: 'hukum@bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'setda_organisasi',
    name: 'Bagian Organisasi SETDA',
    category: 'SETDA',
    address: 'Gedung Pemkab Bojonegoro Lt. 2, Jl. P. Mastrip No. 1',
    phone: '(0353) 881003',
    email: 'organisasi@bojonegorokab.go.id',
  ),

  // KECAMATAN
  const InstansiItem(
    id: 'kec_bojonegoro',
    name: 'Kantor Kecamatan Bojonegoro (Kota)',
    category: 'KECAMATAN',
    address: 'Jl. AKBP M. Soeroko No. 45, Kota Bojonegoro',
    phone: '(0353) 881100',
    email: 'kec.bojonegoro@bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'kec_balen',
    name: 'Kantor Kecamatan Balen',
    category: 'KECAMATAN',
    address: 'Jl. Raya Balen No. 12, Kec. Balen, Bojonegoro',
    phone: '(0353) 331122',
    email: 'kec.balen@bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'kec_kapas',
    name: 'Kantor Kecamatan Kapas',
    category: 'KECAMATAN',
    address: 'Jl. Raya Kapas No. 5, Kec. Kapas, Bojonegoro',
    phone: '(0353) 331133',
    email: 'kec.kapas@bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'kec_baureno',
    name: 'Kantor Kecamatan Baureno',
    category: 'KECAMATAN',
    address: 'Jl. Raya Baureno No. 88, Kec. Baureno, Bojonegoro',
    phone: '(0353) 331144',
    email: 'kec.baureno@bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'kec_kalitidu',
    name: 'Kantor Kecamatan Kalitidu',
    category: 'KECAMATAN',
    address: 'Jl. Raya Kalitidu No. 15, Kec. Kalitidu, Bojonegoro',
    phone: '(0353) 331155',
    email: 'kec.kalitidu@bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'kec_dander',
    name: 'Kantor Kecamatan Dander',
    category: 'KECAMATAN',
    address: 'Jl. Raya Dander No. 20, Kec. Dander, Bojonegoro',
    phone: '(0353) 331166',
    email: 'kec.dander@bojonegorokab.go.id',
  ),
  const InstansiItem(
    id: 'kec_padangan',
    name: 'Kantor Kecamatan Padangan',
    category: 'KECAMATAN',
    address: 'Jl. Raya Padangan No. 99, Kec. Padangan, Bojonegoro',
    phone: '(0353) 331177',
    email: 'kec.padangan@bojonegorokab.go.id',
  ),

  // RSUD
  const InstansiItem(
    id: 'rsud_sosodoro',
    name: 'RSUD dr. R. Sosodoro Djatikoesoemo',
    category: 'RSUD',
    address: 'Jl. Veteran No. 36, Kota Bojonegoro',
    phone: '(0353) 881193',
    whatsapp: '081132277119',
    email: 'rsud.sosodoro@bojonegorokab.go.id',
    website: 'rsudbojonegoro.com',
    operationalHours: '24 Jam Nonstop (UGD & Rawat Inap)',
  ),
  const InstansiItem(
    id: 'rsud_padangan',
    name: 'RSUD Padangan Bojonegoro',
    category: 'RSUD',
    address: 'Jl. Raya Padangan-Ngawi No. 1, Kec. Padangan',
    phone: '(0353) 531122',
    email: 'rsudpadangan@bojonegorokab.go.id',
    website: 'rsudpadangan.bojonegorokab.go.id',
    operationalHours: '24 Jam Nonstop (UGD & Rawat Inap)',
  ),
  const InstansiItem(
    id: 'rsud_sumberrejo',
    name: 'RSUD Sumberrejo Bojonegoro',
    category: 'RSUD',
    address: 'Jl. Raya Sumberrejo No. 158, Kec. Sumberrejo',
    phone: '(0353) 351024',
    email: 'rsudsumberrejo@bojonegorokab.go.id',
    website: 'rsudsumberrejo.bojonegorokab.go.id',
    operationalHours: '24 Jam Nonstop (UGD & Rawat Inap)',
  ),

  // BUMD
  const InstansiItem(
    id: 'bumd_bank_daerah',
    name: 'BPR Bank Daerah Bojonegoro (Perseroda)',
    category: 'BUMD',
    address: 'Jl. Gajah Mada No. 10, Kota Bojonegoro',
    phone: '(0353) 881888',
    whatsapp: '081234567788',
    email: 'info@bankdaerahbojonegoro.co.id',
    website: 'bankdaerahbojonegoro.co.id',
  ),
  const InstansiItem(
    id: 'bumd_pdam',
    name: 'Perumda Air Minum Tirta Buana (PDAM)',
    category: 'BUMD',
    address: 'Jl. Rajawali No. 16, Kota Bojonegoro',
    phone: '(0353) 881515',
    whatsapp: '085231234567',
    email: 'pdambojonegoro@gmail.com',
    website: 'pdambojonegoro.co.id',
    operationalHours: 'Senin - Sabtu: 07.30 - 16.00 WIB',
  ),
  const InstansiItem(
    id: 'bumd_ads',
    name: 'PT Asri Dharma Sejahtera (ADS)',
    category: 'BUMD',
    address: 'Jl. Veteran No. 8, Kota Bojonegoro',
    phone: '(0353) 887766',
    email: 'info@ads-bojonegoro.co.id',
  ),

  // SETWAN
  const InstansiItem(
    id: 'setwan',
    name: 'Sekretariat DPRD (SETWAN) Kab. Bojonegoro',
    category: 'SETWAN',
    address: 'Jl. Trunojoyo No. 35, Kota Bojonegoro',
    phone: '(0353) 881050',
    email: 'dprd@bojonegorokab.go.id',
    website: 'dprd.bojonegorokab.go.id',
  ),
];

class KontakInstansiScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const KontakInstansiScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<KontakInstansiScreen> createState() => _KontakInstansiScreenState();
}

class _KontakInstansiScreenState extends State<KontakInstansiScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory; // null = Category Selection View

  final List<Map<String, dynamic>> _govCategories = [
    {
      'code': 'BADAN',
      'name': 'BADAN',
      'icon': Icons.business_rounded,
      'color': const Color(0xFF2563EB),
      'lightBg': const Color(0xFFEFF6FF),
      'darkBg': const Color(0xFF172554),
    },
    {
      'code': 'DINAS',
      'name': 'DINAS',
      'icon': Icons.account_balance_rounded,
      'color': const Color(0xFF4F46E5),
      'lightBg': const Color(0xFFEEF2FF),
      'darkBg': const Color(0xFF1E1B4B),
    },
    {
      'code': 'SETDA',
      'name': 'SETDA',
      'icon': Icons.location_city_rounded,
      'color': const Color(0xFF8B5CF6),
      'lightBg': const Color(0xFFF5F3FF),
      'darkBg': const Color(0xFF2E1065),
    },
    {
      'code': 'KECAMATAN',
      'name': 'KECAMATAN',
      'icon': Icons.storefront_rounded,
      'color': const Color(0xFF0D9488),
      'lightBg': const Color(0xFFF0FDF4),
      'darkBg': const Color(0xFF064E3B),
    },
    {
      'code': 'RSUD',
      'name': 'RSUD',
      'icon': Icons.medical_services_rounded,
      'color': const Color(0xFFEF4444),
      'lightBg': const Color(0xFFFEF2F2),
      'darkBg': const Color(0xFF450A0A),
    },
    {
      'code': 'BUMD',
      'name': 'BUMD',
      'icon': Icons.corporate_fare_rounded,
      'color': const Color(0xFFF59E0B),
      'lightBg': const Color(0xFFFFFBEB),
      'darkBg': const Color(0xFF451A03),
    },
    {
      'code': 'SETWAN',
      'name': 'SETWAN',
      'icon': Icons.gavel_rounded,
      'color': const Color(0xFF0284C7),
      'lightBg': const Color(0xFFF0F9FF),
      'darkBg': const Color(0xFF0C4A6E),
    },
    {
      'code': 'DARURAT',
      'name': 'DARURAT 112',
      'icon': Icons.notifications_active_rounded,
      'color': const Color(0xFFDC2626),
      'lightBg': const Color(0xFFFEF2F2),
      'darkBg': const Color(0xFF450A0A),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<InstansiItem> get _filteredList {
    return sampleInstansiList.where((item) {
      final matchesCategory = _selectedCategory == null || item.category == _selectedCategory;
      final matchesQuery = _searchQuery.trim().isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.address.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> _makePhoneCall(BuildContext context, String phone) async {
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

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menghubungi $phone...')),
      );
    }
  }

  Future<void> _openWhatsApp(BuildContext context, String phone) async {
    var cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '62${cleanPhone.substring(1)}';
    }
    final message = Uri.encodeComponent('Halo, saya ingin bertanya seputar layanan publik Pemkab Bojonegoro.');
    final Uri url = Uri.parse('https://wa.me/$cleanPhone?text=$message');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', 'https://wa.me/$cleanPhone']);
        return;
      } catch (_) {}
    }
  }

  Future<void> _openEmail(BuildContext context, String email) async {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty) return;
    final Uri url = Uri.parse('mailto:$cleanEmail');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        return;
      }
    } catch (_) {}
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

  void _showInstansiContactModal(BuildContext context, InstansiItem item, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (item.operationalHours.isNotEmpty)
                  Text(
                    item.operationalHours,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.name,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_rounded, size: 18, color: Color(0xFF2563EB)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.address,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'PILIH OPSION KONTAK',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                if (item.phone.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _makePhoneCall(context, item.phone);
                      },
                      icon: const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
                      label: Text('Panggil Telepon: ${item.phone}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                if (item.whatsapp.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _openWhatsApp(context, item.whatsapp);
                      },
                      icon: const Icon(Icons.chat_rounded, color: Colors.white, size: 18),
                      label: Text('Chat WhatsApp: ${item.whatsapp}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                if (item.email.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _openEmail(context, item.email);
                      },
                      icon: const Icon(Icons.email_rounded, color: Color(0xFF2563EB), size: 18),
                      label: Text('Kirim Email: ${item.email}', style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(color: Color(0xFF2563EB)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                if (item.website.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _openWebsite(item.website);
                      },
                      icon: const Icon(Icons.language_rounded, color: Color(0xFF0D9488), size: 18),
                      label: Text('Kunjungi Situs Web: ${item.website}', style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold, fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(color: Color(0xFF0D9488)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final double topPadding = MediaQuery.of(context).padding.top;
    final bool isShowingList = _selectedCategory != null || _searchQuery.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header Bar
          Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16, (topPadding > 0 ? topPadding : 16) + 4, 16, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? const [
                            Color(0xFF0F172A),
                            Color(0xFF1E1B4B),
                            Color(0xFF1E293B),
                          ]
                        : const [
                            Color(0xFF1E3A8A),
                            Color(0xFF1D4ED8),
                            Color(0xFF2563EB),
                          ],
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1D4ED8).withAlpha(70),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                              onPressed: () {
                                if (isShowingList) {
                                  setState(() {
                                    _selectedCategory = null;
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _selectedCategory != null ? 'Direktori $_selectedCategory' : 'Layanan Kontak Instansi',
                              style: const TextStyle(
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
                            isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
                            color: isDark ? Colors.amber : Colors.white,
                            size: 22,
                          ),
                          onPressed: () {
                            if (widget.onToggleDarkMode != null) {
                              widget.onToggleDarkMode!();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        _selectedCategory != null
                            ? 'Daftar kontak instansi resmi kategori $_selectedCategory'
                            : 'Pilih kategori instansi pemerintah Kab. Bojonegoro di bawah',
                        style: TextStyle(
                          color: Colors.white.withAlpha(220),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Bar Input
                    Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Cari instansi (Dinas, Badan, RSUD, Kecamatan...)...',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.5),
                          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF2563EB)),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18, color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -20,
                top: 10,
                child: IgnorePointer(
                  child: Icon(
                    Icons.account_balance_rounded,
                    size: 130,
                    color: Colors.white.withAlpha(15),
                  ),
                ),
              ),
            ],
          ),

          // Main View Content
          Expanded(
            child: isShowingList
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _selectedCategory = null;
                                        _searchController.clear();
                                        _searchQuery = '';
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_back_rounded, size: 16, color: Colors.white),
                                    label: const Text('Kembali ke Menu Kategori', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2563EB),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${_filteredList.length} Instansi',
                                    style: TextStyle(
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              if (_selectedCategory != null) ...[
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        _selectedCategory == 'DINAS'
                                            ? 'DINAS KABUPATEN BOJONEGORO'
                                            : 'KABUPATEN BOJONEGORO - $_selectedCategory',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        width: 48,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2563EB),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ],
                          ),
                        ),

                        if (_filteredList.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.withAlpha(150)),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Instansi tidak ditemukan',
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Coba sesuaikan kata kunci pencarian Anda',
                                    style: TextStyle(color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _filteredList.length,
                              itemBuilder: (context, index) {
                                final item = _filteredList[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: InkWell(
                                    onTap: () => _showInstansiContactModal(context, item, isDark),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF4F8),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.play_arrow_outlined, color: Color(0xFF2563EB), size: 20),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Text(
                                              item.name,
                                              style: TextStyle(
                                                color: isDark ? Colors.white : const Color(0xFF1E293B),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final availableHeight = constraints.maxHeight;
                      const double padding = 20.0;
                      const double spacing = 12.0;
                      const double headerHeight = 36.0;

                      final availableGridHeight = availableHeight - headerHeight - (padding * 2);
                      const int rowCount = 4;
                      final cardHeight = (availableGridHeight - (spacing * (rowCount - 1))) / rowCount;
                      final cardWidth = (constraints.maxWidth - (padding * 2) - spacing) / 2;
                      final computedRatio = (cardHeight > 0 && cardWidth > 0) ? (cardWidth / cardHeight) : 1.35;

                      return Padding(
                        padding: const EdgeInsets.all(padding),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(width: 24, height: 2, color: const Color(0xFF2563EB)),
                                const SizedBox(width: 8),
                                Text(
                                  'PEMERINTAHAN',
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(width: 24, height: 2, color: const Color(0xFF2563EB)),
                              ],
                            ),
                            const SizedBox(height: 14),

                            Expanded(
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _govCategories.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: spacing,
                                  mainAxisSpacing: spacing,
                                  childAspectRatio: computedRatio,
                                ),
                                itemBuilder: (context, index) {
                                  final cat = _govCategories[index];
                                  final Color catColor = cat['color'] as Color;
                                  final Color lightBg = cat['lightBg'] as Color;
                                  final Color darkBg = cat['darkBg'] as Color;
                                  final isDarurat = cat['code'] == 'DARURAT';
                                  final count = isDarurat ? 24 : sampleInstansiList.where((item) => item.category == cat['code']).length;

                                  return InkWell(
                                    onTap: () {
                                      if (isDarurat) {
                                        _makePhoneCall(context, '112');
                                      } else {
                                        setState(() {
                                          _selectedCategory = cat['code'] as String;
                                        });
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(22),
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(
                                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                          width: 1.2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: catColor.withAlpha(20),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Centered Glowing Circular Icon Badge
                                          Container(
                                            width: 52,
                                            height: 52,
                                            decoration: BoxDecoration(
                                              color: isDark ? darkBg.withAlpha(180) : lightBg,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: catColor.withAlpha(60), width: 1.2),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: catColor.withAlpha(40),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Icon(cat['icon'] as IconData, color: catColor, size: 26),
                                            ),
                                          ),
                                          const SizedBox(height: 10),

                                          // Centered Title Only
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                cat['name'] as String,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
