import 'package:flutter/foundation.dart';

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
  String location;
  String rating;
  String price;
  String description;
  List<String> facilities;
  String imageUrl;
  bool isPublished;

  ItemPariwisata({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.description,
    required this.facilities,
    required this.imageUrl,
    this.isPublished = true,
  });
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
  }

  // Datasets
  final List<ItemKependudukan> _kependudukanList = [];
  final List<ItemBeasiswa> _beasiswaList = [];
  final List<ItemPertanian> _pertanianList = [];
  final List<ItemPariwisata> _pariwisataList = [];
  final List<ItemSopLapor> _laporSopList = [];
  final List<ItemKontakInstansi> _kontakInstansiList = [];
  final List<ItemEmergencyCall> _emergencyList = [];
  final List<ItemLokerAdmin> _lokerList = [];
  final List<ItemLayananSosial> _layananSosialList = [];
  final List<ItemBeritaAdmin> _beritaList = [];
  final List<AdminActivityLog> _activityLogs = [];

  // Getters
  List<ItemKependudukan> get kependudukanList => List.unmodifiable(_kependudukanList);
  List<ItemBeasiswa> get beasiswaList => List.unmodifiable(_beasiswaList);
  List<ItemPertanian> get pertanianList => List.unmodifiable(_pertanianList);
  List<ItemPariwisata> get pariwisataList => List.unmodifiable(_pariwisataList);
  List<ItemSopLapor> get laporSopList => List.unmodifiable(_laporSopList);
  List<ItemKontakInstansi> get kontakInstansiList => List.unmodifiable(_kontakInstansiList);
  List<ItemEmergencyCall> get emergencyList => List.unmodifiable(_emergencyList);
  List<ItemLokerAdmin> get lokerList => List.unmodifiable(_lokerList);
  List<ItemLayananSosial> get layananSosialList => List.unmodifiable(_layananSosialList);
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

    // 4. Pariwisata Initial Data
    _pariwisataList.addAll([
      ItemPariwisata(
        id: 'WIS-001',
        name: 'Khayangan Api',
        location: 'Ngaseh, Dander, Bojonegoro',
        rating: '4.7',
        price: 'Rp 10.000',
        description: 'Sumber api abadi tak kunjung padam yang dikelilingi hutan jati alami.',
        facilities: ['Area Parkir', 'Warung Makan', 'Gazebo', 'Toilet'],
        imageUrl: 'assets/images/Khayangan_Api.jpg',
      ),
      ItemPariwisata(
        id: 'WIS-002',
        name: 'Negeri Atas Angin',
        location: 'Deling, Sekar, Bojonegoro',
        rating: '4.8',
        price: 'Rp 15.000',
        description: 'Pemandangan bukit indah dan spot foto sunrise menakjubkan dari ketinggian.',
        facilities: ['Spot Foto', 'Camping Ground', 'Musholla', 'Warung Kopi'],
        imageUrl: 'assets/images/Negeri_Atas_Angin.jpg',
      ),
      ItemPariwisata(
        id: 'WIS-003',
        name: 'Teksas Wonocolo (GeoPark)',
        location: 'Wonocolo, Kedewan, Bojonegoro',
        rating: '4.6',
        price: 'Rp 5.000',
        description: 'Wisata edukasi sumur minyak tradisional tertua di Indonesia.',
        facilities: ['Museum Minyak', 'Pusat Edukasi', 'Guide Lokal'],
        imageUrl: 'assets/images/Teksas Wonocolo.jpg',
      ),
    ]);

    // 5. SOP Lapor Initial Data
    _laporSopList.addAll([
      ItemSopLapor(
        id: 'LPR-001',
        title: 'SOP Pelaporan Pengaduan Masyarakat (SIAP LAPOR)',
        category: 'Pelayanan Publik',
        sopText: '1. Pelapor menyampaikan laporan lengkap beserta foto buktiPendukung.\n2. Tim verifikator memeriksa kelengkapan dalam 1x24 jam.\n3. Laporan diteruskan ke Dinas terkait untuk tindak lanjut.',
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
        title: 'Program Bantuan Sosial PKH Daerah',
        category: 'Bansos',
        description: 'Bantuan tunai bersyarat bagi keluarga kurang mampu di Bojonegoro.',
        requirement: 'Terdaftar di DTKS & Memiliki Kartu Komitmen Sosial',
        mechanism: 'Pencairan berkala melalui Himbara dan Kantor Pos.',
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

  // 2. Pendidikan
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
}
