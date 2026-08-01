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
  });
}

final List<NewsItem> sampleNews = [
  NewsItem(
    id: 'news-1',
    title: 'Pemkab Bojonegoro Resmikan Jalur Lingkar Baru untuk Kelancaran Lalu Lintas',
    category: 'Pembangunan',
    snippet: 'Pembangunan infrastruktur jalan lingkar selesai lebih cepat dari jadwal dan siap digunakan masyarakat.',
    content: '''
Pemerintah Kabupaten Bojonegoro secara resmi meresmikan penggunaan jalan lingkar baru sepanjang 14,5 km yang menghubungkan beberapa kecamatan strategis di Bojonegoro. 

Bupati Bojonegoro menyampaikan bahwa proyek pembangunan ini merupakan bagian dari komitmen pemerintah daerah untuk mempercepat konektivitas antar wilayah, menekan angka kemacetan di pusat kota, serta mendorong pertumbuhan ekonomi kawasan sekitar.

"Dengan selesainya jalur lingkar ini, kita berharap arus distribusi barang dan mobilisasi warga menjadi jauh lebih cepat dan aman," ujar Bupati dalam sambutannya saat peresmian.

Jalur ini juga dilengkapi dengan lampu penerangan bertenaga surya, trotoar ramah difabel, dan jalur khusus sepeda.
''',
    imageUrl: 'https://images.unsplash.com/photo-1545558014-8692077e9b5c?auto=format&fit=crop&w=800&q=80',
    date: '29 Juli 2026',
    readTime: '3 mnt baca',
    likes: 142,
    views: 1250,
    isFeatured: true,
  ),
  NewsItem(
    id: 'news-2',
    title: 'Program Beasiswa Bojonegoro Buka Pendaftaran untuk 1.000 Mahasiswa Prestasi',
    category: 'Pendidikan',
    snippet: 'Beasiswa Penuh untuk jenjang S1 dan D4 diperuntukkan bagi mahasiswa berprestasi dan kurang mampu.',
    content: '''
Dinas Pendidikan Kabupaten Bojonegoro kembali membuka pendaftaran Program Beasiswa Daerah 2026. Target tahun ini adalah menyaring 1.000 mahasiswa asal Bojonegoro yang sedang menempuh pendidikan perguruan tinggi.

Program ini mencakup bantuan biaya kuliah full-tuition serta uang saku bulanan. Pendaftaran dilakukan secara daring melalui fitur Pendidikan di aplikasi Super App Bojonegoro.

Persyaratan lengkap dan mekanisme seleksi dapat diakses langsung oleh masyarakat mulai hari ini hingga akhir bulan depan.
''',
    imageUrl: 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=800&q=80',
    date: '28 Juli 2026',
    readTime: '4 mnt baca',
    likes: 298,
    views: 3100,
  ),
  NewsItem(
    id: 'news-3',
    title: 'Inovasi Layanan Kesehatan Digital: RSUD Sediakan Telemedicine Gratis',
    category: 'Kesehatan',
    snippet: 'Masyarakat kini dapat berkonsultasi dengan dokter spesialis secara daring dari rumah tanpa biaya.',
    content: '''
RSUD Dr. R. Sosodoro Djatikoesoemo Bojonegoro meluncurkan layanan Telemedicine terintegrasi melalui Super App Bojonegoro.

Melalui layanan ini, pasien dapat melakukan konsultasi via panggilan video dengan dokter umum maupun spesialis, serta mendapatkan resep obat yang dapat dikirimkan langsung ke rumah pasien.

"Kami ingin memastikan seluruh warga Bojonegoro mendapat akses pelayanan kesehatan yang cepat, terjangkau, dan tanpa hambatan jarak," ungkap Direktur RSUD.
''',
    imageUrl: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&w=800&q=80',
    date: '27 Juli 2026',
    readTime: '2 mnt baca',
    likes: 87,
    views: 940,
  ),
  NewsItem(
    id: 'news-4',
    title: 'Festival Budaya & UMKM Bojonegoro 2026 Siap Digelar Akhir Pekan Ini',
    category: 'Budaya & Ekonomi',
    snippet: 'Ratusan pelaku UMKM lokal dan pertunjukan seni tradisional akan menyemarakkan alun-alun Bojonegoro.',
    content: '''
Dinas Kebudayaan dan Pariwisata Bojonegoro akan mengelar Festiva Budaya dan Pameran UMKM Kreatif 2026 di Alun-Alun Bojonegoro.

Acara tahunan ini akan menampilkan tari tradisional Tari Thengul, bazar kuliner khas seperti Ledre dan Kripik Tempe, serta pameran kerajinan jati.

Pengunjung juga dapat menikmati pertunjukan musik live dan perlombaan fotografi. Tiket masuk gratis untuk seluruh masyarakat.
''',
    imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80',
    date: '26 Juli 2026',
    readTime: '5 mnt baca',
    likes: 312,
    views: 2890,
  ),
  NewsItem(
    id: 'news-5',
    title: 'Panen Raya Padi Organik di Soko Capai Rekor Produktivitas Tinggi',
    category: 'Ekonomi',
    snippet: 'Penggunaan pupuk organik ramah lingkungan terbukti tingkatkan hasil panen hingga 25%.',
    content: '''
Para petani di Kecamatan Soko Bojonegoro merayakan hasil panen raya padi organik yang mengalami peningkatan signifikan dibanding tahun sebelumnya.

Dinas Ketahanan Pangan dan Pertanian memberikan pendampingan teknologi pengolahan tanah berbasis organik serta sistem pengairan modern yang efisien hemat air.

Keberhasilan ini menjadikan Bojonegoro salah satu lumbung pangan organik percontohan di Jawa Timur.
''',
    imageUrl: 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=800&q=80',
    date: '25 Juli 2026',
    readTime: '3 mnt baca',
    likes: 176,
    views: 1820,
  ),
];
