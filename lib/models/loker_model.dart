/// Model representing a Job Vacancy (Lowongan Pekerjaan / Info Loker)
class LokerItem {
  final String id;
  final String title;
  final String companyName;
  final String category;
  final String locationKecamatan;
  final String fullAddress; // Custom full typed address
  final String salaryRange;
  final String jobType; // Full-Time, Part-Time, Kontrak, Freelance
  final String description;
  final List<String> requirements;
  final String contactName; // Nama Penanggung Jawab / Contact Person
  final String contactPhone;
  final String contactWhatsapp;
  final String instagram; // Instagram handle / link
  final String email; // HRD / Office email
  final String website; // Company / Official website link
  final String posterImagePath; // Uploaded poster image path
  final String postedByRole; // Aparat / Masyarakat
  final String postedDate;
  final bool isVerified;

  const LokerItem({
    required this.id,
    required this.title,
    required this.companyName,
    required this.category,
    required this.locationKecamatan,
    required this.fullAddress,
    required this.salaryRange,
    required this.jobType,
    required this.description,
    required this.requirements,
    this.contactName = '',
    required this.contactPhone,
    required this.contactWhatsapp,
    this.instagram = '',
    this.email = '',
    this.website = '',
    this.posterImagePath = '',
    required this.postedByRole,
    required this.postedDate,
    this.isVerified = true,
  });
}

/// Job categories list for filtering and form creation
const List<String> listKategoriLoker = [
  'Semua',
  'Administrasi',
  'Industri & Pabrik',
  'Perdagangan & Toko',
  'Jasa & Pelayanan',
  'Pendidikan',
  'Teknologi',
  'Pertanian & Peternakan',
  'Konstruksi & Teknik',
  'Lainnya',
];

/// Form job category options (excluding 'Semua')
const List<String> listKategoriLokerForm = [
  'Administrasi',
  'Industri & Pabrik',
  'Perdagangan & Toko',
  'Jasa & Pelayanan',
  'Pendidikan',
  'Teknologi',
  'Pertanian & Peternakan',
  'Konstruksi & Teknik',
  'Lainnya',
];

/// Job Types list
const List<String> listTipePekerjaan = [
  'Full-Time',
  'Part-Time',
  'Kontrak',
  'Freelance',
];

/// Kecamatan options in Bojonegoro
const List<String> listKecamatanLoker = [
  'Semua Kecamatan',
  'Kecamatan Bojonegoro',
  'Kecamatan Balen',
  'Kecamatan Baureno',
  'Kecamatan Bubulan',
  'Kecamatan Dander',
  'Kecamatan Gayam',
  'Kecamatan Gondang',
  'Kecamatan Kalitidu',
  'Kecamatan Kanor',
  'Kecamatan Kapas',
  'Kecamatan Kasiman',
  'Kecamatan Kedewan',
  'Kecamatan Kedungadem',
  'Kecamatan Kepohbaru',
  'Kecamatan Malo',
  'Kecamatan Margomulyo',
  'Kecamatan Ngambon',
  'Kecamatan Ngasem',
  'Kecamatan Ngraho',
  'Kecamatan Padangan',
  'Kecamatan Purwosari',
  'Kecamatan Sekar',
  'Kecamatan Sugihwaras',
  'Kecamatan Sukosewu',
  'Kecamatan Sumberrejo',
  'Kecamatan Tambakrejo',
  'Kecamatan Temayang',
  'Kecamatan Trucuk',
];

/// Form location options (excluding 'Semua Kecamatan')
const List<String> listKecamatanLokerForm = [
  'Kecamatan Bojonegoro',
  'Kecamatan Balen',
  'Kecamatan Baureno',
  'Kecamatan Bubulan',
  'Kecamatan Dander',
  'Kecamatan Gayam',
  'Kecamatan Gondang',
  'Kecamatan Kalitidu',
  'Kecamatan Kanor',
  'Kecamatan Kapas',
  'Kecamatan Kasiman',
  'Kecamatan Kedewan',
  'Kecamatan Kedungadem',
  'Kecamatan Kepohbaru',
  'Kecamatan Malo',
  'Kecamatan Margomulyo',
  'Kecamatan Ngambon',
  'Kecamatan Ngasem',
  'Kecamatan Ngraho',
  'Kecamatan Padangan',
  'Kecamatan Purwosari',
  'Kecamatan Sekar',
  'Kecamatan Sugihwaras',
  'Kecamatan Sukosewu',
  'Kecamatan Sumberrejo',
  'Kecamatan Tambakrejo',
  'Kecamatan Temayang',
  'Kecamatan Trucuk',
];

