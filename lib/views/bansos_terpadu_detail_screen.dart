import 'package:flutter/material.dart';
import '../widgets/superapp_header.dart';

class BansosTerpaduDetailScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const BansosTerpaduDetailScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<BansosTerpaduDetailScreen> createState() => _BansosTerpaduDetailScreenState();
}

class _BansosTerpaduDetailScreenState extends State<BansosTerpaduDetailScreen> {
  final TextEditingController _nikController = TextEditingController();
  bool _hasChecked = false;
  String _searchedNik = '';

  @override
  void dispose() {
    _nikController.dispose();
    super.dispose();
  }

  void _checkStatusBansos() {
    final text = _nikController.text.trim();
    if (text.isEmpty || text.length < 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan 16 digit NIK secara lengkap untuk verifikasi.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }
    setState(() {
      _hasChecked = true;
      _searchedNik = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Bantuan Sosial Terpadu',
            subtitle: 'Dinas Sosial Kabupaten Bojonegoro',
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),

          // Content Body
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cek Bansos Interactive Box
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(isDark ? 50 : 15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D62F1).withAlpha(25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.saved_search_rounded,
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
                                        'Simulasi Cek Status DTKS / Bansos',
                                        style: TextStyle(
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Periksa kepesertaan bantuan sosial berdasarkan NIK KTP.',
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
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _nikController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 16,
                                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan 16 Digit NIK...',
                                      hintStyle: TextStyle(
                                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                        fontSize: 13,
                                      ),
                                      counterText: '',
                                      filled: true,
                                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xFF0D62F1), width: 1.8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: _checkStatusBansos,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D62F1),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Cek Status', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),

                            if (_hasChecked) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF166534) : const Color(0xFF86EFAC),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Hasil Simulasi Verifikasi NIK: $_searchedNik',
                                          style: TextStyle(
                                            color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '• Status DTKS: Terdaftar aktif (Simulasi UI)\n• Program Bansos: PKH (Tahap Active) & BPNT Sembako\n• Wilayah: Kabupaten Bojonegoro',
                                      style: TextStyle(
                                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                        fontSize: 12.5,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '*Catatan: Pengecekan ini adalah tampilan antarmuka (frontend preview). Pengecekan resmi terkoneksi melalui portal Cek Bansos Kemensos (cekbansos.kemensos.go.id).',
                                      style: TextStyle(
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                        fontSize: 11.5,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section Title: Program Bantuan Utama
                      Text(
                        'Program Bantuan Sosial Utama',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),

                      _buildProgramCard(
                        title: '1. Program Keluarga Harapan (PKH)',
                        badge: 'Bantuan Tunai Bersyarat',
                        description:
                            'Program pemberian bantuan sosial bersyarat kepada Keluarga Miskin (KM) yang ditetapkan sebagai keluarga penerima manfaat PKH untuk akses kesehatan, pendidikan, dan kesejahteraan sosial.',
                        icon: Icons.family_restroom_rounded,
                        color: const Color(0xFF0D62F1),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),

                      _buildProgramCard(
                        title: '2. Bantuan Pangan Non-Tunai (BPNT / Sembako)',
                        badge: 'Bantuan Pangan Rutin',
                        description:
                            'Bantuan sosial pangan yang disalurkan dalam bentuk tunai/non-tunai secara berkala untuk pemenuhan gizi pokok (beras, telur, dan komoditas pangan esensial) warga Bojonegoro.',
                        icon: Icons.shopping_bag_rounded,
                        color: const Color(0xFF059669),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),

                      _buildProgramCard(
                        title: '3. Data Terpadu Kesejahteraan Sosial (DTKS)',
                        badge: 'Basis Data Nasional',
                        description:
                            'Data induk yang berisi data pemerlu pelayanan kesejahteraan sosial, penerima bantuan dan pemberdayaan sosial, serta potensi dan sumber kesejahteraan sosial Kabupaten Bojonegoro.',
                        icon: Icons.dataset_rounded,
                        color: const Color(0xFFD97706),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 30),
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

  Widget _buildProgramCard({
    required String title,
    required String badge,
    required String description,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withAlpha(20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
