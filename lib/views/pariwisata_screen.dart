import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'khayangan_api_data.dart';
import 'negeri_atas_angin_data.dart';
import 'kebun_belimbing_data.dart';
import 'gofun_data.dart';
import 'bendungan_gerak_data.dart';
import 'waduk_pacal_data.dart';
import 'samin_bojonegoro_data.dart';
import 'museum_rajekwesi_data.dart';
import 'wali_kidangan_data.dart';
import 'klenteng_hok_swie_bio_data.dart';
import 'makam_jojonegoro_data.dart';
import 'masjid_annahdla_data.dart';
import 'masjid_agung_darussalam_data.dart';
import 'teksas_wonocolo_data.dart';

class TourismSpot {
  final String id;
  final String title;
  final String category; // 'rekreasi' or 'sejarah_budaya'
  final String categoryLabel;
  final String description;
  final String address;
  final String openHours;
  final String ticketPrice;
  final List<String> facilities;
  final IconData icon;
  final Color themeColor;
  final String mapQuery;
  final String? imagePath;
  final String? imageUrl;
  final String? transportInfo;
  final List<String>? tips;

  TourismSpot({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryLabel,
    required this.description,
    required this.address,
    required this.openHours,
    required this.ticketPrice,
    required this.facilities,
    required this.icon,
    required this.themeColor,
    required this.mapQuery,
    this.imagePath,
    this.imageUrl,
    this.transportInfo,
    this.tips,
  });
}

class PariwisataScreen extends StatefulWidget {
  final bool isDarkMode;

  const PariwisataScreen({super.key, required this.isDarkMode});

  @override
  State<PariwisataScreen> createState() => _PariwisataScreenState();
}

