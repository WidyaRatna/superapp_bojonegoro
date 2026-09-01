import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

/// Models for Admin Modules Data Management

class ItemKependudukan {
  final String id;
  String title;
  String category;
  String description;
  String pdfFileName;
  String pdfUrl;
  bool isPublished;

  ItemKependudukan({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    this.pdfFileName = 'Panduan_Syarat.pdf',
    this.pdfUrl = '',
    this.isPublished = true,
  });
}

class ItemBeasiswa {
  final String id;
  String title;
  String provider;
  String quota;
  String deadline;
  String pdfFileName;
  String imageUrl;
  bool isPublished;

  ItemBeasiswa({
    required this.id,
    required this.title,
    required this.provider,
    required this.quota,
    required this.deadline,
    this.pdfFileName = 'Brosur_Persyaratan_Beasiswa.pdf',
    this.imageUrl = 'assets/images/brosur_beasiswa.png',
    this.isPublished = true,
  });
}

class ItemPerpustakaan {
  final String id;
  String title;
  String author;
  String category;
  String stock;
  String description;
  String pdfFileName;
  String coverUrl;
  bool isPublished;

  ItemPerpustakaan({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.stock,
    required this.description,
    this.pdfFileName = 'Katalog_E_Book_Perpustakaan.pdf',
    this.coverUrl = '',
    this.isPublished = true,
  });
}

class ItemPertanian {
  final String id;
  String name;
  String type;
  String price;
  String requirements;
  String mechanism;
  bool isPublished;

  ItemPertanian({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.requirements,
    required this.mechanism,
    this.isPublished = true,
  });
}

class ItemPariwisata {
  final String id;
  String name;
  String category; // 'rekreasi', 'sejarah_budaya', 'religi'
  String categoryLabel;
  String description;
  String address;
  String openHours;
  String price;
  String rating;
  List<String> facilities;
  String imageUrl;
  String? imagePath;
  String mapQuery;
  String? transportInfo;
  List<String>? tips;
  bool isPublished;

  ItemPariwisata({
    required this.id,
    required this.name,
    this.category = 'rekreasi',
    this.categoryLabel = 'Rekreasi Alam',
    required this.description,
    required this.address,
    this.openHours = '24 Jam (Setiap Hari)',
    required this.price,
    this.rating = '4.7',
    required this.facilities,
    required this.imageUrl,
    this.imagePath,
    this.mapQuery = 'Bojonegoro',
    this.transportInfo,
    this.tips,
    this.isPublished = true,
  });

  String get location => address;
  set location(String val) => address = val;

  String get title => name;
  set title(String val) => name = val;

  String get ticketPrice => price;
  set ticketPrice(String val) => price = val;
}

class ItemPajak {
  final String id;
  String title;
  String subtitle;
  String categoryTag;
  String webUrl;
  String badgeText;
  String fullDescription;
  bool isPublished;

  ItemPajak({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryTag,
    required this.webUrl,
    required this.badgeText,
    required this.fullDescription,
    this.isPublished = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'categoryTag': categoryTag,
        'webUrl': webUrl,
        'badgeText': badgeText,
        'fullDescription': fullDescription,
        'isPublished': isPublished,
      };

  factory ItemPajak.fromJson(Map<String, dynamic> json) => ItemPajak(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        subtitle: json['subtitle'] ?? '',
        categoryTag: json['categoryTag'] ?? '',
        webUrl: json['webUrl'] ?? '',
        badgeText: json['badgeText'] ?? '',
        fullDescription: json['fullDescription'] ?? '',
        isPublished: json['isPublished'] ?? true,
      );
}

class ItemSopLapor {
  final String id;
  String title;
  String category;
  String sopText;
  String pdfFileName;

  ItemSopLapor({
    required this.id,
    required this.title,
    required this.category,
    required this.sopText,
    this.pdfFileName = 'SOP_Pengaduan_Masyarakat_Bojonegoro.pdf',
  });
}

class DpmptspSopStep {
  final String id;
  String stepNumber;
  String role;
  String duration;
  String output;
  String description;

  DpmptspSopStep({
    required this.id,
    required this.stepNumber,
    required this.role,
    required this.duration,
    required this.output,
    required this.description,
  });
}


class ItemLaporanWarga {
  final String id;
  String category;
  String title;
  String description;
  String reporterName;
  String reporterPhone;
  String location;
  String photoSource;
  String status; // 'Menunggu', 'Diproses', 'Selesai', 'Ditolak'
  String dateStr;
  String adminNote;

  ItemLaporanWarga({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.reporterName,
    required this.reporterPhone,
    required this.location,
    this.photoSource = 'Kamera Perangkat',
    this.status = 'Menunggu',
    required this.dateStr,
    this.adminNote = '',
  });
}

class ItemKontakInstansi {
  final String id;
  String agencyName;
  String address;
  String phone;
  String email;
  String operatingHours;

  ItemKontakInstansi({
    required this.id,
    required this.agencyName,
    required this.address,
    required this.phone,
    required this.email,
    required this.operatingHours,
  });
}

class ItemEmergencyCall {
  final String id;
  String serviceName;
  String hotline;
  String category;
  String description;

  ItemEmergencyCall({
    required this.id,
    required this.serviceName,
    required this.hotline,
    required this.category,
    required this.description,
  });
}

class ItemLokerAdmin {
  final String id;
  String title;
  String company;
  String location;
  String salary;
  String category;
  String status; // 'Menunggu Verifikasi', 'Terverifikasi', 'Ditolak'
  String postedDate;
  String description;
  String contactPhone;

  ItemLokerAdmin({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.category,
    required this.status,
    required this.postedDate,
    this.description = 'Membutuhkan tenaga kerja profesional yang kompeten dan berintegritas.',
    this.contactPhone = '081234567890',
  });

  String get companyName => company;
  set companyName(String val) => company = val;

  String get salaryRange => salary;
  set salaryRange(String val) => salary = val;
}

class ItemLayananSosial {
  final String id;
  String title;
  String category;
  String description;
  String requirement;
  String mechanism;
  String pdfFileName;
  bool isPublished;

  ItemLayananSosial({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.requirement,
    required this.mechanism,
    this.pdfFileName = 'Persyaratan_Bantuan_Sosial.pdf',
    this.isPublished = true,
  });
}

class ItemPerhubungan {
  final String id;
  String title;
  String description;
  String category;
  String urlStr;
  String phoneNumber;
  IconData icon;

  ItemPerhubungan({
    required this.id,
    required this.title,
    required this.description,
    this.category = 'Layanan Utama',
    this.urlStr = '',
    this.phoneNumber = '',
    this.icon = Icons.directions_bus_outlined,
  });
}

class ItemBeritaAdmin {
  final String id;
  String title;
  String category;
  String date;
  String author;
  String content;
  String imageUrl;
  String status; // 'Published', 'Draft'

  ItemBeritaAdmin({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.author,
    required this.content,
    required this.imageUrl,
    required this.status,
  });
}

class AdminActivityLog {
  final String timestamp;
  final String action;
  final String module;
  final String adminName;

  AdminActivityLog({
    required this.timestamp,
    required this.action,
    required this.module,
    required this.adminName,
  });
}

/// Central State & Data Engine for Admin Dashboard and User Sync
class AdminDataService extends ChangeNotifier {
  static final AdminDataService _instance = AdminDataService._internal();
  factory AdminDataService() => _instance;

  AdminDataService._internal() {
    _initDefaultData();
    _loadPajakFromStorage();
  }

  // Datasets
  final List<ItemKependudukan> _kependudukanList = [];
  final List<ItemBeasiswa> _beasiswaList = [];
  final List<ItemPerpustakaan> _perpustakaanList = [];
  final List<ItemPertanian> _pertanianList = [];
  final List<ItemPariwisata> _pariwisataList = [];
  final List<ItemSopLapor> _laporSopList = [];
  final List<ItemLaporanWarga> _laporanWargaList = [];
  final List<ItemKontakInstansi> _kontakInstansiList = [];
  final List<ItemEmergencyCall> _emergencyList = [];
  final List<ItemLokerAdmin> _lokerList = [];
  final List<ItemLayananSosial> _layananSosialList = [];
  final List<ItemPerhubungan> _perhubunganList = [];
  final List<ItemBeritaAdmin> _beritaList = [];
  final List<AdminActivityLog> _activityLogs = [];

