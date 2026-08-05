import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class KesehatanScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const KesehatanScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<KesehatanScreen> createState() => _KesehatanScreenState();
}

class _KesehatanScreenState extends State<KesehatanScreen> {
  Future<void> _openAntreanRSUD() async {
    final Uri waUrl = Uri.parse('https://wa.me/6282160050066?text=DAFTAR');
    try {
      if (await canLaunchUrl(waUrl)) {
        await launchUrl(waUrl, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Membuka WhatsApp Antrean Online RSUD (+62 821-6005-0066)...'),
          backgroundColor: Color(0xFF0284C7),
        ),
      );
    }
  }

  Future<void> _openAmbulansDarurat() async {
    final Uri telUri = Uri.parse('tel:081132277119');
    try {
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
        return;
      }
    } catch (_) {}

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AmbulansDaruratScreen(
            isDarkMode: widget.isDarkMode,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),
        ),
      );
    }
  }

  Future<void> _openStokDarahPMI() async {
    const String urlStr = 'https://pmibojonegoro.com/utd/bloodstock';
    final Uri url = Uri.parse(urlStr);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Membuka website Stok Darah PMI Bojonegoro...'),
          backgroundColor: Color(0xFFE11D48),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top Red/Coral Gradient Header Bar
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF4C0519)]
                      : const [Color(0xFF0F2B66), Color(0xFF1E3A8A), Color(0xFF991B1B)],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F2B66).withAlpha(60),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Layanan Kesehatan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
                          color: isDark ? Colors.amber : Colors.white,
                        ),
                        onPressed: widget.onToggleDarkMode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(35),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 36),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Layanan Kesehatan Masyarakat',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'RSUD Bojonegoro, Ambulans Darurat & Stok Darah PMI',
                              style: TextStyle(
                                color: Color(0xFFFEE2E2),
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3 Main Service Feature Cards (Antrean RSUD, Ambulans, Stok Darah PMI)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Layanan Utama Kesehatan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih layanan digital kesehatan yang Anda butuhkan:',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ITEM 1: Antrean Online RSUD
                  _buildHealthCard(
                    icon: Icons.assignment_ind_rounded,
                    color: const Color(0xFF0D62F1),
                    badgeText: 'RSUD di Kab. Bojonegoro',
                    title: 'Antrean Online RSUD',
                    subtitle: 'Pendaftaran nomor antrean poliklinik RSUD via WhatsApp (+62 821-6005-0066).',
                    onTap: _openAntreanRSUD,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 14),

                  // ITEM 2: Layanan Ambulans Darurat
                  _buildHealthCard(
                    icon: Icons.airport_shuttle_rounded,
                    color: const Color(0xFFDC2626),
                    badgeText: 'Aplikasi: Emergency Button Bojonegoro',
                    title: 'Layanan Ambulans Darurat',
                    subtitle: 'Telepon: 081132277119 • Panggilan darurat & penjemputan medis 24 Jam.',
                    onTap: _openAmbulansDarurat,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 14),

                  // ITEM 3: Stok Darah PMI Bojonegoro
                  _buildHealthCard(
                    icon: Icons.bloodtype_rounded,
                    color: const Color(0xFFE11D48),
                    badgeText: 'Update Live PMI Kab. Bojonegoro',
                    title: 'Stok Darah PMI Bojonegoro',
                    subtitle: 'Cek persediaan darah',
                    onTap: _openStokDarahPMI,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard({
    required IconData icon,
    required Color color,
    required String badgeText,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(isDark ? 40 : 15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withAlpha(35), color.withAlpha(15)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withAlpha(35), width: 1),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color.withAlpha(30), color.withAlpha(15)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: color.withAlpha(40), width: 1),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withAlpha(210), color],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withAlpha(50),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== SCREEN 1: ANTREAN ONLINE RSUD ====================
class AntreanRSUDScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const AntreanRSUDScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<AntreanRSUDScreen> createState() => _AntreanRSUDScreenState();
}

class _AntreanRSUDScreenState extends State<AntreanRSUDScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRSUD = 'RSUD Dr. R. Sosodoro Djatikoesoemo';
  String _selectedPoli = 'Poli Penyakit Dalam';
  String _jenisPasien = 'BPJS Kesehatan';

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _bpjsController = TextEditingController();

  bool _isSubmitted = false;
  String _generatedNomor = '';

  final List<String> _daftarRSUD = [
    'RSUD Dr. R. Sosodoro Djatikoesoemo',
    'RSUD Padangan Bojonegoro',
    'RSUD Sumberrejo Bojonegoro',
  ];

  final List<String> _daftarPoli = [
    'Poli Penyakit Dalam',
    'Poli Anak & Tumbuh Tumbuh',
    'Poli Bedah Umum',
    'Poli Gigi & Mulut',
    'Poli Mata',
    'Poli Saraf & Neurologi',
    'Poli Jantung & Pembuluh Darah',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _bpjsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final codePrefix = _selectedPoli.substring(5, 6).toUpperCase();
      final randomNum = (10 + (DateTime.now().millisecond % 89)).toString();
      setState(() {
        _generatedNomor = '$codePrefix-$randomNum';
        _isSubmitted = true;
      });

      final message = 'DAFTAR';
      final Uri waUri = Uri.parse('https://wa.me/6282160050066?text=${Uri.encodeComponent(message)}');

      try {
        if (await canLaunchUrl(waUri)) {
          await launchUrl(waUri, mode: LaunchMode.externalApplication);
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF0284C7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Antrean Online RSUD',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: _isSubmitted ? _buildTicketResultCard(isDark) : _buildFormInput(isDark),
      ),
    );
  }

  Widget _buildFormInput(bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFBAE6FD),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_rounded, color: Color(0xFF0284C7)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pendaftaran antrean online dapat dilakukan H-1 hingga H-7 sebelum hari pemeriksaan.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0369A1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Dropdown Pilih RSUD
          _buildLabel('Pilih Rumah Sakit (RSUD)', isDark),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedRSUD,
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 14),
                items: _daftarRSUD.map((rs) {
                  return DropdownMenuItem(value: rs, child: Text(rs));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedRSUD = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Dropdown Pilih Poli
          _buildLabel('Pilih Poliklinik Spesialis', isDark),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPoli,
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 14),
                items: _daftarPoli.map((poli) {
                  return DropdownMenuItem(value: poli, child: Text(poli));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPoli = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Jenis Pasien (BPJS / Umum)
          _buildLabel('Jenis Penjaminan', isDark),
          Row(
            children: ['BPJS Kesehatan', 'Pasien Umum'].map((type) {
              final isSelected = _jenisPasien == type;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Center(child: Text(type)),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0284C7),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _jenisPasien = type);
                    },
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Nama Pasien
          _buildLabel('Nama Lengkap Pasien', isDark),
          TextFormField(
            controller: _namaController,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: _inputDecoration('Masukkan nama sesuai KTP', isDark),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
          ),
          const SizedBox(height: 16),

          // NIK
          _buildLabel('NIK (Nomor Induk Kependudukan)', isDark),
          TextFormField(
            controller: _nikController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: _inputDecoration('16 digit NIK', isDark),
            validator: (v) => (v == null || v.length < 16) ? 'NIK harus 16 digit' : null,
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.confirmation_number_rounded, color: Colors.white),
              label: const Text(
                'Ambil Tiket Antrean Online',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketResultCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF0284C7), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 64),
          const SizedBox(height: 12),
          const Text(
            'Tiket Antrean Berhasil Diterbitkan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          Text(
            'NOMOR ANTREAN ANDA',
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54, letterSpacing: 1.2),
          ),
          const SizedBox(height: 6),
          Text(
            _generatedNomor,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF0284C7)),
          ),
          const SizedBox(height: 16),

          _buildTicketRow('Rumah Sakit', _selectedRSUD, isDark),
          _buildTicketRow('Poliklinik', _selectedPoli, isDark),
          _buildTicketRow('Nama Pasien', _namaController.text, isDark),
          _buildTicketRow('Penjamin', _jenisPasien, isDark),
          _buildTicketRow('Estimasi Pelayanan', 'Besok, 09.15 WIB', isDark),
          const SizedBox(height: 20),

          // QR Code Mock Placeholder
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: const [
                Icon(Icons.qr_code_2_rounded, size: 100, color: Colors.black),
                SizedBox(height: 4),
                Text('Tunjukkan QR Code ini di mesin pendaftaran RSUD', style: TextStyle(fontSize: 10, color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                setState(() => _isSubmitted = false);
              },
              child: const Text('Buat Antrean Baru'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: isDark ? Colors.white60 : Colors.black54)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
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
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13),
      filled: true,
      fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
      ),
    );
  }
}