class _PariwisataScreenState extends State<PariwisataScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<TourismSpot> _spots = [
    // === TEMPAT REKREASI ===
    TourismSpot(
      id: 'kayangan_api',
      title: 'Wisata Kayangan Api',
      category: 'rekreasi',
      categoryLabel: 'Rekreasi Alam & Geowisata',
      description:
          'Fenomena geologi api abadi yang tak pernah padam sejak zaman Kerajaan Majapahit, dikelilingi hutan jati alami yang asri dan sejuk. Tempat bersejarah bertapa Mbah Kriyo Kusumo.',
      address: 'Jl. Khayangan Api, Ngembul, Sendangharjo, Kec. Ngasem, Kabupaten Bojonegoro, Jawa Timur 62171',
      openHours: '24 Jam (Setiap Hari)',
      ticketPrice: 'Rp 8.500,- per orang (sudah termasuk asuransi jiwa)',
      facilities: ['Pendopo Santai', 'Gazebo', 'Spot Foto Api Abadi', 'Warung Kuliner Khas', 'Area Parkir Luas', 'Toilet Umum'],
      icon: Icons.local_fire_department_rounded,
      themeColor: const Color(0xFFF59E0B),
      mapQuery: 'https://maps.app.goo.gl/Q7kBMtn6da8vgG7v5',
      imagePath: 'assets/images/Khayangan_Api.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?q=80&w=1000',
    ),
    TourismSpot(
      id: 'atas_angin',
      title: 'Wisata Negeri Atas Angin',
      category: 'rekreasi',
      categoryLabel: 'Panorama Alam & Bukit Cinta',
      description:
          'Destinasi wisata panorama perbukitan indah di Desa Deling (50 km dari kota). Populer dengan Bukit Cinta—tempat bertemunya Dewi Sekar Sari & Raden Atas Aji di masa Kerajaan Mataram-Pajang. Pilihan favorit untuk camping sunrise, fotografi prewedding, dan menikmati keindahan lanskap alam.',
      address: 'Desa Deling, Kec. Sekar, Kab. Bojonegoro (50 km / ±2 jam dari Kota Bojonegoro)',
      openHours: '24 Jam (Setiap Hari)',
      ticketPrice: 'Rp 3.000 (Senin-Jumat), Rp 5.000 (Sabtu), Rp 6.000 (Minggu/Libur)',
      facilities: ['Bukit Cinta', 'Camping Ground Sunrise', 'Spot Foto Prewedding', 'Warung Makan & Minuman', 'Akses Jalan Bagus', 'Area Parkir'],
      icon: Icons.landscape_rounded,
      themeColor: const Color(0xFF10B981),
      mapQuery: 'https://maps.app.goo.gl/eHoXCVoChawwTvML6',
      imagePath: 'assets/images/Negeri_Atas_Angin.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=1000',
      transportInfo: 'Berjarak ±2 jam (50 km) dari Kota Bojonegoro. Dapat ditempuh dengan sewa mobil, ikutan tur, atau berkendara sendiri melalui akses jalan yang sudah baik.',
      tips: [
        'Kunjungi menjelang pagi untuk menikmati keindahan panorama sunrise.',
        'Pastikan membawa air minum sebelum mendaki Bukit Cinta.',
        'Siapkan topi/payung penolong terik jika naik di atas jam 08.00 pagi.',
        'Sediakan kantong kresek untuk membawa pulang sampah Anda demi menjaga kelestarian alam.',
        'Penginapan belum tersedia, namun pengunjung bisa berkemah di Bukit Cinta atau menginap di rumah warga setempat dengan izin desa.',
      ],
    ),
    TourismSpot(
      id: 'belimbing_ngringinrejo',
      title: 'Agrowisata Belimbing Ngringinrejo',
      category: 'rekreasi',
      categoryLabel: 'Agrowisata & Petik Buah',
      description:
          'Kawasan perkebunan belimbing manis unggulan Bojonegoro seluas 21 hektar yang dikelola 102 petani dengan panen 3-4 kali/tahun. Pengunjung dapat memilih & memetik belimbing manis besar langsung dari pohonnya di area kebun teduh berpaving, serta berburu olahan sirup, dodol, dan kerupuk belimbing.',
      address: 'Desa Ngringinrejo & Mojo, Kec. Kalitidu, Kab. Bojonegoro (±15 km barat kota)',
      openHours: '07.00 - 17.00 WIB',
      ticketPrice: 'Rp 5.000 / orang',
      facilities: ['Petik Belimbing Langsung', 'Gazebo Kebun Teduh', 'Pusat Olahan Belimbing', 'Jalan Paving Kerap', 'Warung Ala Desa', 'Parkir Area'],
      icon: Icons.nature_people_rounded,
      themeColor: const Color(0xFF84CC16),
      mapQuery: 'https://maps.app.goo.gl/LJUh4TQ7YMwWkiM67',
      imagePath: 'assets/images/kebun_belimbing.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1596386461350-326ccb383e9f?q=80&w=1000',
      transportInfo: 'Berjarak ±15 km (±20-25 menit) di sebelah barat Kota Bojonegoro. Berada dekat dengan destinasi Bendungan Gerak (Sungai Bengawan Solo).',
      tips: [
        'Petik dan nikmati buah belimbing manis besar langsung dari pohonnya.',
        'Cicipi oleh-oleh olahan lokal khas seperti sirup belimbing, dodol, dan kerupuk belimbing.',
        'Nikmati suasana kebun yang sejuk dinaungi pohon belimbing berusia 25 tahun.',
        'Saksikan Festival Belimbing tahunan yang dimeriahkan arak-arakan gunungan belimbing & seni reog.',
      ],
    ),
    TourismSpot(
      id: 'gofun_bojonegoro',
      title: 'GoFun Entertainment Complex',
      category: 'rekreasi',
      categoryLabel: 'Taman Rekreasi Modern & Festival',
      description:
          'Taman hiburan keluarga modern terbesar di Bojonegoro. Menghadirkan wahana Kiddy Land, Bianglala Raksasa, Rumah Hantu, Gokart, hingga wahana air. Suasana malam kian semarak dengan nuansa festival lampu warna-warni, panggung hiburan, spot selfie, serta pusat kuliner terlengkap.',
      address: 'Jl. Veteran No.5200, Plelen, Ngampel, Kec. Kapas, Kabupaten Bojonegoro, Jawa Timur 62181',
      openHours: '16.00 - 22.00 WIB (Selasa - Minggu)',
      ticketPrice: 'Kisaran Rp 25.000 - Rp 70.000',
      facilities: ['Kiddy Land & Bianglala', 'Gokart & Wahana Air', 'Rumah Hantu', 'Panggung Konser & Event', 'Area Foto Lampu Festival', 'Food Court Kuliner', 'Parkir VIP'],
      icon: Icons.attractions_rounded,
      themeColor: const Color(0xFFEC4899),
      mapQuery: 'https://maps.app.goo.gl/XnZGPju3W9xnCAqJA',
      imagePath: 'assets/images/gofun.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?q=80&w=1000',
      transportInfo: 'Terletak strategis di Jalan Veteran (Kapas), mudah dijangkau kendaraan pribadi maupun angkutan umum dari pusat kota Bojonegoro.',
      tips: [
        'Kunjungi pada sore hingga malam hari untuk menikmati gemerlap lampu festival yang indah.',
        'Pilihan ideal untuk acara liburan keluarga, rombongan sekolah, maupun hangout bersama teman.',
        'Pantau jadwal konser musik, festival kuliner, & pameran budaya yang kerap digelar di panggung utama.',
      ],
    ),
    TourismSpot(
      id: 'bendungan_gerak',
      title: 'Bendungan Gerak Bojonegoro',
      category: 'rekreasi',
      categoryLabel: 'Pemandangan Air & Lanskap',
      description:
          'Bendungan megah multifungsi penyangga air Sungai Bengawan Solo di lahan 1,84 juta m² dengan investasi pinjaman JICA Rp 351 miliar. Memiliki jembatan sepanjang 504 meter penghubung Desa Padang & Ngringinrejo (Kalitidu), penampung 13 juta m³ air irigasi 11.000 hektar sawah di 8 kecamatan, serta destinasi santai sore favorit warga.',
      address: 'Padang, Kec. Trucuk, Kabupaten Bojonegoro, Jawa Timur 62155',
      openHours: '24 Jam (Setiap Hari)',
      ticketPrice: 'Gratis',
      facilities: ['Jembatan Gerak 504m', 'Spot Panorama Bengawan Solo', 'Warung Ikan Wader Bakar', 'Taman & Area Santai', 'Area Jogging', 'Parkir Area'],
      icon: Icons.water_rounded,
      themeColor: const Color(0xFF0284C7),
      mapQuery: 'https://maps.app.goo.gl/vwbPyAKQNVLbq2Bf9',
      imagePath: 'assets/images/bendungan gerak.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1000',
      transportInfo: 'Terletak di Kecamatan Trucuk dan Kalitidu. Menghubungkan Desa Padang dengan Desa Ngringinrejo melalui jembatan sepanjang 504 meter, mudah diakses kendaraan pribadi.',
      tips: [
        'Kunjungi pada sore hari untuk menikmati pemandangan matahari terbenam (sunset) yang indah di atas Sungai Bengawan Solo.',
        'Nikmati hidangan kuliner lokal khas ikan wader goreng/bakar di warung-warung sekitar bendungan.',
        'Jelajahi jembatan 504 meter yang membuka akses transportasi wilayah Trucuk dan Kalitidu.',
      ],
    ),
    TourismSpot(
      id: 'waduk_pacal',
      title: 'Waduk Pacal Temayang',
      category: 'rekreasi',
      categoryLabel: 'Danau & Sejarah Kolonial 1933',
      description:
          'Waduk megah peninggalan kolonial Belanda tahun 1933 seluas 3.878 hektar (kedalaman 25m) di Desa Kedungsumber (35 km / ±1 jam dari kota). Menyajikan lanskap air luas dikelilingi hutan jati rindang & perbukitan hijau sejuk. Destinasi favorit untuk naik perahu wisata, memancing, foto prewedding klasik, dan wisata kuliner Ikan Gloso & Nila bakar.',
      address: 'Desa Kedungsumber, Kec. Temayang, Kab. Bojonegoro (35 km / ±1 jam dari Kota Bojonegoro)',
      openHours: '07.00 - 17.00 WIB',
      ticketPrice: 'Rp 5.000 / orang',
      facilities: ['Sewa Perahu Keliling Waduk', 'Spot Memancing', 'Kuliner Warung Semok (Ikan Gloso/Nila)', 'Gazebo & Hutan Jati Teduh', 'Souvenir Batik Jonegoroan (Desa Jono)', 'Area Parkir'],
      icon: Icons.sailing_rounded,
      themeColor: const Color(0xFF06B6D4),
      mapQuery: 'https://maps.app.goo.gl/QLNrLhFSkx4voeSM9',
      imagePath: 'assets/images/waduk-pacal.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=1000',
      transportInfo: 'Berjarak ±35 km (±1 jam) di sebelah selatan Kota Bojonegoro via Jl. Raya Waduk Pacal - Nganjuk dengan panorama rute hutan jati asri.',
      tips: [
        'Kunjungi saat musim hujan hingga sebelum puncak kemarau ketika volume air waduk melimpah.',
        'Cicipi sajian kuliner khas Ikan Gloso, Nila segar, & udang goreng sambal uleg di Warung Semok (3 km dari lokasi).',
        'Singgah ke Desa Jono (Kecamatan Temayang) untuk berburu souvenir Batik Jonegoroan khas.',
        'Gunakan topi/payung saat menjelajahi pelimpah & tanggul peninggalan Belanda tahun 1933.',
      ],
    ),

    // === TEMPAT SEJARAH & BUDAYA ===
    TourismSpot(
      id: 'samin_bojonegoro',
      title: 'Masyarakat Adat Samin Bojonegoro',
      category: 'sejarah_budaya',
      categoryLabel: 'Budaya Wargi Samin & Sedulur Sikep',
      description:
          'Kawasan cagar budaya wargi Samin (Wong Sikep) keturunan pengikut Samin Surosentiko (Raden Kohar, 1859-1914) di Pegunungan Kendeng. Memegang teguh falsafah "Sedulur Sikep"—semangat perlawanan pasif tanpa kekerasan menolak aturan Belanda & Jepang. Dikenal sangat menjunjung tinggi prinsip kejujuran, keteguhan ajaran, kerukunan, serta kelestarian alam.',
      address: 'Dusun Jatiroto, Desa Japang, Kec. Margomulyo, Kabupaten Bojonegoro, Jawa Timur 62168',
      openHours: '08.00 - 17.00 WIB (Buka Setiap Hari)',
      ticketPrice: 'Gratis / Infaq Sukarela',
      facilities: ['Kampung Adat Samin', 'Rumah Tradisional Kayu', 'Informasi Sejarah Samin Surosentiko', 'Pemandu Budaya Lokal', 'Spot Edukasi Sedulur Sikep', 'Parkir Area'],
      icon: Icons.groups_rounded,
      themeColor: const Color(0xFFD97706),
      mapQuery: 'https://maps.app.goo.gl/QQWxYtxddP842MsJ9',
      imagePath: 'assets/images/samin-bojonegoro.jpeg',
      imageUrl: 'https://images.unsplash.com/photo-1542810634-71277d95dcbb?q=80&w=1000',
      transportInfo: 'Berada di wilayah Pegunungan Kendeng di perbatasan Jawa Timur - Jawa Tengah (Kecamatan Margomulyo). Dapat diakses dengan kendaraan pribadi via jalur darat Margomulyo.',
      tips: [
        'Hormati adab, norma kesopanan, dan falsafah hidup warga "Wong Sikep" saat berkunjung.',
        'Pelajari nilai kejujuran luhur, kebersamaan sedulur sikep, serta perlawanan anti-kekerasan Samin Surosentiko.',
        'Mintalah izin secara santun kepada sesepuh atau warga sebelum mengambil foto/video dokumentasi.',
      ],
    ),
    TourismSpot(
      id: 'museum_rajekwesi',
      title: 'Museum Rajekwesi Bojonegoro',
      category: 'sejarah_budaya',
      categoryLabel: 'Museum & Sejarah Purbakala',
      description:
          'Museum cagar budaya & tempat belajar sejarah menyenangkan di Jalan Pahlawan (selatan Alun-Alun Bojonegoro). Terbuka untuk umum tanpa tiket masuk. Menampilkan koleksi lengkap 5 ruang pameran: Ruang 1 Masa Prasejarah (fosil gajah, tanduk rusa, tengkorak kuda nil, kerang & gigi hiu), Ruang 2 Masa Hindu-Buddha (artefak perdagangan global, gerabah kuno, arca Dewa Siwa & Ganesha, benda pusaka beraksara kuno), Ruang 3 Etnografi (lesung padi agraris, alat musik & senjata tradisional), Ruang 4 Kesenian & Pertunjukan Wayang (seperangkat gamelan interaktif yang bisa dicoba pengunjung), Ruang 5 Busana Adat khas Bojonegoro & pelaminan, serta Ruang Imersif tayangan film sinema sejarah peradaban Bojonegoro.',
      address: 'Jl. Pahlawan No.9, Kepatihan, Kec. Bojonegoro, Kabupaten Bojonegoro, Jawa Timur 62111',
      openHours: '09.00 - 16.00 WIB (Senin - Jumat)',
      ticketPrice: 'Gratis (Tanpa Tiket Masuk)',
      facilities: [
        'Ruang 1: Prasejarah & Fosil Purba',
        'Ruang 2: Artefak & Arca Hindu-Buddha',
        'Ruang 3: Etnografi & Lesung Padi',
        'Ruang 4: Gamelan & Pertunjukan Wayang',
        'Ruang 5: Busana Adat & Pelaminan',
        'Ruang Imersif Cinema Sejarah',
        'Andong Tradisional Depan Pintu',
        'Pemandu Museum Interaktif',
        'Satpam & Petunjuk Alur Kunjungan',
        'Area Parkir (Sebelah Kanan)',
        'Ruang Rapat & Toilet',
      ],
      icon: Icons.museum_rounded,
      themeColor: const Color(0xFF8B5CF6),
      mapQuery: 'Museum Rajekwesi Bojonegoro',
      imagePath: 'assets/images/Museum.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1566127444979-b3d2b654e3d7?q=80&w=1000',
      transportInfo:
          'Berada di jantung kota di Jalan Pahlawan (sebelah selatan Alun-Alun Bojonegoro). Sangat mudah dijangkau menggunakan kendaraan pribadi maupun transportasi umum.',
      tips: [
        'Disarankan menanyakan jadwal kosong terlebih dahulu agar kunjungan lebih nyaman dan tidak berbarengan dengan rombongan lain.',
        'Kunjungan diawali dengan registrasi dan mengikuti akun TikTok serta Instagram resmi Museum Rajekwesi Bojonegoro.',
        'Disambut oleh satpam ramah di area parkir sebelah kanan pintu masuk yang siap memberikan petunjuk alur kunjungan.',
        'Pengunjung dapat berfoto dengan Andong sebagai simbol transportasi tradisional masa lalu di depan pintu masuk.',
        'Coba memainkan alat musik gamelan secara langsung di Ruang 4 dengan pendampingan pemandu museum.',
        'Nikmati tayangan visual film sejarah peradaban Bojonegoro di Ruang Imersif sebagai penutup kunjungan.',
      ],
    ),
    TourismSpot(
      id: 'teksas_wonocolo',
      title: 'Sumur Tua Teksas Wonocolo (Geopark)',
      category: 'sejarah_budaya',
      categoryLabel: 'Warisan Budaya & Industri',
      description:
          'Museum minyak bumi terbuka (Little Texas) pertama di Indonesia yang menampilkan tradisi penambangan minyak secara tradisional menggunakan menara kayu yang telah berlangsung ratusan tahun.',
      address: 'Desa Wonocolo, Kec. Kedewan, Kab. Bojonegoro',
      openHours: '07.00 - 17.00 WIB',
      ticketPrice: 'Rp 10.000 / orang',
      facilities: ['Rig Minyak Kayu Tradisional', 'Museum Geo-Heritage', 'Spot Foto Puncak Bukit Penambangan', 'Warung Warga', 'Parkir'],
      icon: Icons.precision_manufacturing_rounded,
      themeColor: const Color(0xFFD97706),
      mapQuery: 'Teksas Wonocolo Bojonegoro',
      imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=1000',
    ),
    TourismSpot(
      id: 'wali_kidangan',
      title: 'Makam Wali Kidangan (Syeikh Mukodar / Raden Sentono)',
      category: 'religi',
      categoryLabel: 'Wisata Religi & Sejarah Islam Pajang',
      description:
          'Situs ziarah religi & cagar budaya di puncak Bukit Kidangan, tempat persemayaman Syeikh Mukodar (Raden Sentono / Pangeran Kumbang Ali-Ali), ulama besar keturunan Kasultanan Pajang penyebar agama Islam di Bojonegoro bagian barat. Dikenal sebagai "Wali Mastur" (wali yang menyembunyikan identitas diri & tirakat menyendiri di puncak bukit hingga wafat tahun 1018). Kompleks ini dikelilingi hutan jati dan bambu yang asri. Untuk menuju makam utama, peziarah melintasi gapura dan menaiki sekitar 500 anak tangga. Di puncak terdapat 3 makam: Wali Kidangan dan dua santri pengabdinya.',
      address: 'WP5Q+2HG, Sukorejo, Malo, Hutan, Perairan, Bojonegoro, Kabupaten Bojonegoro, Jawa Timur 62153',
      openHours: '24 Jam (Setiap Hari)',
      ticketPrice: 'Gratis / Infaq Sukarela',
      facilities: [
        '500 Anak Tangga Pendakian',
        'Gubuk Juru Kunci & Kendi Kesucian',
        'Pendopo Ziarah & Area Doa',
        'Hutan Jati & Bambu Asri',
        'Tempat Wudhu & Musholla',
        'Warung Makanan & Souvenir',
        'Area Parkir Luas',
      ],
      icon: Icons.mosque_rounded,
      themeColor: const Color(0xFF059669),
      mapQuery: 'Makam Wali Kidangan Malo Bojonegoro',
      imagePath: 'assets/images/Wali.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1542810634-71277d95dcbb?q=80&w=1000',
      transportInfo:
          'Berada di Bukit Kidangan, Dusun Kidangan, Desa Sukorejo, Kecamatan Malo (sekitar 1,5 km ke arah utara dari Jembatan Malo perlintasan Sungai Bengawan Solo). Dari gapura bawah, dilanjutkan dengan berjalan kaki menaiki 500 anak tangga menembus rimbunnya hutan jati dan bambu.',
      tips: [
        'Lepas alas kaki di gubuk gubuk papan kayu juru kunci sebelum memasuki area utama makam sebagai simbol menjaga kesucian.',
        'Nikmati kesegaran air minum gratis dari kendi tradisional yang disediakan oleh juru kunci di gubuk peristirahatan.',
        'Disarankan menyiapkan kondisi fisik yang fit untuk menaiki 500 anak tangga menuju puncak Bukit Kidangan.',
        'Kunjungi saat peringatan Haul Rutin Mbah Wali Kidangan setiap awal tahun baru Islam (1 Suro) untuk pengalaman spiritual budaya.',
        'Hormati adab berziarah dan jaga kebersihan rimbunnya hutan jati di sepanjang jalur tangga.',
      ],
    ),
    TourismSpot(
      id: 'klenteng_hok_swie_bio',
      title: 'Klenteng Hok Swie Bio',
      category: 'religi',
      categoryLabel: 'Wisata Religi & Tempat Ibadah Tri Dharma',
      description:
          'Klenteng Hok Swie Bio adalah salah satu tempat ibadah Tri Dharma ikonik bersejarah di Bojonegoro yang didominasi warna merah khas dengan ornamen batu ukiran naga berkepala unik dan tubuh berwarna biru di sepanjang dindingnya. Banyak dikunjungi peziarah dari Bojonegoro dan berbagai daerah setiap hari, terutama saat perayaan Hari Raya Imlek. Memiliki fasilitas area penginapan/istirahat untuk pengunjung yang ingin tinggal beberapa hari, serta suasana klenteng yang sangat bersih, asri, dan nyaman.',
      address: 'Jl. JAK Suprapto No. 127, Banjarejo, Kab. Bojonegoro',
      openHours: '07.00 - 17.00 WIB',
      ticketPrice: 'Gratis',
      facilities: [
        'Area Ibadah Utama Tri Dharma',
        'Ornamen Kepala & Tubuh Naga',
        'Kamar & Penginapan Peziarah',
        'Taman Klenteng Bersih & Nyaman',
        'Spot Foto Arsitektur Kuno',
        'Parkir Kendaraan',
      ],
      icon: Icons.temple_buddhist_rounded,
      themeColor: const Color(0xFFDC2626),
      mapQuery: 'Klenteng Hok Swie Bio Bojonegoro',
      imagePath: 'assets/images/kelenteng-hok-swie-bio.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1548013146-72479768bada?q=80&w=1000',
      transportInfo:
          'Terletak di pusat kota Bojonegoro di Jalan JAK Suprapto No. 127, Banjarejo. Sangat mudah dijangkau menggunakan kendaraan pribadi, ojek online, maupun transportasi umum.',
      tips: [
        'Jaga norma kesopanan dan ketenangan saat memasuki area ibadah Tri Dharma.',
        'Kunjungi saat puncak perayaan Hari Raya Imlek untuk menyaksikan kemeriahan ritual religi & budaya.',
        'Nikmati keindahan ornamen batu ukiran naga berkepala unik dan tubuh berwarna biru di dinding klenteng.',
        'Tersedia fasilitas tempat istirahat/penginapan bagi pengunjung luar kota yang ingin tinggal beberapa hari.',
      ],
    ),

    TourismSpot(
      id: 'makam_jojonegoro',
      title: 'Makam Adipati Jojonegoro',
      category: 'religi',
      categoryLabel: 'Wisata Religi & Sejarah Pendiri Bojonegoro',
      description:
          'Kompleks makam bersejarah leluhur pendiri Bojonegoro, Adipati Djojonegoro (R.A.A. Djojonegoro) di Desa Mojoranu, Kecamatan Dander. Beliau menjabat sebagai Adipati Bojonegoro selama 17 tahun dan berjasa besar menyatukan 3 wilayah kuno (Kabupaten Baureno, Mojoranu, dan Padangan) menjadi Kabupaten Rajegwesi. Makam ini rutin menjadi lokasi ziarah resmi Pj Bupati dan Forkopimda dalam rangkaian Hari Jadi Bojonegoro (HJB). Sesuai wasiat beliau, makam ini berada di Mojoranu dan ditemukan kembali pada 14 November 1991.',
      address: 'Sawah, Mojoranu, Kec. Dander, Kabupaten Bojonegoro, Jawa Timur 62171',
      openHours: '08.00 - 16.00 WIB (Setiap Hari)',
      ticketPrice: 'Gratis / Infaq Sukarela',
      facilities: [
        'Pendopo Makam Leluhur',
        'Area Ziarah & Doa',
        'Catatan Sejarah Adipati',
        'Area Parkir Kendaraan',
        'Tempat Ibadah & Wudhu',
      ],
      icon: Icons.history_edu_rounded,
      themeColor: const Color(0xFF475569),
      mapQuery: 'Makam Adipati Jojonegoro Bojonegoro',
      imagePath: 'assets/images/Makam_Adipati.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1596895111956-bf1cf0599ce5?q=80&w=1000',
      transportInfo:
          'Terletak di Desa Mojoranu, Kecamatan Dander, Kabupaten Bojonegoro. Sangat mudah dijangkau dari pusat Kota Bojonegoro ke arah selatan menuju Dander.',
      tips: [
        'Menjaga norma kesopanan, adab ziarah, dan kebersihan di sekitar kompleks makam leluhur.',
        'Setiap bulan Oktober rutin diadakan ziarah resmi oleh jajaran Pemkab Bojonegoro dalam rangkaian Hari Jadi Bojonegoro (HJB).',
        'Makam ini merupakan tempat bersejarah penyatuan 3 wilayah kuno (Baureno, Mojoranu, & Padangan) menjadi Kabupaten Rajegwesi.',
      ],
    ),
    TourismSpot(
      id: 'masjid_agung_darussalam',
      title: 'Masjid Agung Darussalam Bojonegoro',
      category: 'religi',
      categoryLabel: 'Wisata Religi & Masjid Bersejarah (1825)',
      description:
          'Masjid Agung Darussalam Bojonegoro merupakan salah satu masjid tertua dan paling bersejarah di Kabupaten Bojonegoro yang didirikan sejak tahun 1825. Terletak strategis di sebelah barat Alun-Alun Bojonegoro (Jl. KH. Hasyim Asy\'ari No. 21). Memiliki luas keseluruhan 3.562 m² dengan luas bangunan 2.422 m² 2 lantai yang mampu menampung 1.100 jemaah. Keunikan arsitekturnya terletak pada menara utama berbentuk spiral yang artistik, pilar-pilar kayu jati asli bersejarah berdirinya masjid yang tetap dipertahankan, serta interior megah dihiasi lampu-lampu kristal mewah. Lantai 1 difungsikan untuk mimbar, jemaah pria, dan jemaah wanita, sedangkan lantai 2 khusus untuk jemaah wanita.',
      address: 'Jl. KH. Hasyim Asy\'ari No. 21, Kauman, Kec. Bojonegoro, Kab. Bojonegoro (Barat Alun-Alun)',
      openHours: '24 Jam (Setiap Hari)',
      ticketPrice: 'Gratis',
      facilities: [
        'Ruang Utama Ibadah 2 Lantai (1.100 Jemaah)',
        'Menara Spiral Unik & Artistik',
        'Pilar Kayu Jati Bersejarah (1825)',
        'Interior Lampu Kristal Mewah',
        'Area Ibadah Pria & Wanita Terpisah',
        'Tempat Wudhu & Toilet Pria/Wanita',
        'Area Parkir Luas',
      ],
      icon: Icons.mosque_rounded,
      themeColor: const Color(0xFF059669),
      mapQuery: 'Masjid Agung Darussalam Bojonegoro',
      imagePath: 'assets/images/masjid-agung-darusalam-bojonegoro.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1542810634-71277d95dcbb?q=80&w=1000',
      transportInfo:
          'Berada tepat di sebelah barat Alun-Alun Kota Bojonegoro di Jl. KH. Hasyim Asy\'ari No. 21. Sangat mudah dijangkau dari berbagai titik kota menggunakan kendaraan pribadi, ojek online, maupun angkutan umum.',
      tips: [
        'Nikmati keunikan arsitektur menara spiral artistik dan interior lampu kristal mewah.',
        'Melihat pilar-pilar kayu jati bersejarah yang dipertahankan sejak berdirinya masjid pada tahun 1825.',
        'Lantai 2 khusus difungsikan untuk jemaah perempuan.',
        'Sangat nyaman dijadikan tempat beribadah sekaligus lokasi rest area di pusat kota Bojonegoro.',
      ],
    ),
    TourismSpot(
      id: 'masjid_margomulyo',
      title: 'Masjid An Nahdla',
      category: 'religi',
      categoryLabel: 'Wisata Religi & Arsitektur Islami-Jawa',
      description:
          'Masjid An Nahdla adalah ikon wisata religi megah di atas lahan 2,9 hektar di kawasan barat Bojonegoro yang memadukan keindahan arsitektur Aljaferia Andalusia (Timur Tengah) dan ukiran Gebyok Jawa klasik. Dibuka resmi sejak 27 Desember 2024, bangunan ini kaya akan simbolisme Islam: 9 pancuran air dan 9 tiang utama melambangkan Wali Songo (Soko Guru Islam Jawa), 4 gerbang & 4 kubah anak melambangkan 4 Mazhab (Syafi’i, Maliki, Hambali, Hanafi), 5 kubah utama melambangkan Rukun Islam, serta 25 kubah selasar melambangkan 25 Nabi & Rasul dengan kubah gerbang khusus pengagungan Nabi Muhammad SAW. Berfungsi sebagai tempat ibadah, wisata religi, dan rest area perbatasan Bojonegoro-Ngawi.',
      address: 'Dusun Bungkul, Desa Sumberejo, Kec. Margomulyo, Kab. Bojonegoro (Perbatasan Ngawi)',
      openHours: '24 Jam (Setiap Hari)',
      ticketPrice: 'Gratis',
      facilities: [
        'Gedung Utama Desain Bulat & Zig-zag',
        '9 Tiang Utama & 9 Pancuran Wali Songo',
        'Selasar 25 Kubah Nabi & Rasul',
        'Ruang Kantor & Perpustakaan Islam',
        'Pelataran & Kolam Hias (1.877 Jemaah)',
        'Parkir Luas (99 Mobil & 7 Bus)',
        'Rest Area Perbatasan Bojonegoro-Ngawi',
        'Area Kios UMKM Warga Lokal',
      ],
      icon: Icons.mosque_rounded,
      themeColor: const Color(0xFF0D9488),
      mapQuery: 'Masjid An Nahdla Margomulyo Bojonegoro',
      imagePath: 'assets/images/Masjid.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1564769625905-50e93615e769?q=80&w=1000',
      transportInfo:
          'Terletak di Dusun Bungkul, Desa Sumberejo, Kecamatan Margomulyo, Kabupaten Bojonegoro di jalur utama perbatasan Ngawi. Sangat mudah dijangkau dari perbatasan barat Bojonegoro sebagai tempat beribadah dan rest area.',
      tips: [
        'Resapi makna filosofis bangunan masjid mulai dari 9 tiang Wali Songo hingga 25 kubah selasar Nabi & Rasul.',
        'Sangat cocok dijadikan rest area dan tempat salat berjamaah saat melintasi jalur barat Bojonegoro-Ngawi.',
        'Menikmati suasana arsitektur unik perpaduan gaya Andalusia & Gebyok Jawa pada pagi atau sore hari.',
        'Selalu menjaga kesucian, adab ibadah, dan kebersihan di seluruh komplek Masjid An-Nahdla.',
      ],
    ),
    TourismSpot(
      id: 'teksas_wonocolo',
      title: 'Geosite Teksas Wonocolo',
      category: 'sejarah_budaya',
      categoryLabel: 'Wisata Edukasi Migas & Petroleum Geopark',
      description:
          'Destinasi wisata edukasi migas pertama di Indonesia berbasis geopark sumur minyak tua prasejarah peninggalan Belanda sejak abad ke-19 di Desa Wonocolo, Kecamatan Kedewan. Terdapat lebih dari 720 sumur minyak tua yang masih dieksploitasi secara tradisional oleh masyarakat lokal menggunakan mesin mobil bekas dan rig kayu jati. Menjadi lokasi pemboran minyak tradisional terdangkal di dunia (ketinggian reservoir 450 mdpl di atas permukaan laut). "Teksas" merupakan singkatan dari "Tekad Selalu Aman dan Sejahtera". Fasilitas unggulan meliputi Rumah Singgah (Learning Center & Museum Mini Migas), simulasi pengeboran, geotourism trails, tur Jeep Adventure menjelajah perbukitan tambang, gardu pandang, dan musholla.',
      address: 'Wonocolo, Kec. Kedewan, Kabupaten Bojonegoro, Jawa Timur 62164 (± 60 km pusat kota)',
      openHours: '08.00 - 17.00 WIB (Setiap Hari)',
      ticketPrice: 'Gratis / Restribusi Parkir',
      facilities: [
        'Rumah Singgah / Museum Mini Migas',
        'Wisata Offroad Jeep Adventure',
        '720 Sumur Minyak Tua Tradisional',
        'Gardu Pandang & Spot Geotourism',
        'Simulasi Pengeboran Tradisional',
        'Musholla & Rest Area',
        'Warung Kuliner & Souvenir Lokal',
      ],
      icon: Icons.landscape_rounded,
      themeColor: const Color(0xFFD97706),
      mapQuery: 'Teksas Wonocolo Bojonegoro',
      imagePath: 'assets/images/Teksas Wonocolo.jpg',
      imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=1000',
      transportInfo:
          'Berjarak sekitar 60 km dari pusat kota Bojonegoro ke arah barat perbatasan Kabupaten Blora. Akses dapat ditempuh menggunakan kendaraan roda dua, roda empat, maupun rombongan jeep adventure.',
      tips: [
        'Kunjungi Rumah Singgah (Learning Center) untuk memahami sejarah dan proses pengeboran minyak tradisional.',
        'Cobalah sensasi menjelajah medan perbukitan tambang dengan paket wisata Jeep Adventure.',
        'Patuhi standar keselamatan dan petunjuk pemandu wisata di area sumur minyak aktif.',
        'Kunjungi gardu pandang untuk pemandangan panorama unik mirip kawasan minyak Texas Amerika.',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<TourismSpot> _getFilteredSpots(String category) {
    return _spots.where((spot) {
      final matchesCategory = spot.category == category ||
          (category == 'religi' && (spot.category == 'religi' || spot.id == 'klenteng_hok_swie_bio' || spot.id == 'makam_jojonegoro')) ||
          (category == 'sejarah_budaya' && (spot.category == 'sejarah_budaya' || spot.id == 'wali_kidangan' || spot.id == 'makam_jojonegoro' || spot.id == 'masjid_agung_darussalam' || spot.id == 'teksas_wonocolo')) ||
          ((spot.id == 'kayangan_api' || spot.id == 'teksas_wonocolo') && (category == 'rekreasi' || category == 'sejarah_budaya'));
      final matchesQuery = _searchQuery.isEmpty ||
          spot.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          spot.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          spot.address.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _openDetailScreen(TourismSpot spot) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TourismDetailScreen(
          spot: spot,
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06B6D4), // Cyan theme for Pariwisata
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pariwisata Bojonegoro',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kTextTabBarHeight + 10),
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
              controller: _tabController,
              isScrollable: true,
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFFCFFAFE),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
            Tab(
              icon: Icon(Icons.attractions_rounded, size: 20),
              text: 'Tempat Rekreasi',
            ),
            Tab(
              icon: Icon(Icons.account_balance_rounded, size: 20),
              text: 'Sejarah & Budaya',
            ),
            Tab(
              icon: Icon(Icons.mosque_rounded, size: 20),
              text: 'Wisata Religi',
            ),
          ],
        ),
      ),
    ),
  ),
  body: Column(
        children: [
          // Search Input Bar
          Container(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: TextStyle(fontSize: 13.5, color: isDark ? Colors.white : const Color(0xFF0F172A)),
              decoration: InputDecoration(
                hintText: 'Cari destinasi wisata atau lokasi...',
                hintStyle: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF06B6D4)),
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
                fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Tab View List Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSpotList(_getFilteredSpots('rekreasi'), isDark),
                _buildSpotList(_getFilteredSpots('sejarah_budaya'), isDark),
                _buildSpotList(_getFilteredSpots('religi'), isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotList(List<TourismSpot> spots, bool isDark) {
    if (spots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 54, color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8)),
            const SizedBox(height: 12),
            Text(
              'Destinasi tidak ditemukan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Coba kata kunci pencarian yang lain.',
              style: TextStyle(fontSize: 12.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: spots.length,
      itemBuilder: (context, index) {
        final spot = spots[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 30 : 10),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _openDetailScreen(spot),
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSpotImage(spot, height: 170, borderRadius: const BorderRadius.vertical(top: Radius.circular(18))),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: spot.themeColor.withAlpha(25),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(spot.icon, color: spot.themeColor, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  spot.title,
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  spot.categoryLabel,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: spot.themeColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        spot.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded, size: 14, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              spot.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.confirmation_number_rounded, size: 14, color: Color(0xFF06B6D4)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      spot.ticketPrice,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF334155),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () => _openDetailScreen(spot),
                            style: TextButton.styleFrom(
                              foregroundColor: spot.themeColor,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                            icon: const Text('Detail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            label: const Icon(Icons.arrow_forward_rounded, size: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Image Loader Helper for Local Asset & Network Fallback
Widget _buildSpotImage(TourismSpot spot, {double height = 200, BorderRadius? borderRadius}) {
  Widget placeholder = _buildImagePlaceholder(spot, height);

  if (spot.id == 'kayangan_api') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        khayanganApiBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'atas_angin') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        negeriAtasAnginBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'belimbing_ngringinrejo') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        kebunBelimbingBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'gofun_bojonegoro') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        gofunBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'bendungan_gerak') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        bendunganGerakBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'waduk_pacal') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        wadukPacalBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'samin_bojonegoro') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        saminBojonegoroBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'museum_rajekwesi') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        museumRajekwesiBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'wali_kidangan') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        waliKidanganBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'klenteng_hok_swie_bio') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        klentengHokSwieBioBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'masjid_agung_darussalam') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        masjidAgungDarussalamBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'makam_jojonegoro') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        makamJojonegoroBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'masjid_margomulyo') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        masjidAnNahdlaBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.id == 'teksas_wonocolo') {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.memory(
        teksasWonocoloBytes,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  if (spot.imagePath != null) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.asset(
        spot.imagePath!,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          if (spot.imageUrl != null) {
            return Image.network(
              spot.imageUrl!,
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, err, stack) => placeholder,
            );
          }
          return placeholder;
        },
      ),
    );
  } else if (spot.imageUrl != null) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Image.network(
        spot.imageUrl!,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, err, stack) => placeholder,
      ),
    );
  }
  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(16),
    child: placeholder,
  );
}