/// Initial Sample Job Vacancies Data in Bojonegoro
List<LokerItem> initialLokerItems = [
  const LokerItem(
    id: 'loker_1',
    title: 'Staff Layanan Administrasi Kantor Desa',
    companyName: 'Pemerintah Desa Balenrejo',
    category: 'Administrasi',
    locationKecamatan: 'Kecamatan Balen',
    fullAddress: 'Jl. Raya Balen No. 45, Desa Balenrejo, RT 03/RW 01, Kec. Balen',
    salaryRange: 'Rp 2.200.000 - Rp 2.800.000 / bulan',
    jobType: 'Full-Time',
    description: 'Dibutuhkan Staff Administrasi Kantor Desa Balenrejo untuk mengelola pelayanan persuratan kependudukan, penginputan data sistem informasi desa (SID), serta membantu pelayanan publik warga.',
    requirements: [
      'Pria / Wanita, usia maksimal 35 tahun',
      'Pendidikan minimal SMA / SMK Sederajat',
      'Menguasai Komputer (MS Word, Excel, & Internet)',
      'Jujur, teliti, dan berkomunikasi dengan baik',
      'Diutamakan berdomisili di Kecamatan Balen atau sekitarnya',
    ],
    contactName: 'Bpk. Supardi (Sekdes Balenrejo)',
    contactPhone: '081234567890',
    contactWhatsapp: '081234567890',
    instagram: '@pemdes_balenrejo',
    email: 'balenrejo@bojonegorokab.go.id',
    website: 'balenrejo.bojonegorokab.go.id',
    posterImagePath: '',
    postedByRole: 'Aparat Desa / Pemerintah',
    postedDate: '6 Agu 2026',
    isVerified: true,
  ),
  const LokerItem(
    id: 'loker_2',
    title: 'Kasir & Pramuniaga Toko Sembako',
    companyName: 'Toko Sembako Berkah Jaya',
    category: 'Perdagangan & Toko',
    locationKecamatan: 'Kecamatan Bojonegoro',
    fullAddress: 'Kawasan Pasar Wisata Bojonegoro Blok A No. 12, Kota Bojonegoro',
    salaryRange: 'Rp 1.800.000 - Rp 2.300.000 / bulan',
    jobType: 'Full-Time',
    description: 'Dibutuhkan Kasir & Pramuniaga toko grosir sembako di kawasan Pasar Wisata Bojonegoro. Bertanggung jawab melayani transaksi pembeli dan pencatatan stok.',
    requirements: [
      'Wanita, usia 18 - 30 tahun',
      'Pendidikan min. SMA/SMK',
      'Menguasai penggunaan mesin kasir / kalkulator',
      'Ramah, jujur, dan bertanggung jawab',
    ],
    contactName: 'Ibu Hajah Titik (Pemilik Toko)',
    contactPhone: '085233445566',
    contactWhatsapp: '085233445566',
    instagram: '@tokoberkahjaya_bjn',
    email: 'hrd@berkahjayabjn.com',
    website: '',
    posterImagePath: '',
    postedByRole: 'Masyarakat / Perusahaan',
    postedDate: '5 Agu 2026',
    isVerified: true,
  ),
  const LokerItem(
    id: 'loker_3',
    title: 'Operator Mesin Industri & Produksi',
    companyName: 'PT Mitra Karya Industri Bojonegoro',
    category: 'Industri & Pabrik',
    locationKecamatan: 'Kecamatan Kapas',
    fullAddress: 'Jl. Raya Bojonegoro-Babatt Km 7, Kawasan Industri Kapas',
    salaryRange: 'UMK Bojonegoro (+ Lembur)',
    jobType: 'Kontrak',
    description: 'Lowongan kerja operator mesin produksi pabrik pengolahan hasil pertanian di Kapas Bojonegoro.',
    requirements: [
      'Pria, usia 19 - 35 tahun',
      'Pendidikan SMK Teknik Mesin / Otomotif / IPA',
      'Sehat jasmani dan rohani',
      'Siap bekerja dalam sistem shift',
    ],
    contactName: 'Bpk. Hendra (HRD Manager)',
    contactPhone: '081399887766',
    contactWhatsapp: '081399887766',
    instagram: '@mitrakaryaindustri',
    email: 'karir@mitrakaryaindustri.co.id',
    website: 'www.mitrakaryaindustri.co.id',
    posterImagePath: '',
    postedByRole: 'Masyarakat / Perusahaan',
    postedDate: '4 Agu 2026',
    isVerified: true,
  ),
];