// ==================== SCREEN 2: LAYANAN AMBULANS DARURAT ====================
class AmbulansDaruratScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const AmbulansDaruratScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<AmbulansDaruratScreen> createState() => _AmbulansDaruratScreenState();
}

class _AmbulansDaruratScreenState extends State<AmbulansDaruratScreen> {
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  String _jenisDarurat = 'Kecelakaan Lalu Lintas';

  bool _isDispatched = false;

  Future<void> _makeCall112() async {
    final Uri telUri = Uri.parse('tel:081132277119');
    try {
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
        return;
      }
    } catch (_) {}

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menghubungi Ambulans Darurat 081132277119...'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
    }
  }

  void _dispatchAmbulance() {
    if (_lokasiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi alamat lokasi penjemputan darurat!')),
      );
      return;
    }
    setState(() {
      _isDispatched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDC2626),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Layanan Ambulans Darurat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Emergency Direct Hotline Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFDC2626), Color(0xFF991B1B)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDC2626).withAlpha(80),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.phone_forwarded_rounded, color: Colors.white, size: 48),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Aplikasi: Emergency Button Bojonegoro',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'PANGGILAN DARURAT AMBULANS',
                    style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '0811-3227-7119',
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: _makeCall112,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFDC2626),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.call, color: Color(0xFFDC2626)),
                    label: const Text(
                      'HUBUNGI 081132277119',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _isDispatched ? _buildTrackerView(isDark) : _buildRequestForm(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestForm(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emergency_share_rounded, color: Color(0xFFDC2626)),
              const SizedBox(width: 10),
              Text(
                'Minta Penjemputan Ambulans Online',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text('Jenis Kejadian Darurat', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _jenisDarurat,
            dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: [
              'Kecelakaan Lalu Lintas',
              'Pasien Kritis / Serangan Jantung',
              'Ibu Melahirkan / Kebidanan',
              'Rujukan Rumah Sakit',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _jenisDarurat = val);
            },
          ),
          const SizedBox(height: 14),

          Text('Lokasi Alamat Penjemputan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _lokasiController,
            maxLines: 2,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: 'Contoh: Jl. Veteran No. 12, Bojonegoro (Samping Masjid)',
              hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13),
              filled: true,
              fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 14),

          Text('Nomor HP Pelapor', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _teleponController,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: '0812xxxxxxx',
              hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13),
              filled: true,
              fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _dispatchAmbulance,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              label: const Text(
                'Kirim Permintaan Penjemputan',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackerView(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF10B981), width: 2),
      ),
      child: Column(
        children: [
          const Icon(Icons.minor_crash_rounded, color: Color(0xFFDC2626), size: 60),
          const SizedBox(height: 10),
          const Text(
            'AMBULANS DALAM PERJALANAN',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFFDC2626)),
          ),
          const SizedBox(height: 6),
          Text(
            'Unit Ambulans Darurat RSUD Sosodoro #03 telah meluncur ke lokasi Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: isDark ? Colors.white70 : const Color(0xFF334155)),
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(color: Color(0xFFDC2626)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: const [
                  Text('Estimasi Tiba', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  Text('7-10 Menit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                children: const [
                  Text('Driver Ambulans', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  Text('Pak Sugeng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => setState(() => _isDispatched = false),
            child: const Text('Batal Permintaan'),
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 3: STOK DARAH PMI BOJONEGORO ====================
class StokDarahPMIScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const StokDarahPMIScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode;

    final bloodStocks = [
      {'type': 'Golongan A+', 'count': 45, 'status': 'Stok Aman', 'color': const Color(0xFF10B981)},
      {'type': 'Golongan B+', 'count': 62, 'status': 'Melimpah', 'color': const Color(0xFF0284C7)},
      {'type': 'Golongan AB+', 'count': 14, 'status': 'Stok Menipis', 'color': const Color(0xFFF59E0B)},
      {'type': 'Golongan O+', 'count': 88, 'status': 'Sangat Aman', 'color': const Color(0xFF10B981)},
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE11D48),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Stok Darah PMI Bojonegoro',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Status Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE11D48).withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.water_drop_rounded, color: Color(0xFFE11D48), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Palang Merah Indonesia (PMI)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Markas PMI Kab. Bojonegoro • Update Hari Ini',
                          style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Informasi Ketersediaan Kantong Darah',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),

            // 2x2 Blood Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bloodStocks.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                final item = bloodStocks[index];
                final color = item['color'] as Color;
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: color.withAlpha(80), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['type'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Icon(Icons.bloodtype, color: color, size: 22),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${item['count']}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text('Kantong', style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['status'] as String,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Donor Schedule Section
            Text(
              'Jadwal Bus Donor Darah Keliling PMI',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildScheduleRow('Alun-Alun Bojonegoro', 'Sabtu, 08.00 - 12.00 WIB', isDark),
                  const Divider(),
                  _buildScheduleRow('Kecamatan Sumberrejo', 'Minggu, 09.00 - 13.00 WIB', isDark),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Formulir Pendaftaran Calon Donor Darah PMI dibuka...'),
                      backgroundColor: Color(0xFFE11D48),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE11D48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.volunteer_activism_rounded, color: Colors.white),
                label: const Text(
                  'Daftar Calon Donor Darah',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleRow(String location, String time, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded, color: Color(0xFFE11D48), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: isDark ? Colors.white : Colors.black87)),
                Text(time, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