  // Getters
  List<ItemKependudukan> get kependudukanList => List.unmodifiable(_kependudukanList);
  List<ItemBeasiswa> get beasiswaList => List.unmodifiable(_beasiswaList);
  List<ItemPerpustakaan> get perpustakaanList => List.unmodifiable(_perpustakaanList);
  List<ItemPertanian> get pertanianList => List.unmodifiable(_pertanianList);
  List<ItemPariwisata> get pariwisataList => List.unmodifiable(_pariwisataList);
  List<ItemSopLapor> get laporSopList => List.unmodifiable(_laporSopList);
  List<ItemLaporanWarga> get laporanWargaList => List.unmodifiable(_laporanWargaList);
  List<ItemKontakInstansi> get kontakInstansiList => List.unmodifiable(_kontakInstansiList);
  List<ItemEmergencyCall> get emergencyList => List.unmodifiable(_emergencyList);
  List<ItemLokerAdmin> get lokerList => List.unmodifiable(_lokerList);
  List<ItemLayananSosial> get layananSosialList =>
      List.unmodifiable(_layananSosialList.where((e) => e.id != 'SOS-003' && e.id != 'SOS-004'));
  List<ItemPerhubungan> get perhubunganList => List.unmodifiable(_perhubunganList);
  List<ItemBeritaAdmin> get beritaList => List.unmodifiable(_beritaList);
  List<AdminActivityLog> get activityLogs => List.unmodifiable(_activityLogs);

  // User Filtered Getters
  List<ItemLokerAdmin> get verifiedLokerList =>
      _lokerList.where((item) => item.status == 'Terverifikasi').toList();

  List<ItemBeritaAdmin> get publishedBeritaList =>
      _beritaList.where((item) => item.status == 'Published').toList();

  // Overview Dashboard Statistics
  int get totalUsers => 142850;
  int get totalServices => 48;
  int get totalNews => _beritaList.length;
  int get totalJobs => _lokerList.length;
  int get totalReports => 342;
  int get pendingJobVerifications =>
      _lokerList.where((item) => item.status == 'Menunggu Verifikasi').length;

  void _logActivity(String action, String module) {
    _activityLogs.insert(
      0,
      AdminActivityLog(
        timestamp: DateTime.now().toString().substring(0, 16),
        action: action,
        module: module,
        adminName: 'Admin Diskominfo',
      ),
    );
    if (_activityLogs.length > 50) _activityLogs.removeLast();
  }

