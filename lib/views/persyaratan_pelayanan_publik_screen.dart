import 'package:flutter/material.dart';
import '../widgets/superapp_header.dart';
import '../widgets/admin/admin_form_dialog.dart';

class PersyaratanPelayananPublikScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;
  final bool isAdmin;

  const PersyaratanPelayananPublikScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
    this.isAdmin = false,
  });

  @override
  State<PersyaratanPelayananPublikScreen> createState() => _PersyaratanPelayananPublikScreenState();
}

class _PersyaratanPelayananPublikScreenState extends State<PersyaratanPelayananPublikScreen> {
  int _expandedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _serviceRequirements = [
    {
      'id': 'A',
      'title': 'A. KEPENGURUSAN KIS (PBI DAERAH)',
      'icon': Icons.medical_services_rounded,
      'color': const Color(0xFF0D62F1),
      'waktu': '1 - 3 Hari Kerja',
      'biaya': 'Gratis (Rp 0)',
      'sections': [
        {
          'subtitle': 'Persyaratan pengurusan sebagai berikut:',
          'items': [
            'Surat Pengantar dari desa mengetahui camat',
            'a. Fotokopi KTP',
            'b. Fotokopi KK',
          ],
        },
      ],
    },
    {
      'id': 'B',
      'title': 'B. PERSYARATAN KE RUMAH SINGGAH SURABAYA',
      'icon': Icons.house_rounded,
      'color': const Color(0xFF059669),
      'waktu': '1 Hari Kerja',
      'biaya': 'Gratis (Rp 0)',
      'sections': [
        {
          'subtitle': 'Persyaratan untuk ke rumah singgah Surabaya sebagai berikut:',
          'items': [
            'Surat rujukan dari RSUD Bojonegoro kepada RS Dr. Soetomo Surabaya',
            'Fotokopi KK',
            'Kartu pasien (SKM, Jamkesda, KIS)',
            'KTP / Akte pasien',
            'KTP yang mendampingi',
          ],
        },
      ],
    },
    {
      'id': 'C',
      'title': 'C. REKOMENDASI KIP & BEASISWA 1 DESA 10 SARJANA',
      'icon': Icons.school_rounded,
      'color': const Color(0xFFD97706),
      'waktu': '2 - 3 Hari Kerja',
      'biaya': 'Gratis (Rp 0)',
      'sections': [
        {
          'subtitle': 'Rekomendasi KIP (Kartu Indonesia Pintar):',
          'items': [
            'Data Keluarga masuk dalam DTKS',
            'Fotokopi KK dan KTP',
            'Surat pengantar dari desa',
          ],
        },
        {
          'subtitle': 'Persyaratan Pemberian Surat Keterangan / Rekomendasi Kepengurusan Beasiswa 1 Desa 10 Sarjana:',
          'items': [
            'Surat keterangan dari Perguruan Tinggi',
            'Fotokopi KTP Orang tua (penerima PKH)',
            'Fotokopi KTP pemohon',
            'Fotokopi KK (Pemohon harus masih terdaftar dalam satu KK)',
            'Penerima PKH harus masuk SP2D (Data Bayar) Tahun berjalan',
            'Fotokopi KKS dan Buku Tabungan',
          ],
        },
      ],
    },
    {
      'id': 'D',
      'title': 'D. PERSYARATAN PENDAFTARAN LKS "LEMBAGA KESEJAHTERAAN SOSIAL"',
      'icon': Icons.corporate_fare_rounded,
      'color': const Color(0xFF7C3AED),
      'waktu': '3 - 5 Hari Kerja',
      'biaya': 'Gratis (Rp 0)',
      'sections': [
        {
          'subtitle': 'Persyaratan Pendaftaran LKS:',
          'items': [
            'Proposal Singkat',
            'Data anak asuh',
            'Fotokopi SK Akreditasi',
            'Fotokopi Akta Notaris',
            'Fotokopi SK Kemenkumham',
            'Fotokopi NPWP LKS',
            'Fotokopi KTP Ketua LKS',
            'Fotokopi Rekening LKS',
            'Foto Kegiatan anak',
            'Surat Keterangan Domisili',
          ],
        },
      ],
    },
    {
      'id': 'E',
      'title': 'E. ADOPSI / PENGANGKATAN ANAK',
      'icon': Icons.child_friendly_rounded,
      'color': const Color(0xFFEC4899),
      'waktu': 'Proses Verifikasi & Sidang PN',
      'biaya': 'Gratis (Rp 0)',
      'sections': [
        {
          'subtitle': 'Kriteria & Syarat Utama Calon Orang Tua Angkat (COTA):',
          'items': [
            'Berstatus menikah paling singkat 5 (lima) tahun',
            'Berumur paling rendah 30 (tiga puluh) tahun dan paling tinggi 55 (lima puluh lima) tahun',
            'Calon orang tua angkat (COTA) harus seagama dengan agama yang dianut oleh calon anak angkat (CAA)',
            'Mampu secara ekonomi dan sosial',
            'Tidak atau belum mempunyai anak atau hanya memiliki satu anak',
            'Salah satu diantara suami atau istri dinyatakan dokter ahli, kecil kemungkinan atau tidak dapat lagi memberikan keturunan',
          ],
        },
        {
          'subtitle': 'Lampiran Berkas Dokumen Persyaratan Permohonan Izin Adopsi:',
          'items': [
            'Permohonan ijin pengangkatan anak kepada instansi sosial setempat',
            'Surat Keterangan Sehat Calon Orang Tua Angkat (COTA) dari rumah sakit pemerintah (asli)',
            'Surat Keterangan Kesehatan Jiwa COTA dari Dokter Spesialis jiwa dari rumah sakit pemerintah (asli)',
            'Surat keterangan tentang fungsi organ reproduksi COTA dari dokter spesialis Obstetri dan Ginekologi rumah sakit pemerintah',
            'Surat keterangan Catatan Kepolisian (SKCK) setempat (asli)',
            'Fotokopi surat kelahiran COTA',
            'Fotokopi surat nikah / akta perkawinan COTA',
            'Fotokopi KK dan KTP COTA',
            'Fotokopi akta kelahiran COTA',
            'Keterangan penghasilan dari tempat kerja COTA (asli)',
            'Surat pernyataan persetujuan CAA diatas bermaterai cukup bagi anak yang telah mampu menyampaikan pendapatnya',
            'Surat pernyataan motivasi COTA bermaterai cukup yang menyatakan bahwa pengangkatan anak demi kepentingan terbaik bagi anak dan perlindungan anak',
            'Surat pernyataan COTA akan memperlakukan anak angkat dan anak kandung tanpa diskriminasi sesuai dengan hak-hak dan kebutuhan anak bermaterai cukup',
            'Surat pernyataan bahwa COTA akan memberitahukan kepada anak angkatnya mengenai asal usulnya dan orang tua kandungnya dengan memperhatikan kesiapan anak',
            'Surat pernyataan COTA bahwa COTA tidak berhak menjadi wali nikah bagi anak angkat perempuan dan memberi kuasa kepada wali hakim',
            'Surat pernyataan COTA bahwa COTA untuk memberikan hibah sebagian hartanya bagi anak angkatnya',
            'Surat Pernyataan persetujuan adopsi dari kedua belah pihak keluarga COTA',
            'Surat Pernyataan dokumen adopsi adalah dokumen yang sah',
            'Surat keterangan kelakuan baik dari RT (asli)',
            'Foto COTA dan CAA ukuran 4x6 sebanyak 2 lembar',
            'Rekomendasi proses pengangkatan anak dari instansi sosial setempat',
          ],
        },
        {
          'subtitle': 'PROSEDUR LANGKAH-LANGKAH PENGURUSAN IJIN PENGANGKATAN ANAK:',
          'isProcedure': true,
          'items': [
            'COTA datang ke Dinas Sosial Kab / kota setempat',
            'Penjelasan dari petugas yang menangani',
            'COTA mengambil / memfotokopi contoh blanko isian yang ada di Dinsos',
            'Mengisi blanko isian',
            'Setelah dikoreksi dan sudah lengkap maka berkas di fotokopi rangkap 2',
            'Dokumen asli dikirim ke Dinas Sosial Provinsi dengan rekomendasi dari Dinas Sosial Kabupaten',
            'Visit / kunjungan pertama ke rumah COTA oleh Dinsos Provinsi didampingi petugas Dinsos Kab./kota',
            'Diadakan home visit 1x apabila yang diadopsi masih ada hubungan keluarga. Diadakan home visit 2x apabila yang diadopsi tidak ada hubungan keluarga',
            'Setelah diadakan home visit pertama maka 1 - 2 minggu kemudian akan terbit Surat Keputusan Pengasuhan Anak',
            'Setelah home visit kedua maka akan terbit Surat Keputusan Pengangkatan Anak',
            'Surat Keputusan Pengangkatan Anak itu yang dipakai untuk bahan sidang di Pengadilan Negeri',
            'Setelah sidang di Pengadilan negeri akan mendapat Surat Keputusan yang bisa untuk mengurus Akta kelahiran CAA untuk dimasukkan sebagai anak angkat COTA',
          ],
        },
      ],
    },
    {
      'id': 'F',
      'title': 'F. REKOMENDASI ORGANISASI SOSIAL ( ORSOS )',
      'icon': Icons.groups_rounded,
      'color': const Color(0xFF0284C7),
      'waktu': '3 - 5 Hari Kerja',
      'biaya': 'Gratis (Rp 0)',
      'sections': [
        {
          'subtitle': 'Persyaratan Rekomendasi ORSOS:',
          'items': [
            'Surat permohonan rekomendasi ( sesuai format dari Dinas Sosial Kab. Bojonegoro / formulir F.01 )',
            'Surat kuasa lembaga / Orsos / LSM – UKS ( bila pengurusan diwakilkan )',
            'Fotokopi akte notaris ( harus legalisir notaris )',
            'Rekomendasi dari Bakesbangpolinmas Kabupaten Bojonegoro',
            'Rekomendasi dari K3S Kabupaten / Kota',
            'Rekomendasi dari Bupati / walikota',
            'Susunan pengurus lengkap dilampiri fotokopi yang berlaku',
            'AD / ART dan NPWP yayasan',
            'Program kerja, laporan kegiatan dibidang UKS ( Usaha Kesejahteraan Sosial )',
            'Sumber dana dan modal kerja untuk melaksanakan kegiatan',
            'Daftar anak dan foto anak asuh / profil yayasan ( sejarah berdirinya yayasan )',
            'Surat keterangan domisili dari kelurahan / kecamatan',
            'Mengisi formulir registrasi dan identifikasi Orsos / LSM – UKS',
            'Setiap orsos / LSM – UKS yang sudah terdaftar agar membuat laporan kegiatan / perkembangan kegiatan bidang UKS ( Usaha Kesejahteraan Sosial ) sesuai dengan ketentuan yang berlaku',
          ],
        },
        {
          'subtitle': 'MASA BERLAKU LEGALISASI ORSOS:',
          'items': [
            'Masa berlaku legalisasi 3 ( tiga ) tahun',
            'Apabila masa berlaku sudah habis 3 ( tiga ) tahun, maka Orsos / LSM – UKS yang bersangkutan diwajibkan mendaftar ulang',
            'Apabila tidak memperbaharui, Orsos / LSM – UKS yang bersangkutan dianggap tidak ada lagi dan kegiatannya diluar tanggung jawab Dinas Sosial Prop. Jawa Timur',
            'Masa berlaku legalisasi Orsos / LSM – UKS tersebut sewaktu – waktu dapat dicabut apabila "melanggar peraturan / hukum yang berlaku"',
          ],
        },
      ],
    },
    {
      'id': 'G',
      'title': 'G. REKOMENDASI UGB / PUB',
      'icon': Icons.card_giftcard_rounded,
      'color': const Color(0xFFEA580C),
      'waktu': 'Max 3 Hari Kerja',
      'biaya': 'UGB: Rp 0 | PUB: Rp 100.000',
      'sections': [
        {
          'subtitle': 'Rekomendasi Undian Gratis Berhadiah ( UGB ) UU No. 22 Tahun 1954:',
          'items': [
            'Mengisi formulir permohonan',
            'Rekomendasi Dinas Sosial Kab./Kota',
            'Fotokopi Surat Ijin Usaha Perusahaan',
            'Fotokopi Nomor Pokok Wajib Pajak / NPWP',
            'Fotokopi Akte Pendirian / Akte Notaris',
            'Untuk pemohon pemula perlu penelitian lebih lanjut paling lama 3 ( tiga ) hari kerja karena diperlukan survey',
            'Tidak ada biaya retribusi (Gratis)',
          ],
        },
        {
          'subtitle': 'Rekomendasi / Ijin Pengumpulan Uang atau Barang ( PUB ) UU No. 9 Tahun 1961:',
          'items': [
            'Mengisi formulir permohonan',
            'Rekomendasi Dinas Sosial Kab/Kota lokasi pemohon',
            'Fotokopi akte pendirian',
            'Fotokopi AD / ART',
            'Susunan kepengurusan / kepanitiaan',
            'Melampirkan surat dari kepolisian tentang loyalitas pengurusnya',
            'Untuk pemohon pemula perlu penelitian lebih lanjut paling lama 3 ( tiga ) hari karena diperlukan survey',
            'Biaya retribusi bagi pengurusan pengumpulan uang atau barang wilayah jawa timur sebesar Rp. 100.000,- ( seratus ribu rupiah )',
          ],
        },
      ],
    },
  ];

