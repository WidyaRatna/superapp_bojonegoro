import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../widgets/superapp_header.dart';

class KritikSaranSosialScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const KritikSaranSosialScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<KritikSaranSosialScreen> createState() => _KritikSaranSosialScreenState();
}

class _KritikSaranSosialScreenState extends State<KritikSaranSosialScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _openWebUrl(String urlStr) async {
    var formattedUrl = urlStr.trim();
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }
    final Uri uri = Uri.parse(formattedUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!kIsWeb && Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', formattedUrl]);
        return;
      } catch (_) {}
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membuka website ($formattedUrl)...')),
      );
    }
  }

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kontakController = TextEditingController();
  final TextEditingController _subjekController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();

  String _selectedKategori = 'Layanan Rumah Singgah';

  final List<String> _kategoriOptions = [
    'Layanan Rumah Singgah',
    'Bantuan Sosial (PKH, BPNT, DTKS)',
    'Pelayanan Publik & Rekomendasi',
    'Perlindungan Anak & Penyandang Disabilitas',
    'Pelayanan Petugas & Fasilitas Dinsos',
    'Lainnya',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _kontakController.dispose();
    _subjekController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDBEAFE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mark_email_read_rounded,
                    color: Color(0xFF0D62F1),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Masukan Terikirim',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF3B82F6).withAlpha(80)),
                  ),
                  child: const Text(
                    'Simulasi Frontend / Modul Prototype',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Terima kasih "${_namaController.text}", masukan Anda mengenai "$_selectedKategori" telah disimulasikan.',
                  style: TextStyle(
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Kritik dan saran masyarakat sangat berharga untuk meningkatkan kualitas pelayanan publik Dinas Sosial Kabupaten Bojonegoro.',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Back to Layanan Sosial
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D62F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Kembali', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Masukan, Kritik dan Saran',
            subtitle: 'Dinas Sosial Kabupaten Bojonegoro',
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),

          // Form Body
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header Info
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
                                  color: const Color(0xFF0D62F1).withAlpha(25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.rate_review_rounded,
                                  color: Color(0xFF0D62F1),
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Aspirasi Publik Dinsos Bojonegoro',
                                      style: TextStyle(
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                     const SizedBox(height: 2),
                                     Text(
                                       'Masukan Anda membantu kami memberikan pelayanan yang lebih responsif, efisien, dan transparan.',
                                       style: TextStyle(
                                         color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                         fontSize: 12,
                                       ),
                                     ),
                                     const SizedBox(height: 8),
                                     InkWell(
                                       onTap: () => _openWebUrl('https://rumahsinggahbjn.com/kritik&saran/index.html'),
                                       borderRadius: BorderRadius.circular(8),
                                       child: Container(
                                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                         decoration: BoxDecoration(
                                           color: const Color(0xFF0D62F1).withAlpha(isDark ? 35 : 20),
                                           borderRadius: BorderRadius.circular(8),
                                         ),
                                         child: const Row(
                                           mainAxisSize: MainAxisSize.min,
                                           children: [
                                             Icon(Icons.language_rounded, size: 14, color: Color(0xFF0D62F1)),
                                             SizedBox(width: 6),
                                             Text(
                                               'rumahsinggahbjn.com/kritik&saran/index.html',
                                               style: TextStyle(
                                                 fontSize: 11.5,
                                                 fontWeight: FontWeight.bold,
                                                 color: Color(0xFF0D62F1),
                                               ),
                                             ),
                                             SizedBox(width: 4),
                                             Icon(Icons.open_in_new_rounded, size: 12, color: Color(0xFF0D62F1)),
                                           ],
                                         ),
                                       ),
                                     ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Form Inputs
                        _buildLabel('Nama Pengirim (Boleh Anonim)', isDark),
                        TextFormField(
                          controller: _namaController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: _buildInputDecoration('Nama Anda (Contoh: Ahmad / Warga Bojonegoro)', Icons.person_outline_rounded, isDark),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama pengirim wajib diisi (bisa gunakan nama panggilan)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Kontak HP / Email (Optional untuk balasan)', isDark),
                        TextFormField(
                          controller: _kontakController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: _buildInputDecoration('08xxxxxxxxxx atau email@domain.com', Icons.contact_mail_outlined, isDark),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Kategori Layanan Yang Dituju', isDark),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedKategori,
                          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                          style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 14),
                          decoration: _buildInputDecoration('Pilih kategori', Icons.category_rounded, isDark),
                          items: _kategoriOptions.map((kategori) {
                            return DropdownMenuItem<String>(
                              value: kategori,
                              child: Text(kategori),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedKategori = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Judul / Subjek Masukan', isDark),
                        TextFormField(
                          controller: _subjekController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: _buildInputDecoration('Contoh: Usulan Perbaikan Layanan Antrean', Icons.title_rounded, isDark),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Subjek masukan wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Detail Kritik, Masukan & Saran', isDark),
                        TextFormField(
                          controller: _pesanController,
                          maxLines: 5,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: _buildInputDecoration(
                            'Sampaikan pesan masukan atau saran Anda secara jelas...',
                            Icons.chat_bubble_outline_rounded,
                            isDark,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Detail pesan masukan wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D62F1),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send_rounded, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'Kirim Masukan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData prefixIcon, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        fontSize: 13.5,
      ),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF0D62F1), size: 20),
      filled: true,
      fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF0D62F1), width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.8),
      ),
    );
  }
}