  void _initDefaultData() {
    // 1. Kependudukan Initial Data
    _kependudukanList.addAll([
      ItemKependudukan(
        id: 'KPD-001',
        title: 'Pembuatan KTP Elektronik (e-KTP)',
        category: 'Identitas',
        description: 'Layanan penerbitan KTP-el baru bagi warga yang berusia 17 tahun atau sudah menikah.',
        pdfFileName: 'Syarat_Pembuatan_eKTP.pdf',
      ),
      ItemKependudukan(
        id: 'KPD-002',
        title: 'Penerbitan Kartu Keluarga (KK) Baru',
        category: 'Keluarga',
        description: 'Penerbitan Kartu Keluarga baru karena pernikahan, pecahan KK, atau pindah datang.',
        pdfFileName: 'Syarat_Kartu_Keluarga.pdf',
      ),
      ItemKependudukan(
        id: 'KPD-003',
        title: 'Akta Kelahiran Anak',
        category: 'Pencatatan Sipil',
        description: 'Pencatatan dan penerbitan kutipan akta kelahiran anak baru lahir.',
        pdfFileName: 'Syarat_Akta_Kelahiran.pdf',
      ),
      ItemKependudukan(
        id: 'KPD-004',
        title: 'Kartu Identitas Anak (KIA)',
        category: 'Identitas Anak',
        description: 'Penerbitan Kartu Identitas Anak bagi anak berusia 0 - 17 tahun kurang satu hari.',
        pdfFileName: 'Syarat_Kartu_Identitas_Anak.pdf',
      ),
      ItemKependudukan(
        id: 'KPD-005',
        title: 'Akta Kematian',
        category: 'Pencatatan Sipil',
        description: 'Penerbitan akta kematian bagi warga meninggal dunia di wilayah Kab. Bojonegoro.',
        pdfFileName: 'Syarat_Akta_Kematian.pdf',
      ),
      ItemKependudukan(
        id: 'KPD-006',
        title: 'Surat Pindah Datang (SKPWNI)',
        category: 'Pindah Datang',
        description: 'Pengurusan surat keterangan pindah antar desa/kecamatan/kabupaten.',
        pdfFileName: 'Syarat_Pindah_Datang.pdf',
      ),
    ]);

    // 2. Beasiswa Initial Data
    _beasiswaList.addAll([
      ItemBeasiswa(
        id: 'BSW-001',
        title: 'Beasiswa Scientist Pemkab Bojonegoro 2026',
        provider: 'Dinas Pendidikan Bojonegoro',
        quota: '500 Mahasiswa',
        deadline: '30 September 2026',
        pdfFileName: 'Syarat_Beasiswa_Scientist.pdf',
      ),
      ItemBeasiswa(
        id: 'BSW-002',
        title: 'Beasiswa Dua Sarjana Satu Desa',
        provider: 'Pemkab Bojonegoro',
        quota: '860 Mahasiswa',
        deadline: '15 Oktober 2026',
        pdfFileName: 'Panduan_Dua_Sarjana.pdf',
      ),
      ItemBeasiswa(
        id: 'BSW-003',
        title: 'Beasiswa Pondok Pesantren',
        provider: 'Dinas Pendidikan Bojonegoro',
        quota: '350 Mahasiswa',
        deadline: '20 November 2026',
        pdfFileName: 'Syarat_Beasiswa_Pesantren.pdf',
      ),
      ItemBeasiswa(
        id: 'BSW-004',
        title: 'Beasiswa Keluarga Miskin',
        provider: 'Pemkab Bojonegoro & Dinsos',
        quota: '1.200 Mahasiswa',
        deadline: '10 November 2026',
        pdfFileName: 'Syarat_Beasiswa_Miskin.pdf',
      ),
      ItemBeasiswa(
        id: 'BSW-005',
        title: 'Beasiswa Tugas Akhir',
        provider: 'Dinas Pendidikan Bojonegoro',
        quota: '400 Mahasiswa',
        deadline: '30 November 2026',
        pdfFileName: 'Syarat_Beasiswa_TugasAkhir.pdf',
      ),
      ItemBeasiswa(
        id: 'BSW-006',
        title: 'Sepuluh Sarjana per Desa',
        provider: 'Pemkab Bojonegoro',
        quota: '4.300 Mahasiswa',
        deadline: '15 Desember 2026',
        pdfFileName: 'Panduan_10_Sarjana_Desa.pdf',
      ),
    ]);

    // 2b. Perpustakaan Initial Data
    _perpustakaanList.addAll([
      ItemPerpustakaan(
        id: 'PRP-001',
        title: 'Katalog E-Book E-MAOS Bojonegoro',
        author: 'Dinas Perpustakaan & Kearsipan Bojonegoro',
        category: 'E-Book / Digital',
        stock: '12.500 Judul',
        description: 'Layanan peminjaman dan baca buku digital gratis via aplikasi E-MAOS Bojonegoro.',
        pdfFileName: 'Panduan_Aplikasi_EMAOS.pdf',
      ),
      ItemPerpustakaan(
        id: 'PRP-002',
        title: 'Sejarah & Kebudayaan Bojonegoro',
        author: 'Tim Sejarah Pemkab Bojonegoro',
        category: 'Sejarah Lokal',
        stock: '150 Eksemplar',
        description: 'Buku referensi sejarah asal usul Kabupaten Bojonegoro, Khayangan Api, & Watu Ondo.',
        pdfFileName: 'Buku_Sejarah_Bojonegoro.pdf',
      ),
      ItemPerpustakaan(
        id: 'PRP-003',
        title: 'Ensiklopedi Pertanian & Ketahanan Pangan',
        author: 'Dinas Ketahanan Pangan Bojonegoro',
        category: 'Sains & Pertanian',
        stock: '85 Eksemplar',
        description: 'Panduan budidaya padi unggul dan pengelolaan lahan kering di Bojonegoro.',
        pdfFileName: 'Ensiklopedi_Pertanian_Bojonegoro.pdf',
      ),
    ]);

    // 3. Pertanian Initial Data
    _pertanianList.addAll([
      ItemPertanian(
        id: 'PRT-001',
        name: 'Pupuk UREA Subsidized',
        type: 'Nitrogen (N)',
        price: 'Rp 2.250 / kg',
        requirements: 'Terdaftar di e-RDKK & Memiliki Kartu Tani Bojonegoro',
        mechanism: 'Penebusan melalui Kios Pupuk Lengkap (KPL) terdekat.',
      ),
      ItemPertanian(
        id: 'PRT-002',
        name: 'Pupuk NPK Phonska Subsidized',
        type: 'Majemuk (NPK)',
        price: 'Rp 2.300 / kg',
        requirements: 'Terdaftar e-RDKK alokasi sektor tanaman pangan',
        mechanism: 'Tunjukkan KTP dan Kartu Tani resmi di KPL desa.',
      ),
    ]);

    // 4. Pariwisata Initial Data (3 Categories: Tempat Rekreasi, Sejarah & Budaya, Wisata Religi)
    _pariwisataList.addAll([
      // === TEMPAT REKREASI ===
      ItemPariwisata(
        id: 'kayangan_api',
        name: 'Wisata Kayangan Api',
        category: 'rekreasi',
        categoryLabel: 'Rekreasi Alam & Geowisata',
        description:
            'Fenomena geologi api abadi yang tak pernah padam sejak zaman Kerajaan Majapahit, dikelilingi hutan jati alami yang asri dan sejuk. Tempat bersejarah bertapa Mbah Kriyo Kusumo.',
        address: 'Jl. Khayangan Api, Ngembul, Sendangharjo, Kec. Ngasem, Kabupaten Bojonegoro, Jawa Timur 62171',
        openHours: '24 Jam (Setiap Hari)',
        price: 'Rp 8.500,- per orang',
        rating: '4.7',
        facilities: ['Pendopo Santai', 'Gazebo', 'Spot Foto Api Abadi', 'Warung Kuliner Khas', 'Area Parkir Luas', 'Toilet Umum'],
        mapQuery: 'https://maps.app.goo.gl/Q7kBMtn6da8vgG7v5',
        imagePath: 'assets/images/Khayangan_Api.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?q=80&w=1000',
      ),
      ItemPariwisata(
        id: 'atas_angin',
        name: 'Wisata Negeri Atas Angin',
        category: 'rekreasi',
        categoryLabel: 'Panorama Alam & Bukit Cinta',
        description:
            'Destinasi wisata panorama perbukitan indah di Desa Deling. Populer dengan Bukit Cinta—tempat bertemunya Dewi Sekar Sari & Raden Atas Aji. Pilihan favorit untuk camping sunrise dan fotografi prewedding.',
        address: 'Desa Deling, Kec. Sekar, Kab. Bojonegoro (50 km / ±2 jam dari Kota Bojonegoro)',
        openHours: '24 Jam (Setiap Hari)',
        price: 'Rp 3.000 (Senin-Jumat), Rp 5.000 (Sabtu), Rp 6.000 (Minggu/Libur)',
        rating: '4.8',
        facilities: ['Bukit Cinta', 'Camping Ground Sunrise', 'Spot Foto Prewedding', 'Warung Makan & Minuman', 'Area Parkir'],
        mapQuery: 'https://maps.app.goo.gl/eHoXCVoChawwTvML6',
        imagePath: 'assets/images/Negeri_Atas_Angin.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=1000',
        transportInfo: 'Berjarak ±2 jam (50 km) dari Kota Bojonegoro. Dapat ditempuh dengan kendaraan pribadi via akses jalan yang sudah baik.',
        tips: [
          'Kunjungi menjelang pagi untuk menikmati keindahan panorama sunrise.',
          'Pastikan membawa air minum sebelum mendaki Bukit Cinta.',
          'Siapkan topi/payung penolong terik jika naik di atas jam 08.00 pagi.',
        ],
      ),
      ItemPariwisata(
        id: 'belimbing_ngringinrejo',
        name: 'Agrowisata Belimbing Ngringinrejo',
        category: 'rekreasi',
        categoryLabel: 'Agrowisata & Petik Buah',
        description:
            'Kawasan perkebunan belimbing manis unggulan Bojonegoro seluas 21 hektar. Pengunjung dapat memilih & memetik belimbing manis besar langsung dari pohonnya serta berburu olahan sirup, dodol, dan kerupuk belimbing.',
        address: 'Desa Ngringinrejo & Mojo, Kec. Kalitidu, Kab. Bojonegoro',
        openHours: '07.00 - 17.00 WIB',
        price: 'Rp 5.000 / orang',
        rating: '4.7',
        facilities: ['Petik Belimbing Langsung', 'Gazebo Kebun Teduh', 'Pusat Olahan Belimbing', 'Jalan Paving Kerap', 'Warung Ala Desa', 'Parkir Area'],
        mapQuery: 'https://maps.app.goo.gl/LJUh4TQ7YMwWkiM67',
        imagePath: 'assets/images/kebun_belimbing.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1596386461350-326ccb383e9f?q=80&w=1000',
        transportInfo: 'Berjarak ±15 km di sebelah barat Kota Bojonegoro.',
        tips: [
          'Petik dan nikmati buah belimbing manis besar langsung dari pohonnya.',
          'Cicipi oleh-oleh olahan lokal khas seperti sirup belimbing, dodol, dan kerupuk belimbing.',
        ],
      ),
      ItemPariwisata(
        id: 'gofun_bojonegoro',
        name: 'GoFun Entertainment Complex',
        category: 'rekreasi',
        categoryLabel: 'Taman Rekreasi Modern & Festival',
        description:
            'Taman hiburan keluarga modern terbesar di Bojonegoro. Menghadirkan wahana Kiddy Land, Bianglala Raksasa, Rumah Hantu, Gokart, hingga wahana air dan festival lampu warna-warni.',
        address: 'Jl. Veteran No.5200, Plelen, Ngampel, Kec. Kapas, Kabupaten Bojonegoro',
        openHours: '16.00 - 22.00 WIB (Selasa - Minggu)',
        price: 'Rp 25.000 - Rp 70.000',
        rating: '4.6',
        facilities: ['Kiddy Land & Bianglala', 'Gokart & Wahana Air', 'Rumah Hantu', 'Panggung Konser & Event', 'Food Court Kuliner', 'Parkir VIP'],
        mapQuery: 'https://maps.app.goo.gl/XnZGPju3W9xnCAqJA',
        imagePath: 'assets/images/gofun.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?q=80&w=1000',
      ),
      ItemPariwisata(
        id: 'bendungan_gerak',
        name: 'Bendungan Gerak Bojonegoro',
        category: 'rekreasi',
        categoryLabel: 'Pemandangan Air & Lanskap',
        description:
            'Bendungan megah penyangga air Sungai Bengawan Solo dengan jembatan sepanjang 504 meter penghubung Desa Padang & Ngringinrejo (Kalitidu). Tempat favorit warga menikmati sore.',
        address: 'Padang, Kec. Trucuk, Kabupaten Bojonegoro',
        openHours: '24 Jam (Setiap Hari)',
        price: 'Gratis',
        rating: '4.5',
        facilities: ['Jembatan Gerak 504m', 'Spot Panorama Bengawan Solo', 'Warung Ikan Wader Bakar', 'Taman & Area Santai', 'Area Jogging', 'Parkir Area'],
        mapQuery: 'https://maps.app.goo.gl/vwbPyAKQNVLbq2Bf9',
        imagePath: 'assets/images/bendungan gerak.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1000',
      ),
      ItemPariwisata(
        id: 'waduk_pacal',
        name: 'Waduk Pacal Temayang',
        category: 'rekreasi',
        categoryLabel: 'Danau & Sejarah Kolonial 1933',
        description:
            'Waduk megah peninggalan kolonial Belanda tahun 1933 seluas 3.878 hektar di Desa Kedungsumber. Menyajikan lanskap air luas dikelilingi hutan jati rindang & perbukitan hijau sejuk.',
        address: 'Desa Kedungsumber, Kec. Temayang, Kab. Bojonegoro (35 km dari kota)',
        openHours: '07.00 - 17.00 WIB',
        price: 'Rp 5.000 / orang',
        rating: '4.6',
        facilities: ['Sewa Perahu Keliling Waduk', 'Spot Memancing', 'Kuliner Warung Semok', 'Gazebo & Hutan Jati Teduh', 'Area Parkir'],
        mapQuery: 'https://maps.app.goo.gl/QLNrLhFSkx4voeSM9',
        imagePath: 'assets/images/waduk-pacal.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=1000',
      ),

      // === TEMPAT SEJARAH & BUDAYA ===
      ItemPariwisata(
        id: 'samin_bojonegoro',
        name: 'Masyarakat Adat Samin Bojonegoro',
        category: 'sejarah_budaya',
        categoryLabel: 'Budaya Wargi Samin & Sedulur Sikep',
        description:
            'Kawasan cagar budaya wargi Samin (Wong Sikep) keturunan pengikut Samin Surosentiko. Memegang teguh falsafah "Sedulur Sikep"—semangat kejujuran, keteguhan ajaran, kerukunan, serta kelestarian alam.',
        address: 'Dusun Jatiroto, Desa Japang, Kec. Margomulyo, Kabupaten Bojonegoro',
        openHours: '08.00 - 17.00 WIB',
        price: 'Gratis / Infaq Sukarela',
        rating: '4.8',
        facilities: ['Kampung Adat Samin', 'Rumah Tradisional Kayu', 'Informasi Sejarah Samin', 'Pemandu Budaya Lokal', 'Parkir Area'],
        mapQuery: 'https://maps.app.goo.gl/QQWxYtxddP842MsJ9',
        imagePath: 'assets/images/samin-bojonegoro.jpeg',
        imageUrl: 'https://images.unsplash.com/photo-1542810634-71277d95dcbb?q=80&w=1000',
      ),
      ItemPariwisata(
        id: 'museum_rajekwesi',
        name: 'Museum Rajekwesi Bojonegoro',
        category: 'sejarah_budaya',
        categoryLabel: 'Museum & Sejarah Purbakala',
        description:
            'Museum cagar budaya & edukasi sejarah di Jalan Pahlawan. Menampilkan 5 ruang pameran: Prasejarah & Fosil Purba, Artefak Hindu-Buddha, Etnografi, Gamelan & Wayang, serta Busana Adat.',
        address: 'Jl. Pahlawan No.9, Kepatihan, Kec. Bojonegoro, Kab. Bojonegoro',
        openHours: '09.00 - 16.00 WIB (Senin - Jumat)',
        price: 'Gratis (Tanpa Tiket)',
        rating: '4.7',
        facilities: ['Koleksi Prasejarah & Purba', 'Artefak Hindu-Buddha', 'Ruang Gamelan & Wayang', 'Ruang Imersif Cinema', 'Pemandu Museum Interaktif', 'Area Parkir'],
        mapQuery: 'Museum Rajekwesi Bojonegoro',
        imagePath: 'assets/images/Museum.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1566127444979-b3d2b654e3d7?q=80&w=1000',
      ),
      ItemPariwisata(
        id: 'teksas_wonocolo',
        name: 'Sumur Tua Teksas Wonocolo (Geopark)',
        category: 'sejarah_budaya',
        categoryLabel: 'Wisata Edukasi Migas & Petroleum Geopark',
        description:
            'Museum minyak bumi terbuka pertama di Indonesia berbasis geopark sumur minyak tua prasejarah peninggalan Belanda sejak abad ke-19 dengan rig kayu jati tradisional.',
        address: 'Desa Wonocolo, Kec. Kedewan, Kab. Bojonegoro (±60 km dari kota)',
        openHours: '08.00 - 17.00 WIB',
        price: 'Gratis / Retribusi Parkir',
        rating: '4.6',
        facilities: ['Rumah Singgah / Museum Migas', 'Wisata Offroad Jeep', '720 Sumur Minyak Tua', 'Gardu Pandang', 'Simulasi Pengeboran', 'Rest Area & Parkir'],
        mapQuery: 'Teksas Wonocolo Bojonegoro',
        imagePath: 'assets/images/Teksas Wonocolo.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=1000',
      ),

      // === WISATA RELIGI ===
      ItemPariwisata(
        id: 'wali_kidangan',
        name: 'Makam Wali Kidangan (Syeikh Mukodar)',
        category: 'religi',
        categoryLabel: 'Wisata Religi & Sejarah Islam Pajang',
        description:
            'Situs ziarah religi & cagar budaya di puncak Bukit Kidangan, tempat persemayaman Syeikh Mukodar (Raden Sentono / Pangeran Kumbang Ali-Ali), ulama besar keturunan Kasultanan Pajang.',
        address: 'Sukorejo, Kec. Malo, Kabupaten Bojonegoro',
        openHours: '24 Jam (Setiap Hari)',
        price: 'Gratis / Infaq Sukarela',
        rating: '4.9',
        facilities: ['500 Anak Tangga Pendakian', 'Pendopo Ziarah & Area Doa', 'Hutan Jati & Bambu Asri', 'Tempat Wudhu & Musholla', 'Warung Makanan', 'Area Parkir Luas'],
        mapQuery: 'Makam Wali Kidangan Malo Bojonegoro',
        imagePath: 'assets/images/Wali.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1542810634-71277d95dcbb?q=80&w=1000',
      ),
      ItemPariwisata(
        id: 'klenteng_hok_swie_bio',
        name: 'Klenteng Hok Swie Bio',
        category: 'religi',
        categoryLabel: 'Wisata Religi & Tempat Ibadah Tri Dharma',
        description:
            'Klenteng Hok Swie Bio adalah tempat ibadah Tri Dharma ikonik bersejarah di Bojonegoro yang didominasi warna merah khas dengan ornamen batu ukiran naga berkepala unik.',
        address: 'Jl. JAK Suprapto No. 127, Banjarejo, Kab. Bojonegoro',
        openHours: '07.00 - 17.00 WIB',
        price: 'Gratis',
        rating: '4.8',
        facilities: ['Area Ibadah Utama Tri Dharma', 'Ornamen Ukiran Naga', 'Kamar Penginapan Peziarah', 'Taman Klenteng Bersih', 'Spot Foto Arsitektur Kuno', 'Parkir Kendaraan'],
        mapQuery: 'Klenteng Hok Swie Bio Bojonegoro',
        imagePath: 'assets/images/kelenteng-hok-swie-bio.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1548013146-72479768bada?q=80&w=1000',
      ),
      ItemPariwisata(
        id: 'makam_jojonegoro',
        name: 'Makam Adipati Jojonegoro',
        category: 'religi',
        categoryLabel: 'Wisata Religi & Sejarah Pendiri Bojonegoro',
        description:
            'Kompleks makam bersejarah leluhur pendiri Bojonegoro, Adipati Djojonegoro (R.A.A. Djojonegoro) di Desa Mojoranu. Beliau berjasa menyatukan 3 wilayah kuno menjadi Kabupaten Rajegwesi.',
        address: 'Mojoranu, Kec. Dander, Kabupaten Bojonegoro',
        openHours: '08.00 - 16.00 WIB',
        price: 'Gratis / Infaq Sukarela',
        rating: '4.7',
        facilities: ['Pendopo Makam Leluhur', 'Area Ziarah & Doa', 'Catatan Sejarah Adipati', 'Area Parkir Kendaraan', 'Tempat Ibadah & Wudhu'],
        mapQuery: 'Makam Adipati Jojonegoro Bojonegoro',
        imagePath: 'assets/images/Makam_Adipati.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1596895111956-bf1cf0599ce5?q=80&w=1000',
      ),
      ItemPariwisata(
        id: 'masjid_agung_darussalam',
        name: 'Masjid Agung Darussalam Bojonegoro',
        category: 'religi',
        categoryLabel: 'Wisata Religi & Masjid Bersejarah (1825)',
        description:
            'Masjid tertua dan paling bersejarah di Kabupaten Bojonegoro yang didirikan sejak tahun 1825 di sebelah barat Alun-Alun Bojonegoro. Memiliki menara spiral artistik & pilar jati tua.',
        address: 'Jl. KH. Hasyim Asy\'ari No. 21, Kauman, Kec. Bojonegoro (Barat Alun-Alun)',
        openHours: '24 Jam (Setiap Hari)',
        price: 'Gratis',
        rating: '4.9',
        facilities: ['Ruang Ibadah 2 Lantai', 'Menara Spiral Unik', 'Pilar Jati Bersejarah (1825)', 'Interior Lampu Kristal', 'Tempat Wudhu & Toilet', 'Parkir Luas'],
        mapQuery: 'Masjid Agung Darussalam Bojonegoro',
        imagePath: 'assets/images/masjid-agung-darusalam-bojonegoro.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1542810634-71277d95dcbb?q=80&w=1000',
      ),
      ItemPariwisata(
        id: 'masjid_margomulyo',
        name: 'Masjid An Nahdla Margomulyo',
        category: 'religi',
        categoryLabel: 'Wisata Religi & Arsitektur Islami-Jawa',
        description:
            'Ikon wisata religi megah di perbatasan Bojonegoro-Ngawi memadukan keindahan arsitektur Aljaferia Andalusia dan ukiran Gebyok Jawa klasik dengan 9 tiang Wali Songo & 25 kubah Rasul.',
        address: 'Dusun Bungkul, Desa Sumberejo, Kec. Margomulyo, Kab. Bojonegoro',
        openHours: '24 Jam (Setiap Hari)',
        price: 'Gratis',
        rating: '4.9',
        facilities: ['9 Tiang Utama Wali Songo', 'Selasar 25 Kubah Nabi', 'Pelataran & Kolam Hias', 'Rest Area Perbatasan', 'Kios UMKM Warga', 'Parkir Luas Mobil & Bus'],
        mapQuery: 'Masjid An Nahdla Margomulyo Bojonegoro',
        imagePath: 'assets/images/Masjid.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1564769625905-50e93615e769?q=80&w=1000',
      ),
    ]);

    // 5. SOP Lapor & Laporan Warga Initial Data
    _laporSopList.addAll([
      ItemSopLapor(
        id: 'SOP-001',
        title: 'SOP Layanan Pengaduan SIAP LAPOR Bojonegoro',
        category: 'Pelayanan Publik',
        sopText: '1. Pelapor menyampaikan laporan lengkap via aplikasi SuperApp.\n2. Tim Verifikasi Pemkab memverifikasi laporan dalam 1x24 jam.\n3. Laporan diteruskan ke Dinas Terkait.\n4. Penanganan & Balasan disampaikan ke Pelapor.',
        pdfFileName: 'SOP_Lapor_Pelayanan_Publik_2026.pdf',
      ),
      ItemSopLapor(
        id: 'SOP-002',
        title: 'Prosedur Laporan Kerusakan Jalan & Infrastruktur',
        category: 'Infrastruktur & Jalan',
        sopText: '1. Cantumkan foto lokasi jelas & patokan jalan.\n2. Dinas PU Bina Marga akan melakukan survei lapangan maks 2 hari kerja.\n3. Penanganan darurat dilakukan jika membahayakan.',
        pdfFileName: 'SOP_Infrastruktur_Jalan_Bojonegoro.pdf',
      ),
      ItemSopLapor(
        id: 'SOP-003',
        title: 'Ketentuan Laporan Penanganan Sampah & Kebersihan',
        category: 'Kebersihan & Sampah',
        sopText: '1. Sertakan koordinat lokasi tumpukan sampah.\n2. Dinas Lingkungan Hidup menindaklanjuti dengan pengangkutan armada bersangkutan.',
        pdfFileName: 'SOP_DLH_Kebersihan_Sampah.pdf',
      ),
    ]);

    _laporanWargaList.addAll([
      ItemLaporanWarga(
        id: 'LPR-20260828-001',
        category: 'Infrastruktur & Jalan',
        title: 'Jalan Berlubang Cukup Dalam di Dekat Perempatan Mastrip',
        description: 'Jalan berlubang cukup dalam di dekat perempatan Mastrip Bojonegoro, membahayakan pengendara motor saat malam hari.',
        reporterName: 'Budi Santoso',
        reporterPhone: '0812-3456-7890',
        location: 'Jl. Mastrip, Bojonegoro Kota',
        photoSource: 'Kamera Perangkat (GPS Verified)',
        status: 'Diproses',
        dateStr: '28 Agu 2026 09:30 WIB',
        adminNote: 'Telah diteruskan ke Dinas PU Bina Marga untuk penambalan lokasi.',
      ),
      ItemLaporanWarga(
        id: 'LPR-20260828-002',
        category: 'Lampu Penerangan',
        title: 'Lampu PJU Mati Total Sepanjang Jl. Veteran',
        description: 'Lampu Penerangan Jalan Umum (PJU) padam total dari perempatan jalan baru sampai ke stasiun.',
        reporterName: 'Siti Aminah',
        reporterPhone: '0857-8901-2345',
        location: 'Jl. Veteran, Bojonegoro',
        photoSource: 'Galeri Perangkat',
        status: 'Menunggu',
        dateStr: '28 Agu 2026 10:15 WIB',
      ),
      ItemLaporanWarga(
        id: 'LPR-20260827-003',
        category: 'Kebersihan & Sampah',
        title: 'Tumpukan Sampah Liar di Pinggir Sungai Bengawan Solo',
        description: 'Pengangkutan sampah belum dilakukan selama 3 hari sehingga menumpuk dan berbau menyengat.',
        reporterName: 'Rahmat Hidayat',
        reporterPhone: '0813-9876-5432',
        location: 'Desa Ledok Kulon, Bojonegoro',
        photoSource: 'Kamera Perangkat',
        status: 'Selesai',
        dateStr: '27 Agu 2026 14:20 WIB',
        adminNote: 'Armada DLH telah mengangkut dan membersihkan lokasi.',
      ),
    ]);

    // 6. Kontak Instansi Initial Data
    _kontakInstansiList.addAll([
      ItemKontakInstansi(
        id: 'INS-001',
        agencyName: 'Dinas Kependudukan dan Pencatatan Sipil (Disdukcapil)',
        address: 'Jl. Pattimura No. 26, Bojonegoro',
        phone: '(0353) 881513',
        email: 'disdukcapil@bojonegorkab.go.id',
        operatingHours: 'Senin - Jumat (07.30 - 15.30 WIB)',
      ),
      ItemKontakInstansi(
        id: 'INS-002',
        agencyName: 'Dinas Komunikasi dan Informatika (Diskominfo)',
        address: 'Jl. Mastrip No. 3, Bojonegoro',
        phone: '(0353) 881234',
        email: 'diskominfo@bojonegorkab.go.id',
        operatingHours: 'Senin - Jumat (07.30 - 16.00 WIB)',
      ),
    ]);

    // 7. Emergency Initial Data
    _emergencyList.addAll([
      ItemEmergencyCall(
        id: 'EMG-001',
        serviceName: 'Call Center Darurat Bojonegoro 112',
        hotline: '112',
        category: 'Umum / Tanggap Darurat',
        description: 'Bebas pulsa 24 jam untuk segala kondisi darurat medis, kebakaran, bencana, dan keamanan.',
      ),
      ItemEmergencyCall(
        id: 'EMG-002',
        serviceName: 'Pemadam Kebakaran (Damkar) Bojonegoro',
        hotline: '(0353) 113 / 881023',
        category: 'Kebakaran & Penyelamatan',
        description: 'Penanganan kebakaran, penyelamatan hewan liar, dan musibah evakuasi darurat.',
      ),
      ItemEmergencyCall(
        id: 'EMG-003',
        serviceName: 'Ambulan RSUD Dr. R. Sosodoro Djatikoesoemo',
        hotline: '(0353) 881193',
        category: 'Medis',
        description: 'Layanan penjemputan pasien dan rujukan darurat 24 jam.',
      ),
    ]);

    // 8. Loker Initial Data
    _lokerList.addAll([
      ItemLokerAdmin(
        id: 'LOK-001',
        title: 'Staff Tenaga Teknis IT Diskominfo',
        company: 'Dinas Kominfo Bojonegoro',
        location: 'Kota Bojonegoro',
        salary: 'Rp 3.500.000 - Rp 4.500.000',
        category: 'Teknologi Informasi',
        status: 'Terverifikasi',
        postedDate: '22 Agustus 2026',
      ),
      ItemLokerAdmin(
        id: 'LOK-002',
        title: 'Operator Alat Berat Konstruksi',
        company: 'PT Bojonegoro Bangun Persada',
        location: 'Kapas, Bojonegoro',
        salary: 'Rp 4.000.000 - Rp 5.500.000',
        category: 'Konstruksi',
        status: 'Terverifikasi',
        postedDate: '20 Agustus 2026',
      ),
      ItemLokerAdmin(
        id: 'LOK-003',
        title: 'Customer Service Bank Daerah',
        company: 'PT BPR Bank Daerah Bojonegoro',
        location: 'Kota Bojonegoro',
        salary: 'Rp 3.200.000',
        category: 'Perbankan',
        status: 'Menunggu Verifikasi',
        postedDate: '24 Agustus 2026',
      ),
    ]);

    // 9. Layanan Sosial Initial Data
    _layananSosialList.addAll([
      ItemLayananSosial(
        id: 'SOS-001',
        title: 'Bantuan Sosial Terpadu',
        category: 'Layanan Unggulan',
        description: 'Informasi dan tata cara pengajuan PKH, BPNT, serta DTKS Kemensos.',
        requirement: 'Terdaftar di DTKS, Fotokopi KTP, KK, & Surat Keterangan Desa',
        mechanism: 'Pencairan berkala melalui Bank Himbara & PT Pos Indonesia.',
      ),
      ItemLayananSosial(
        id: 'SOS-002',
        title: 'Persyaratan Pelayanan Publik',
        category: 'Layanan Unggulan',
        description: 'Informasi standar pelayanan publik dan dokumen persyaratan administrasi.',
        requirement: 'Dokumen persyaratan sesuai kategori A - G Dinas Sosial Bojonegoro',
        mechanism: 'Pengajuan berkas di Kantor Dinsos / Kecamatan / Portal Online.',
      ),
    ]);

    // 9b. Perhubungan Initial Data
    _perhubunganList.addAll([
      ItemPerhubungan(
        id: 'PHB-001',
        title: 'Pengaduan Perhubungan',
        description: 'Laporkan masalah perhubungan',
        phoneNumber: '081333555695',
        icon: Icons.campaign_outlined,
      ),
      ItemPerhubungan(
        id: 'PHB-002',
        title: 'APEL Gratis',
        description: 'Angkutan Pelajar Gratis',
        urlStr: 'https://apelgratis.bojonegorokab.go.id/',
        icon: Icons.directions_bus_outlined,
      ),
      ItemPerhubungan(
        id: 'PHB-003',
        title: 'Bojonegoro TIC',
        description: 'CCTV & informasi lalu lintas',
        urlStr: 'https://play.google.com/store/apps/details?id=id.go.bojonegorokab.botic&hl=id',
        icon: Icons.videocam_outlined,
      ),
    ]);

    // 10. Berita Initial Data
    _beritaList.addAll([
      ItemBeritaAdmin(
        id: 'NWS-001',
        title: 'Pemkab Bojonegoro Resmi Meluncurkan SuperApp Pelayanan Publik Terpadu',
        category: 'Pemerintahan',
        date: '24 Agustus 2026',
        author: 'Humas Pemkab',
        content: 'Pemerintah Kabupaten Bojonegoro resmi merilis platform digital SuperApp untuk mempermudah masyarakat mengakses seluruh layanan publik secara cepat dan transparan.',
        imageUrl: 'assets/images/bojonegoro_gate.jpg',
        status: 'Published',
      ),
      ItemBeritaAdmin(
        id: 'NWS-002',
        title: 'Festival Wisata Khayangan Api Siap Dimulai Bulan Depan',
        category: 'Pariwisata',
        date: '23 Agustus 2026',
        author: 'Dinas Kebudayaan & Pariwisata',
        content: 'Berbagai seni pertunjukan dan kebudayaan daerah akan ditampilkan meriah di Objek Wisata Khayangan Api Dander.',
        imageUrl: 'assets/images/Khayangan_Api.jpg',
        status: 'Published',
      ),
      ItemBeritaAdmin(
        id: 'NWS-003',
        title: 'Draf Pembaruan Alokasi Pupuk Subsidized Musim Tanam III',
        category: 'Pertanian',
        date: '24 Agustus 2026',
        author: 'Dinas Pertanian',
        content: 'Draf rencana alokasi pupuk tambahan bagi petani terdaftar e-RDKK.',
        imageUrl: 'assets/images/kebun_belimbing.jpg',
        status: 'Draft',
      ),
    ]);
  }