  // Dialog Tambah & Edit Persyaratan Pelayanan Publik
  void _showAddEditDialog([Map<String, dynamic>? existing]) {
    final titleController = TextEditingController(text: existing?['title'] ?? '');
    final waktuController = TextEditingController(text: existing?['waktu'] ?? '1 - 3 Hari Kerja');
    final biayaController = TextEditingController(text: existing?['biaya'] ?? 'Gratis (Rp 0)');
    
    String initialItemsText = '';
    if (existing != null && existing['sections'] != null) {
      final List sections = existing['sections'];
      final List<String> lines = [];
      for (var sec in sections) {
        if (sec['items'] != null) {
          lines.addAll(List<String>.from(sec['items']));
        }
      }
      initialItemsText = lines.join('\n');
    }

    final itemsController = TextEditingController(text: initialItemsText);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AdminFormDialog(
          title: existing != null ? 'Edit Persyaratan Pelayanan' : 'Tambah Persyaratan Pelayanan',
          subtitle: 'Kelola judul, estimasi waktu, biaya, & daftar berkas persyaratan',
          isEditing: existing != null,
          fields: [
            AdminFormField(
              label: 'Judul Persyaratan',
              controller: titleController,
              hint: 'Contoh: H. PERSYARATAN REKOMENDASI ORSOS',
            ),
            AdminFormField(
              label: 'Estimasi Waktu',
              controller: waktuController,
              hint: 'Contoh: 1 - 3 Hari Kerja',
            ),
            AdminFormField(
              label: 'Biaya Layanan',
              controller: biayaController,
              hint: 'Contoh: Gratis (Rp 0)',
            ),
            AdminFormField(
              label: 'Rincian Berkas (Pisahkan dengan Baris Baru)',
              controller: itemsController,
              hint: 'Surat Pengantar Desa\nFotokopi KTP\nFotokopi KK',
              isMultiLine: true,
            ),
          ],
          onSave: () {
            final rawTitle = titleController.text.trim().isEmpty ? 'PERSYARATAN PELAYANAN BARU' : titleController.text.trim();
            final rawWaktu = waktuController.text.trim().isEmpty ? '1 - 3 Hari Kerja' : waktuController.text.trim();
            final rawBiaya = biayaController.text.trim().isEmpty ? 'Gratis (Rp 0)' : biayaController.text.trim();
            final rawItemsText = itemsController.text.trim();
            
            final List<String> parsedItems = rawItemsText
                .split('\n')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            if (parsedItems.isEmpty) {
              parsedItems.addAll(['Surat Pengantar Desa', 'Fotokopi KTP', 'Fotokopi KK']);
            }

            setState(() {
              if (existing != null) {
                existing['title'] = rawTitle;
                existing['waktu'] = rawWaktu;
                existing['biaya'] = rawBiaya;
                existing['sections'] = [
                  {
                    'subtitle': 'Persyaratan pengurusan sebagai berikut:',
                    'items': parsedItems,
                  }
                ];
              } else {
                final nextChar = String.fromCharCode(65 + _serviceRequirements.length);
                _serviceRequirements.add({
                  'id': nextChar,
                  'title': rawTitle,
                  'icon': Icons.assignment_rounded,
                  'color': const Color(0xFF0D62F1),
                  'waktu': rawWaktu,
                  'biaya': rawBiaya,
                  'sections': [
                    {
                      'subtitle': 'Persyaratan pengurusan sebagai berikut:',
                      'items': parsedItems,
                    }
                  ],
                });
              }
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(existing != null ? 'Persyaratan diperbarui!' : 'Persyaratan baru berhasil ditambahkan!'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
          },
        );
      },
    );
  }

  // Dialog Konfirmasi Hapus Persyaratan
  void _confirmDelete(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 24),
            SizedBox(width: 8),
            Text('Hapus Persyaratan'),
          ],
        ),
        content: Text('Apakah Anda yakin ingin menghapus "${item['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() {
                _serviceRequirements.removeWhere((e) => e['id'] == item['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${item['title']}" telah dihapus.'),
                  backgroundColor: const Color(0xFFEF4444),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    final query = _searchQuery.trim().toLowerCase();

    final filteredList = _serviceRequirements.where((item) {
      if (query.isEmpty) return true;

      final id = item['id'].toString().toLowerCase();
      final title = item['title'].toString().toLowerCase();
      final cleanQuery = query.replaceAll(RegExp(r'^(kategori\s*|layanan\s*)'), '').trim();

      if (cleanQuery == id || cleanQuery == '$id.' || cleanQuery == '$id. ' || title.startsWith(cleanQuery)) {
        return true;
      }

      if (title.contains(query)) {
        return true;
      }

      final sectionsMatch = (item['sections'] as List).any((sec) {
        final subMatch = sec['subtitle'].toString().toLowerCase().contains(query);
        final itemsMatch = (sec['items'] as List<String>).any((i) {
          final cleanItemText = i.toLowerCase().replaceAll(RegExp(r'^[a-z0-9]+\.\s*'), '').trim();
          return cleanItemText.contains(query);
        });
        return subMatch || itemsMatch;
      });

      return sectionsMatch;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: const Color(0xFF0D62F1),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Tambah Persyaratan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Persyaratan Pelayanan Publik',
            subtitle: 'Dinas Sosial Kabupaten Bojonegoro',
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),

          // Content List
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Guarantee Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
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
                                color: const Color(0xFF10B981).withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.verified_user_rounded,
                                color: Color(0xFF10B981),
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Standar Pelayanan Publik Resmi',
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Persyaratan administrasi lengkap pelayanan publik Dinas Sosial Kabupaten Bojonegoro.',
                                    style: TextStyle(
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Search Input Box
                      TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: 'Cari persyaratan (misal: KIS, Adopsi, LKS, Orsos, PUB)...',
                          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D62F1)),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFF0D62F1), width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daftar Persyaratan Pelayanan Publik',
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${filteredList.length} Kategori',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0D62F1)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Requirements List Expansion / Cards
                      filteredList.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(24),
                              alignment: Alignment.center,
                              child: Text(
                                'Persyaratan yang Anda cari tidak ditemukan.',
                                style: TextStyle(
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final item = filteredList[index];
                                final isExpanded = _searchQuery.isNotEmpty || _expandedIndex == index;
                                final IconData icon = item['icon'];
                                final Color color = item['color'];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isExpanded
                                          ? color
                                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                      width: isExpanded ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        key: Key('expansion_${item['id']}_${_searchQuery.isEmpty ? index : item['id']}'),
                                        initiallyExpanded: isExpanded,
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: color.withAlpha(25),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(icon, color: color, size: 22),
                                        ),
                                        title: Text(
                                          item['title'],
                                          style: TextStyle(
                                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onExpansionChanged: (expanded) {
                                          if (expanded) {
                                            setState(() {
                                              _expandedIndex = index;
                                            });
                                          }
                                        },
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Divider(height: 1),
                                                const SizedBox(height: 12),

                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    _buildBadge('Waktu: ${item['waktu']}', const Color(0xFF0D62F1), isDark),
                                                    _buildBadge('Biaya: ${item['biaya']}', const Color(0xFF10B981), isDark),
                                                  ],
                                                ),
                                                const SizedBox(height: 14),

                                                // Render Sections
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: (item['sections'] as List).map<Widget>((sectionMap) {
                                                    final String subtitle = sectionMap['subtitle'];
                                                    final List<String> itemList = sectionMap['items'];
                                                    final bool isProc = sectionMap['isProcedure'] == true;

                                                    return Padding(
                                                      padding: const EdgeInsets.only(bottom: 16),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                            decoration: BoxDecoration(
                                                              color: color.withAlpha(15),
                                                              borderRadius: BorderRadius.circular(8),
                                                              border: Border.all(color: color.withAlpha(30)),
                                                            ),
                                                            child: Text(
                                                              subtitle,
                                                              style: TextStyle(
                                                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                                                fontSize: 12.5,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),

                                                          Column(
                                                            children: itemList.asMap().entries.map((entry) {
                                                              final idx = entry.key;
                                                              final text = entry.value;

                                                              return Padding(
                                                                padding: const EdgeInsets.only(bottom: 8),
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    if (isProc) ...[
                                                                      Container(
                                                                        width: 22,
                                                                        height: 22,
                                                                        alignment: Alignment.center,
                                                                        decoration: BoxDecoration(
                                                                          color: color,
                                                                          shape: BoxShape.circle,
                                                                        ),
                                                                        child: Text(
                                                                          '${idx + 1}',
                                                                          style: const TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(width: 10),
                                                                    ] else ...[
                                                                      Icon(
                                                                        Icons.check_circle_outline_rounded,
                                                                        color: color,
                                                                        size: 17,
                                                                      ),
                                                                      const SizedBox(width: 8),
                                                                    ],
                                                                    Expanded(
                                                                      child: Text(
                                                                        text,
                                                                        style: TextStyle(
                                                                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                                                          fontSize: 12.5,
                                                                          height: 1.35,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),

                                                // Admin CRUD Buttons for each Requirement Item Card
                                                const SizedBox(height: 12),
                                                const Divider(height: 1),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.admin_panel_settings_rounded, size: 14, color: Color(0xFF0D62F1)),
                                                        const SizedBox(width: 6),
                                                        Text(
                                                          'Kelola Item',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.bold,
                                                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        OutlinedButton.icon(
                                                          onPressed: () => _showAddEditDialog(item),
                                                          icon: const Icon(Icons.edit_rounded, size: 13, color: Color(0xFF0D62F1)),
                                                          label: const Text('Edit', style: TextStyle(color: Color(0xFF0D62F1), fontWeight: FontWeight.bold, fontSize: 11)),
                                                          style: OutlinedButton.styleFrom(
                                                            side: const BorderSide(color: Color(0xFF0D62F1), width: 1),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        ElevatedButton.icon(
                                                          onPressed: () => _confirmDelete(item),
                                                          icon: const Icon(Icons.delete_outline_rounded, size: 13, color: Colors.white),
                                                          label: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: const Color(0xFFEF4444),
                                                            elevation: 0,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