Widget _buildImagePlaceholder(TourismSpot spot, double height) {
  return Container(
    width: double.infinity,
    height: height,
    color: spot.themeColor.withAlpha(25),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(spot.icon, size: 44, color: spot.themeColor),
          const SizedBox(height: 6),
          Text(
            spot.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: spot.themeColor, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}

// === FULL 1 LAYAR PENUH DETAIL SCREEN ===
class TourismDetailScreen extends StatelessWidget {
  final TourismSpot spot;
  final bool isDarkMode;

  const TourismDetailScreen({
    super.key,
    required this.spot,
    required this.isDarkMode,
  });

  void _openGoogleMaps(String query) async {
    final Uri url = Uri.parse(
      query.startsWith('http') ? query : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Full-screen Slivers Header Image with Back Button
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: spot.themeColor,
            leading: CircleAvatar(
              backgroundColor: Colors.black.withAlpha(120),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                spot.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 10)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildSpotImage(spot, height: 280, borderRadius: BorderRadius.zero),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Detail Content (Full 1 Layar Page)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: spot.themeColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(spot.icon, color: spot.themeColor, size: 24),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: spot.themeColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          spot.categoryLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: spot.themeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Tentang Destinasi Wisata',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    spot.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 14),

                  // Information Cards
                  _buildDetailCard(Icons.location_on_rounded, 'Alamat Lengkap', spot.address, spot.themeColor, isDark),
                  const SizedBox(height: 12),
                  _buildDetailCard(Icons.access_time_filled_rounded, 'Jam Operasional', spot.openHours, spot.themeColor, isDark),
                  const SizedBox(height: 12),
                  _buildDetailCard(Icons.confirmation_number_rounded, 'Harga Tiket Masuk', spot.ticketPrice, spot.themeColor, isDark),
                  const SizedBox(height: 20),

                  Text(
                    'Fasilitas Lengkap:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: spot.facilities.map((fasi) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 14, color: spot.themeColor),
                            const SizedBox(width: 6),
                            Text(
                              fasi,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (spot.transportInfo != null) ...[
                    const SizedBox(height: 20),
                    _buildDetailCard(Icons.directions_car_rounded, 'Akses & Transportasi', spot.transportInfo!, spot.themeColor, isDark),
                  ],
                  if (spot.tips != null && spot.tips!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Tips & Saran Pengunjung:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: spot.themeColor.withAlpha(15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: spot.themeColor.withAlpha(40),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: spot.tips!.map((tip) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.lightbulb_rounded, size: 16, color: spot.themeColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    tip,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openGoogleMaps(spot.mapQuery),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: spot.themeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.map_rounded, size: 22),
                      label: const Text(
                        'Petunjuk Arah (Google Maps)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String title, String value, Color color, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