  // --- CRUD METHODS ---
  // TODO: [Backend API / Supabase DB & Storage Integration]
  // In Phase 2, replace local list operations with Supabase DB queries (e.g., supabase.from('kependudukan').insert/update/delete)
  // and upload attachment files to Supabase Storage bucket.

  // 1. Kependudukan
  void addKependudukan(ItemKependudukan item) {
    _kependudukanList.insert(0, item);
    _logActivity('Tambah Layanan Kependudukan: ${item.title}', 'Kependudukan');
    notifyListeners();
  }

  void updateKependudukan(ItemKependudukan item) {
    final index = _kependudukanList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _kependudukanList[index] = item;
      _logActivity('Edit Layanan Kependudukan: ${item.title}', 'Kependudukan');
      notifyListeners();
    }
  }

  void deleteKependudukan(String id) {
    _kependudukanList.removeWhere((e) => e.id == id);
    _logActivity('Hapus Layanan Kependudukan ($id)', 'Kependudukan');
    notifyListeners();
  }

  // 2. Pendidikan - Beasiswa
  void addBeasiswa(ItemBeasiswa item) {
    _beasiswaList.insert(0, item);
    _logActivity('Tambah Program Beasiswa: ${item.title}', 'Pendidikan');
    notifyListeners();
  }

