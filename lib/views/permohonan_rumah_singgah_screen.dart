import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../widgets/superapp_header.dart';

class PermohonanRumahSinggahScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const PermohonanRumahSinggahScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<PermohonanRumahSinggahScreen> createState() => _PermohonanRumahSinggahScreenState();
}

class _PermohonanRumahSinggahScreenState extends State<PermohonanRumahSinggahScreen> {
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
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _tujuanController = TextEditingController();
  
  DateTime? _selectedDate;
  String? _uploadedFileName;

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _alamatController.dispose();
    _phoneController.dispose();
    _tujuanController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _simulateFileUpload() {
    setState(() {
      _uploadedFileName = 'KTP_dan_Surat_Rujukan_Pemohon.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dokumen pendukung berhasil dilampirkan (Simulasi File).'),
        backgroundColor: Color(0xFF0D62F1),
        duration: Duration(seconds: 2),
      ),
    );
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
                    Icons.check_circle_rounded,
                    color: Color(0xFF0D62F1),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Formulir Terisi',
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
                  'Formulir permohonan surat rekomendasi rumah singgah untuk "${_namaController.text}" telah berhasil disimulasikan.',
                  style: TextStyle(
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Catatan: Fitur ini merupakan tampilan antarmuka (frontend) SuperApp Bojonegoro. Pengiriman data ke server Dinas Sosial belum aktif.',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
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
                child: const Text('Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
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
            title: 'Permohonan Rumah Singgah',
            subtitle: 'Dinas Sosial Kabupaten Bojonegoro',
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),

          // Scrollable Form Content
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
                        // Card Info Banner
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
                                  Icons.house_rounded,
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
                                      'Layanan Rumah Singgah Dinsos',
                                      style: TextStyle(
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                     const SizedBox(height: 2),
                                     Text(
                                       'Fasilitas penampungan sementara bagi warga yang membutuhkan pendampingan sosial/medis.',
                                       style: TextStyle(
                                         color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                         fontSize: 12,
                                       ),
                                     ),
                                     const SizedBox(height: 8),
                                     InkWell(
                                       onTap: () => _openWebUrl('https://rumahsinggahbjn.com/rumahSG.html'),
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
                                               'rumahsinggahbjn.com/rumahSG.html',
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

                        // Section Title
                        Text(
                          'Data Identitas Pemohon',
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Nama Lengkap Field
                        _buildLabel('Nama Lengkap (Sesuai KTP)', isDark),
                        TextFormField(
                          controller: _namaController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: _buildInputDecoration('Masukkan nama lengkap pemohon', Icons.person_rounded, isDark),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama lengkap pemohon wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // NIK Field
                        _buildLabel('Nomor Induk Kependudukan (NIK)', isDark),
                        TextFormField(
                          controller: _nikController,
                          keyboardType: TextInputType.number,
                          maxLength: 16,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: _buildInputDecoration('3522xxxxxxxxxxxx', Icons.badge_rounded, isDark),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'NIK wajib diisi';
                            }
                            if (value.length < 16) {
                              return 'NIK harus terdiri dari 16 digit';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // No Telepon / WA
                        _buildLabel('Nomor Telepon / WhatsApp', isDark),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: _buildInputDecoration('08xxxxxxxxxx', Icons.phone_rounded, isDark),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nomor kontak aktif wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Alamat Lengkap
                        _buildLabel('Alamat Lengkap Sesuai KTP', isDark),
                        TextFormField(
                          controller: _alamatController,
                          maxLines: 3,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: _buildInputDecoration('RT/RW, Desa/Kelurahan, Kecamatan, Kab. Bojonegoro', Icons.location_on_rounded, isDark),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Alamat pemohon wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Section Detail Permohonan
                        Text(
                          'Detail Permohonan',
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Tanggal Rencana Penggunaan
                        _buildLabel('Tanggal Rencana Menginap / Penggunaan', isDark),
                        InkWell(
                          onTap: _pickDate,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, color: Color(0xFF0D62F1), size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  _selectedDate == null
                                      ? 'Pilih tanggal pengajuan'
                                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                  style: TextStyle(
                                    color: _selectedDate == null
                                        ? (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))
                                        : (isDark ? Colors.white : const Color(0xFF0F172A)),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Alasan Pengajuan
                        _buildLabel('Alasan / Tujuan Penggunaan Rumah Singgah', isDark),
                        TextFormField(
                          controller: _tujuanController,
                          maxLines: 3,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: _buildInputDecoration(
                            'Jelaskan alasan atau keperluan pendampingan/penampungan di Rumah Singgah...',
                            Icons.article_rounded,
                            isDark,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Alasan permohonan wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Upload Dokumen
                        _buildLabel('Unggah Lampiran Dokumen (KTP / Surat Rujukan)', isDark),
                        OutlinedButton.icon(
                          onPressed: _simulateFileUpload,
                          icon: const Icon(Icons.upload_file_rounded, color: Color(0xFF0D62F1)),
                          label: Text(
                            _uploadedFileName ?? 'Pilih File Dokumen (PDF/JPG)',
                            style: TextStyle(
                              color: _uploadedFileName == null
                                  ? const Color(0xFF0D62F1)
                                  : (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A)),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            side: BorderSide(
                              color: _uploadedFileName == null
                                  ? const Color(0xFF0D62F1)
                                  : const Color(0xFF22C55E),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
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
                                  'Ajukan Sekarang',
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
