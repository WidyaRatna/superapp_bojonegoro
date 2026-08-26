class NewsItem {
  final String id;
  final String title;
  final String category;
  final String snippet;
  final String content;
  final String imageUrl;
  final String date;
  final String readTime;
  final int likes;
  final int views;
  final bool isFeatured;
  final String webUrl;

  NewsItem({
    required this.id,
    required this.title,
    required this.category,
    required this.snippet,
    required this.content,
    required this.imageUrl,
    required this.date,
    required this.readTime,
    required this.likes,
    required this.views,
    this.isFeatured = false,
    this.webUrl = 'https://bojonegorokab.go.id/berita',
  });
}

final List<NewsItem> sampleNews = [
  NewsItem(
    id: 'news-web-1',
    title: 'Merti Dusun Gondosuli Jadi Upaya Pelestarian Adat dan Tradisi',
    category: 'Budaya & Tradisi',
    snippet: 'Masyarakat Dusun Gondosuli menggelar tradisi Merti Dusun sebagai bentuk wujud syukur dan perwujudan pelestarian adat budaya.',
    content: '''
Bojonegorokab.go.id – Warga Dusun Gondosuli antusias menggelar kegiatan Merti Dusun Gondosuli sebagai wujud rasa syukur atas hasil bumi dan limpahan rahmat Tuhan Yang Maha Esa.

Kegiatan adat yang diisi dengan arak-arakan tumpeng, pagelaran seni tradisional, dan doa bersama ini dihadiri oleh tokoh masyarakat serta jajaran Pemerintah Kabupaten Bojonegoro.

Melalui kegiatan ini, diharapkan tradisi lokal Bojonegoro tetap lestari, mempererat tali silaturahmi antarwarga, serta mendukung potensi pariwisata budaya daerah.
''',
    imageUrl: 'https://bojonegorokab.go.id/storage/uploads/artikel/tMmti6EpX7Eu21Wh.jpg',
    date: 'Jumat, 14 Agustus 2026',
    readTime: '3 mnt baca',
    likes: 245,
    views: 1890,
    isFeatured: true,
    webUrl: 'https://bojonegorokab.go.id/berita/9898/merti-dusun-gondosuli-jadi-upaya-pelestarian-adat-dan-tradisi',
  ),
  NewsItem(
    id: 'news-web-2',
    title: 'Kirab Gelar Kenduri Sendangsari, Rawat Tradisi dan Perkuat Gotong Royong Warga',
    category: 'Budaya & Tradisi',
    snippet: 'Prosesi kirab dan kenduri Sendangsari belangsung khidmat dan meriah, menguatkan semangat gotong royong antar elemen warga.',
    content: '''
Bojonegorokab.go.id – Kemeriahan Kirab Gelar Kenduri Sendangsari menjadi bukti nyata semangat kebersamaan dan kegotongroyongan warga Bojonegoro yang masih terjaga erat.

Berbagai iring-iringan kostum adat, gunungan hasil bumi, dan sajian kenduri dinikmati bersama oleh ratusan warga. Pemkab Bojonegoro terus berkomitmen memberikan apresiasi dan dukungan penuh terhadap pelestarian warisan budaya asli daerah.
''',
    imageUrl: 'https://bojonegorokab.go.id/storage/uploads/artikel/BTrM29YQc4yTloTO.jpg',
    date: 'Jumat, 14 Agustus 2026',
    readTime: '4 mnt baca',
    likes: 198,
    views: 1540,
    webUrl: 'https://bojonegorokab.go.id/berita/9896/kirab-gelar-kenduri-sendangsari-rawat-tradisi-dan-perkuat-gotong-royong-warga',
  ),
  NewsItem(
    id: 'news-web-3',
    title: 'Fachri Akbar Siswa SMAN 1 Bojonegoro Raih Prestasi Membanggakan, Terpilih Jadi Duta SMA Nasional 2026',
    category: 'Pendidikan & Pemuda',
    snippet: 'Siswa asal Bojonegoro berhasil mengukir prestasi tingkat nasional sebagai Duta SMA Nasional 2026 mewakili Jawa Timur.',
    content: '''
Bojonegorokab.go.id – Prestasi membanggakan kembali ditorehkan oleh generasi muda Kabupaten Bojonegoro. Fachri Akbar, siswa SMAN 1 Bojonegoro, berhasil terpilih menjadi Duta SMA Nasional 2026.

Penetapan ini didapatkan setelah melalui tahapan seleksi ketat mulai tingkat kabupaten, provinsi, hingga final nasional yang diselenggarakan oleh Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi.
''',
    imageUrl: 'https://bojonegorokab.go.id/storage/uploads/artikel/xlFufOKWTdVrYbMS.jpg',
    date: 'Sabtu, 15 Agustus 2026',
    readTime: '3 mnt baca',
    likes: 312,
    views: 2450,
    webUrl: 'https://bojonegorokab.go.id/berita/9901/fachri-akbar-siswa-sman-1-bojonegoro-raih-prestasi-membanggakan-terpilih-jadi-duta-sma-nasional-2026',
  ),
  NewsItem(
    id: 'news-web-4',
    title: 'Paskibraka Bojonegoro Resmi Dikukuhkan Bupati Setyo Wahono, Siap Bertugas di Upacara HUT Ke-81 RI',
    category: 'Pemerintahan',
    snippet: 'Sebanyak 72 anggota Paskibraka Kabupaten Bojonegoro resmi dikukuhkan dan siap mengibarkan Sang Merah Putih.',
    content: '''
Bojonegorokab.go.id – Bupati Bojonegoro Setyo Wahono secara resmi mengukuhkan 72 anggota Pasukan Pengibar Bendera Pusaka (Paskibraka) Kabupaten Bojonegoro Tahun 2026 di Pendopo Malowopati.

Para anggota Paskibraka yang merupakan putra-putri terbaik dari SMA/SMK/MA se-Kabupaten Bojonegoro ini telah menjalani latihan intensif dan siap bertugas pada Upacara Peringatan Detik-Detik Proklamasi Kemerdekaan RI.
''',
    imageUrl: 'https://bojonegorokab.go.id/storage/uploads/artikel/14eaI2Ll6quyf68l.jpg',
    date: 'Jumat, 14 Agustus 2026',
    readTime: '3 mnt baca',
    likes: 420,
    views: 3100,
    webUrl: 'https://bojonegorokab.go.id/berita/9899/paskibraka-bojonegoro-resmi-dikukuhkan-bupati-setyo-wahono-siap-bertugas-di-upacara-hut-ke-81-ri',
  ),
  NewsItem(
    id: 'news-web-5',
    title: 'BEJO CAREER DAY 2026 Segera Digelar, Ada 1.000 Loker Bagi Warga Bojonegoro dari Puluhan Perusahaan',
    category: 'Ketenagakerjaan',
    snippet: 'Dinas Perindustrian dan Tenaga Kerja Bojonegoro menggelar bursa kerja menghadirkan 1.000 lowongan pekerjaan.',
    content: '''
Bojonegorokab.go.id – Pemerintah Kabupaten Bojonegoro melalui Dinas Perindustrian dan Tenaga Kerja (Disperinaker) akan menyelenggarakan Bejo Career Day 2026.

Kegiatan bursa kerja terbesar di Bojonegoro ini melibatkan puluhan perusahaan lokal dan nasional dengan menyediakan lebih dari 1.000 formasi lowongan pekerjaan bagi pencari kerja asal Bojonegoro.
''',
    imageUrl: 'https://bojonegorokab.go.id/storage/uploads/artikel/zWKScbMGLP4v8DOj.jpg',
    date: 'Jumat, 14 Agustus 2026',
    readTime: '4 mnt baca',
    likes: 380,
    views: 2950,
    webUrl: 'https://bojonegorokab.go.id/berita/9895/bejo-career-day-2026-segera-digelar-ada-1000-loker-bagi-warga-bojonegoro-dari-puluhan-perusahaan',
  ),
  NewsItem(
    id: 'news-web-6',
    title: 'Gelar Yudisium, STIT Muhammadiyah Bojonegoro Tekankan Lulusan Harus Berdampak bagi Masyarakat',
    category: 'Pendidikan',
    snippet: 'STIT Muhammadiyah Bojonegoro melepas puluhan calon wisudawan dengan pesan pengabdian kepada masyarakat.',
    content: '''
Bojonegorokab.go.id – Sekolah Tinggi Ilmu Tarbiyah (STIT) Muhammadiyah Bojonegoro sukses menggelar rapat senat terbuka dalam rangka Yudisium Sarjana.

Ketua STIT Muhammadiyah menekankan agar seluruh lulusan mampu mengaplikasikan ilmu pengetahuan dan integritas moral untuk memberikan kontribusi nyata bagi pembangunan daerah Bojonegoro.
''',
    imageUrl: 'https://bojonegorokab.go.id/storage/uploads/artikel/9vnaptjszgqgLYJ7.jpg',
    date: 'Sabtu, 15 Agustus 2026',
    readTime: '3 mnt baca',
    likes: 165,
    views: 1210,
    webUrl: 'https://bojonegorokab.go.id/berita/9900/gelar-yudisium-stit-muhammadiyah-bojonegoro-tekankan-lulusan-harus-berdampak-bagi-masyarakat',
  ),
];