  void updateBeasiswa(ItemBeasiswa item) {
    final index = _beasiswaList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _beasiswaList[index] = item;
      _logActivity('Edit Program Beasiswa: ${item.title}', 'Pendidikan');
      notifyListeners();
    }
  }

  void deleteBeasiswa(String id) {
    _beasiswaList.removeWhere((e) => e.id == id);
    _logActivity('Hapus Program Beasiswa ($id)', 'Pendidikan');
    notifyListeners();
  }

  // 2b. Pendidikan - Perpustakaan
  void addPerpustakaan(ItemPerpustakaan item) {
    _perpustakaanList.insert(0, item);
    _logActivity('Tambah Buku Perpustakaan: ${item.title}', 'Pendidikan');
    notifyListeners();
  }

  void updatePerpustakaan(ItemPerpustakaan item) {
    final index = _perpustakaanList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _perpustakaanList[index] = item;
      _logActivity('Edit Buku Perpustakaan: ${item.title}', 'Pendidikan');
      notifyListeners();
    }
  }

  void deletePerpustakaan(String id) {
    _perpustakaanList.removeWhere((e) => e.id == id);
    _logActivity('Hapus Buku Perpustakaan ($id)', 'Pendidikan');
    notifyListeners();
  }

  // 3. Pertanian
  void addPertanian(ItemPertanian item) {
    _pertanianList.insert(0, item);
    _logActivity('Tambah Data Pupuk: ${item.name}', 'Pertanian');
    notifyListeners();
  }

  void updatePertanian(ItemPertanian item) {
    final index = _pertanianList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _pertanianList[index] = item;
      _logActivity('Edit Data Pupuk: ${item.name}', 'Pertanian');
      notifyListeners();
    }
  }

  void deletePertanian(String id) {
    _pertanianList.removeWhere((e) => e.id == id);
    _logActivity('Hapus Data Pupuk ($id)', 'Pertanian');
    notifyListeners();
  }

  // 4. Pariwisata
  void addPariwisata(ItemPariwisata item) {
    _pariwisataList.insert(0, item);
    _logActivity('Tambah Objek Wisata: ${item.name}', 'Pariwisata');
    notifyListeners();
  }

  void updatePariwisata(ItemPariwisata item) {
    final index = _pariwisataList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _pariwisataList[index] = item;
      _logActivity('Edit Objek Wisata: ${item.name}', 'Pariwisata');
      notifyListeners();
    }
  }

  void deletePariwisata(String id) {
    _pariwisataList.removeWhere((e) => e.id == id);
    _logActivity('Hapus Objek Wisata ($id)', 'Pariwisata');
    notifyListeners();
  }

  void togglePublishPariwisata(String id) {
    final index = _pariwisataList.indexWhere((e) => e.id == id);
    if (index != -1) {
      _pariwisataList[index].isPublished = !_pariwisataList[index].isPublished;
      _logActivity('Toggle Status Wisata: ${_pariwisataList[index].name}', 'Pariwisata');
      notifyListeners();
    }
  }

  // 5. Lapor SOP
  void updateLaporSop(ItemSopLapor item) {
    final index = _laporSopList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _laporSopList[index] = item;
    } else {
      _laporSopList.insert(0, item);
    }
    _logActivity('Update SOP Lapor: ${item.title}', 'Lapor');
    notifyListeners();
  }

  void deleteLaporSop(String id) {
    _laporSopList.removeWhere((e) => e.id == id);
    _logActivity('Hapus SOP Lapor ($id)', 'Lapor');
    notifyListeners();
  }

  // 5b. DPMPTSP SOP Engine
  String _jadwalTatapMuka = 'Jadwal Tatap Muka: Senin - Jumat (08.00 - 15.00 WIB)';
  String get jadwalTatapMuka => _jadwalTatapMuka;
  void updateJadwalTatapMuka(String val) {
    _jadwalTatapMuka = val;
    _logActivity('Update Jadwal Tatap Muka', 'DPMPTSP Pengaduan');
    notifyListeners();
  }

  String _informasiKetentuanPengaduan =
      'Melalui pengaduan ini, pengguna jasa dapat menyampaikan keluhan maupun komentar terhadap fasilitas gedung, pelayanan, pelanggaran kode etik, serta hal-hal yang terkait dengan pelaksanaan prosedur pelayanan di Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu Kabupaten Bojonegoro. Pengaduan ini disampaikan secara langsung atau melalui email dengan mengisi formulir pengaduan secara lengkap, agar petugas kami dapat menindaklanjuti pengaduan yang telah disampaikan. Apabila data yang disampaikan tidak benar, pengaduan tidak akan diproses lebih lanjut.';
  String get informasiKetentuanPengaduan => _informasiKetentuanPengaduan;
  void updateInformasiKetentuanPengaduan(String val) {
    _informasiKetentuanPengaduan = val;
    _logActivity('Update Informasi & Ketentuan Pengaduan', 'DPMPTSP Pengaduan');
    notifyListeners();
  }


  final Map<String, List<DpmptspSopStep>> _dpmptspSopMap = {};

  List<DpmptspSopStep> getDpmptspSopSteps(String channelKey) {
    if (!_dpmptspSopMap.containsKey(channelKey) || _dpmptspSopMap[channelKey]!.isEmpty) {
      _dpmptspSopMap[channelKey] = _getDefaultDpmptspSopSteps(channelKey);
    }
    return _dpmptspSopMap[channelKey]!;
  }

  void addDpmptspSopStep(String channelKey, DpmptspSopStep step) {
    final list = getDpmptspSopSteps(channelKey);
    list.add(step);
    _logActivity('Tambah SOP Step ${step.stepNumber}', 'DPMPTSP Pengaduan');
    notifyListeners();
  }

  void updateDpmptspSopStep(String channelKey, DpmptspSopStep step) {
    final list = getDpmptspSopSteps(channelKey);
    final idx = list.indexWhere((e) => e.id == step.id);
    if (idx != -1) {
      list[idx] = step;
      _logActivity('Update SOP Step ${step.stepNumber}', 'DPMPTSP Pengaduan');
      notifyListeners();
    }
  }

  void deleteDpmptspSopStep(String channelKey, String stepId) {
    final list = getDpmptspSopSteps(channelKey);
    list.removeWhere((e) => e.id == stepId);
    _logActivity('Hapus SOP Step', 'DPMPTSP Pengaduan');
    notifyListeners();
  }

  List<DpmptspSopStep> _getDefaultDpmptspSopSteps(String channelKey) {
    final kanalName = _getChannelLabel(channelKey);
    return [
      DpmptspSopStep(
        id: '${channelKey}_1',
        stepNumber: '1',
        role: 'Masyarakat',
        duration: '-',
        output: 'Pengaduan',
        description: 'Masyarakat membuat pengaduan melalui $kanalName',
      ),
      DpmptspSopStep(
        id: '${channelKey}_2',
        stepNumber: '2',
        role: channelKey == 'lapor' ? 'Tim Adm Kab' : 'Staf Pengaduan',
        duration: '15 Menit',
        output: 'Berkas Pengaduan Lengkap',
        description: 'Menerima dan mencatat pengaduan dari masyarakat yang didapat dari $kanalName',
      ),
      DpmptspSopStep(
        id: '${channelKey}_3',
        stepNumber: '3',
        role: 'Penata Perizinan Ahli Muda',
        duration: '15 Menit',
        output: 'Pengaduan telah diterima',
        description: 'Pengaduan yang bukan kewenangan DPMPTSP. Menerima pengaduan yang diserahkan staf pengaduan kemudian meneruskan kepada OPD terkait apabila bukan kewenangan DPMPTSP untuk menjawab pengaduan. Selanjutnya OPD menindaklanjuti pengaduan langsung kepada masyarakat',
      ),
      DpmptspSopStep(
        id: '${channelKey}_4',
        stepNumber: '4',
        role: 'Penata Perizinan Ahli Muda',
        duration: channelKey == 'surat' ? '1 Hari' : '30 Menit',
        output: 'Berkas Pengaduan Lengkap dan konsep jawaban',
        description: 'Pengaduan kewenangan DPMPTSP. Menyusun berkas pengaduan, menganalisis serta memverifikasi berkas pengaduan untuk dijadikan konsep jawaban pengaduan',
      ),
      DpmptspSopStep(
        id: '${channelKey}_5',
        stepNumber: '5',
        role: 'Penata Perizinan Ahli Madya',
        duration: '15 Menit',
        output: 'konsep jawaban',
        description: 'Penata Perizinan Ahli Madya menerima dan memverifikasi rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
      ),
      DpmptspSopStep(
        id: '${channelKey}_6',
        stepNumber: '6',
        role: 'Kepala Dinas',
        duration: channelKey == 'surat' ? '1 Hari' : (channelKey == 'lapor' ? '14 Hari' : '15 Menit'),
        output: 'Jawaban pengaduan',
        description: 'Kepala Dinas Menerima dan menyetujui rekomendasi / jawaban dari hasil penyusunan konsep yang diserahkan oleh Penata Perizinan Ahli Muda',
      ),
      DpmptspSopStep(
        id: '${channelKey}_7',
        stepNumber: '7',
        role: 'Penata Perizinan Ahli Muda',
        duration: channelKey == 'lapor' ? '30 Menit' : '15 Menit',
        output: 'Jawaban pengaduan',
        description: 'Penata Perizinan Ahli Muda menerima persetujuan jawaban pengaduan kemudian menyampaikan jawaban kepada staf pengaduan untuk disampaikan kepada masyarakat',
      ),
    ];
  }

  String _getChannelLabel(String key) {
    switch (key) {
      case 'tatap_muka': return 'tatap muka';
      case 'surat': return 'kotak pengaduan / surat';
      case 'lapor': return 'kanal LAPOR';
      case 'website': return 'Website';
      case 'email': return 'Email';
      case 'whatsapp': return 'WhatsApp';
      case 'instagram': return 'Instagram';
      case 'twitter': return 'Twitter / X';
      default: return 'kanal pengaduan';
    }
  }


  // 6. Kontak Instansi
  void addKontakInstansi(ItemKontakInstansi item) {
    _kontakInstansiList.insert(0, item);
    _logActivity('Tambah Kontak Instansi: ${item.agencyName}', 'Kontak Instansi');
    notifyListeners();
  }

  void updateKontakInstansi(ItemKontakInstansi item) {
    final index = _kontakInstansiList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _kontakInstansiList[index] = item;
      _logActivity('Edit Kontak Instansi: ${item.agencyName}', 'Kontak Instansi');
      notifyListeners();
    }
  }

  void deleteKontakInstansi(String id) {
    _kontakInstansiList.removeWhere((e) => e.id == id);
    _logActivity('Hapus Kontak Instansi ($id)', 'Kontak Instansi');
    notifyListeners();
  }

  // 7. Emergency Call
  void addEmergency(ItemEmergencyCall item) {
    _emergencyList.insert(0, item);
    _logActivity('Tambah Kontak Darurat: ${item.serviceName}', 'Layanan Darurat');
    notifyListeners();
  }

  void updateEmergency(ItemEmergencyCall item) {
    final index = _emergencyList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _emergencyList[index] = item;
      _logActivity('Edit Kontak Darurat: ${item.serviceName}', 'Layanan Darurat');
      notifyListeners();
    }
  }

  void deleteEmergency(String id) {
    _emergencyList.removeWhere((e) => e.id == id);
    _logActivity('Hapus Kontak Darurat ($id)', 'Layanan Darurat');
    notifyListeners();
  }

  // 8. Lowongan Kerja (Loker) Verification Workflow
  void addLoker(ItemLokerAdmin item) {
    _lokerList.insert(0, item);
    _logActivity('Tambah Lowongan Kerja: ${item.title}', 'Lowongan Kerja');
    notifyListeners();
  }

  void updateLoker(ItemLokerAdmin item) {
    final index = _lokerList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _lokerList[index] = item;
      _logActivity('Edit Lowongan Kerja: ${item.title}', 'Lowongan Kerja');
      notifyListeners();
    }
  }

  void updateLokerStatus(String id, String status) {
    final index = _lokerList.indexWhere((e) => e.id == id);
    if (index != -1) {
      _lokerList[index].status = status;
      _logActivity('Verifikasi Loker ($status): ${_lokerList[index].title}', 'Lowongan Kerja');
      notifyListeners();
    }
  }

  void deleteLoker(String id) {
    _lokerList.removeWhere((e) => e.id == id);
    _logActivity('Hapus Lowongan Kerja ($id)', 'Lowongan Kerja');
    notifyListeners();
  }

  // 9. Layanan Sosial
  void addLayananSosial(ItemLayananSosial item) {
    _layananSosialList.insert(0, item);
    _logActivity('Tambah Layanan Sosial: ${item.title}', 'Layanan Sosial');
    notifyListeners();
  }

  void updateLayananSosial(ItemLayananSosial item) {
    final index = _layananSosialList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _layananSosialList[index] = item;
      _logActivity('Edit Layanan Sosial: ${item.title}', 'Layanan Sosial');
      notifyListeners();
    }
  }

  void deleteLayananSosial(String id) {
    _layananSosialList.removeWhere((e) => e.id == id);
    _logActivity('Hapus Layanan Sosial ($id)', 'Layanan Sosial');
    notifyListeners();
  }

  // 9b. Perhubungan
  void addPerhubungan(ItemPerhubungan item) {
    _perhubunganList.insert(0, item);
    _logActivity('Tambah Layanan Perhubungan: ${item.title}', 'Perhubungan');
    notifyListeners();
  }

  void updatePerhubungan(ItemPerhubungan item) {
    final index = _perhubunganList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _perhubunganList[index] = item;
      _logActivity('Edit Layanan Perhubungan: ${item.title}', 'Perhubungan');
      notifyListeners();
    }
  }

  void deletePerhubungan(String id) {
    _perhubunganList.removeWhere((e) => e.id == id);
    _logActivity('Hapus Layanan Perhubungan ($id)', 'Perhubungan');
    notifyListeners();
  }

  // 10. Berita
  void addBerita(ItemBeritaAdmin item) {
    _beritaList.insert(0, item);
    _logActivity('Tambah Berita (${item.status}): ${item.title}', 'Berita');
    notifyListeners();
  }

  void updateBerita(ItemBeritaAdmin item) {
    final index = _beritaList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _beritaList[index] = item;
      _logActivity('Edit Berita: ${item.title}', 'Berita');
      notifyListeners();
    }
  }

  void toggleBeritaStatus(String id) {
    final index = _beritaList.indexWhere((e) => e.id == id);
    if (index != -1) {
      final current = _beritaList[index].status;
      _beritaList[index].status = (current == 'Published') ? 'Draft' : 'Published';
      _logActivity('Ubah Status Berita (${_beritaList[index].status}): ${_beritaList[index].title}', 'Berita');
      notifyListeners();
    }
  }

  void deleteBerita(String id) {
    _beritaList.removeWhere((e) => e.id == id);
    _logActivity('Hapus Berita ($id)', 'Berita');
    notifyListeners();
  }

  // 11. Layanan Pajak & Retribusi
  final List<ItemPajak> _pajakList = [
    ItemPajak(
      id: 'simpatdu',
      title: 'SIMPATDU',
      subtitle: 'Sistem Informasi Sembilan Pajak Lainnya',
      categoryTag: 'Sembilan Pajak',
      webUrl: 'https://pajakonlinebojonegorokab.id/',
      badgeText: 'Pajak Daerah',
      fullDescription: 'SIMPATDU (Sistem Informasi Sembilan Pajak Lainnya) diakses via portal resmi pajakonlinebojonegorokab.id. Meliputi pelayanan pelaporan dan pembayaran 9 Pajak Daerah.',
    ),
    ItemPajak(
      id: 'bphtb',
      title: 'BPHTB',
      subtitle: 'Sistem Informasi Pajak BPHTB Online',
      categoryTag: 'PBB & BPHTB',
      webUrl: 'https://pajakonlinebojonegorokab.id/ebphtb/',
      badgeText: 'Bea Hak Tanah',
      fullDescription: 'Pelayanan Bea Perolehan Hak atas Tanah dan Bangunan (BPHTB) Kabupaten Bojonegoro.',
    ),
    ItemPajak(
      id: 'epayment',
      title: 'E-Payment Pajak',
      subtitle: 'Kanal Pembayaran Pajak Daerah Resmi',
      categoryTag: 'E-Payment',
      webUrl: 'https://pajakonlinebojonegorokab.id/epayment/',
      badgeText: 'Pembayaran Digital',
      fullDescription: 'Kanal pembayaran pajak online daerah Kabupaten Bojonegoro via Bank Jatim, QRIS, & Minimarket.',
    ),
    ItemPajak(
      id: 'wizztara',
      title: 'WIZZTARA',
      subtitle: 'Whatsapp Instant Zone & Taxpayer Assistant',
      categoryTag: 'Digitalisasi',
      webUrl: 'https://pajakonlinebojonegorokab.id/callcenter.php',
      badgeText: 'Asisten WA Pajak',
      fullDescription: 'WIZZTARA adalah asisten virtual resmi BAPENDA Bojonegoro untuk pelayanan informasi pajak daerah 24 jam.',
    ),
    ItemPajak(
      id: 'cek_bayar',
      title: 'Cek & Bayar PBB-P2',
      subtitle: 'Layanan Cek Tagihan PBB-P2 Online',
      categoryTag: 'E-Payment',
      webUrl: 'https://pajakonlinebojonegorokab.id/cek-bayar/ceksaja.php',
      badgeText: 'Status & Bukti Bayar',
      fullDescription: 'Fasilitas pencarian dan verifikasi status pembayaran pajak daerah Bojonegoro.',
    ),
    ItemPajak(
      id: 'dijamin_minul',
      title: 'DIJAMIN MINUL',
      subtitle: 'Pajak Mineral Bukan Logam & Batuan',
      categoryTag: 'Digitalisasi',
      webUrl: 'https://pajakonlinebojonegorokab.id/eSPTPDbjn/',
      badgeText: 'Mamin & MBLB Online',
      fullDescription: 'Inovasi DIJAMIN MINUL untuk transparansi pendataan, pencatatan tonase, serta pembayaran Pajak MBLB.',
    ),
    ItemPajak(
      id: 'smart_report',
      title: 'Smart Report BAPENDA',
      subtitle: 'Pelaporan Pajak Mandiri Online',
      categoryTag: 'Digitalisasi',
      webUrl: 'https://pajakonlinebojonegorokab.id/smartreport/',
      badgeText: 'Lapor Mandiri',
      fullDescription: 'Portal Smart Report menyajikan transparansi data rekapitulasi dan grafik realisasi target pendapatan pajak daerah.',
    ),
    ItemPajak(
      id: 'epbb',
      title: 'e-PBB',
      subtitle: 'Pelayanan SPPT PBB Digital',
      categoryTag: 'PBB & BPHTB',
      webUrl: 'https://pajakonlinebojonegorokab.id/wpbb/',
      badgeText: 'Pajak Bumi & Bangunan',
      fullDescription: 'Portal e-PBB merupakan sarana pelayanan Pajak Bumi dan Bangunan Perdesaan dan Perkotaan (PBB-P2) Kabupaten Bojonegoro.',
    ),
  ];

  List<ItemPajak> get pajakList => List.unmodifiable(_pajakList);

  void _loadPajakFromStorage() {
    try {
      final rawJson = html.window.localStorage['admin_pajak_data'];
      if (rawJson != null && rawJson.trim().isNotEmpty) {
        final List<dynamic> list = jsonDecode(rawJson);
        _pajakList.clear();
        _pajakList.addAll(list.map((item) => ItemPajak.fromJson(Map<String, dynamic>.from(item))));
      }
    } catch (e) {
      debugPrint('Error loading admin_pajak_data: $e');
    }
  }

  void _savePajakToStorage() {
    try {
      final jsonList = _pajakList.map((e) => e.toJson()).toList();
      html.window.localStorage['admin_pajak_data'] = jsonEncode(jsonList);
    } catch (e) {
      debugPrint('Error saving admin_pajak_data: $e');
    }
  }

  void addPajak(ItemPajak item) {
    _pajakList.insert(0, item);
    _savePajakToStorage();
    _logActivity('Tambah Layanan Pajak: ${item.title}', 'Perpajakan');
    notifyListeners();
  }

  void updatePajak(ItemPajak item) {
    final index = _pajakList.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _pajakList[index] = item;
      _savePajakToStorage();
      _logActivity('Edit Layanan Pajak: ${item.title}', 'Perpajakan');
      notifyListeners();
    }
  }

  void deletePajak(String id) {
    _pajakList.removeWhere((e) => e.id == id);
    _savePajakToStorage();
    _logActivity('Hapus Layanan Pajak ($id)', 'Perpajakan');
    notifyListeners();
  }

  // ==================== LAPOR & PENGADUAN METHODS ====================

  void updateStatusLaporanWarga(String id, String newStatus, String adminNote) {
    final idx = _laporanWargaList.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _laporanWargaList[idx].status = newStatus;
      _laporanWargaList[idx].adminNote = adminNote;
      _logActivity('Update Status Laporan $id -> $newStatus', 'SIAP LAPOR');
      notifyListeners();
    }
  }

  void deleteLaporanWarga(String id) {
    _laporanWargaList.removeWhere((e) => e.id == id);
    _logActivity('Hapus Laporan Warga ($id)', 'SIAP LAPOR');
    notifyListeners();
  }
}
