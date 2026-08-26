import 'package:flutter/material.dart';

class SecurityPrivacyScreen extends StatefulWidget {
  final bool isDarkMode;

  const SecurityPrivacyScreen({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  // State variables for Privacy Settings
  String _profileStatus = 'Publik'; // 'Publik' or 'Privat'
  bool _showNIK = false; // False = masked NIK, True = visible NIK
  bool _locationPermission = true;
  bool _cameraPermission = true;
  bool _storagePermission = true;
  String _reportPrivacyDefault = 'Publik (Nama Tersamar)'; // 'Publik', 'Anonim', 'Rahasia'

  // User Info Mock Data
  String _userEmail = 'warga.bojonegoro@go.id';
  String _userPhone = '+62 812-3456-7890';
  final String _nikMasked = '352210************';
  final String _nikFull = '3522101908950001';

  // Active Devices Mock Data
  final List<Map<String, String>> _activeDevices = [
    {
      'name': 'Samsung Galaxy S23 Ultra',
      'location': 'Kec. Bojonegoro (Perangkat Ini)',
      'time': 'Aktif Sekarang',
      'icon': 'mobile',
      'isCurrent': 'true',
    },
    {
      'name': 'Chrome Web (Windows 11)',
      'location': 'Kec. Kapas, Bojonegoro',
      'time': '2 jam yang lalu',
      'icon': 'desktop',
      'isCurrent': 'false',
    },
    {
      'name': 'iPad Air (iOS 17.4)',
      'location': 'Kec. Dander, Bojonegoro',
      'time': '3 hari yang lalu',
      'icon': 'tablet',
      'isCurrent': 'false',
    },
  ];

  void _showSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ==================== KEAMANAN DIALOGS & MODALS ====================

  void _showChangePasswordModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
    double passwordStrength = 0.0;
    String strengthText = 'Ketik password baru';
    Color strengthColor = Colors.grey;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (modalCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void checkPasswordStrength(String val) {
              if (val.isEmpty) {
                passwordStrength = 0.0;
                strengthText = 'Ketik password baru';
                strengthColor = Colors.grey;
              } else if (val.length < 6) {
                passwordStrength = 0.25;
                strengthText = 'Sangat Lemah (Minimal 8 Karakter)';
                strengthColor = const Color(0xFFEF4444);
              } else if (val.length < 8 || !val.contains(RegExp(r'[0-9]'))) {
                passwordStrength = 0.5;
                strengthText = 'Sedang (Gunakan Angka & Huruf Kapital)';
                strengthColor = const Color(0xFFF59E0B);
              } else if (!val.contains(RegExp(r'[A-Z]')) || !val.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                passwordStrength = 0.75;
                strengthText = 'Kuat (Tambahkan Simbol Spesial)';
                strengthColor = const Color(0xFF3B82F6);
              } else {
                passwordStrength = 1.0;
                strengthText = 'Sangat Kuat';
                strengthColor = const Color(0xFF10B981);
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D62F1).withAlpha(30),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.key_rounded, color: Color(0xFF0D62F1), size: 24),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ubah Password Akun',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Gunakan kombinasi huruf, angka, & simbol',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Old Password Input
                  TextField(
                    controller: oldPasswordController,
                    obscureText: obscureOld,
                    style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A)),
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Saat Ini',
                      labelStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF0D62F1)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureOld ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                        onPressed: () => setModalState(() => obscureOld = !obscureOld),
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF0D62F1), width: 1.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // New Password Input
                  TextField(
                    controller: newPasswordController,
                    obscureText: obscureNew,
                    style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A)),
                    onChanged: (val) {
                      setModalState(() {
                        checkPasswordStrength(val);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Baru',
                      labelStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      prefixIcon: const Icon(Icons.lock_clock_outlined, color: Color(0xFF0D62F1)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                        onPressed: () => setModalState(() => obscureNew = !obscureNew),
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF0D62F1), width: 1.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Strength Meter Bar
                  if (newPasswordController.text.isNotEmpty) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: passwordStrength,
                              backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                              color: strengthColor,
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          strengthText,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: strengthColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Confirm New Password Input
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirm,
                    style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A)),
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Kata Sandi Baru',
                      labelStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      prefixIcon: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF0D62F1)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                        onPressed: () => setModalState(() => obscureConfirm = !obscureConfirm),
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF0D62F1), width: 1.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Password Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D62F1),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (oldPasswordController.text.isEmpty) {
                          _showSnackBar('Masukkan kata sandi saat ini', Icons.warning_amber_rounded, Colors.orange);
                          return;
                        }
                        if (newPasswordController.text.length < 8) {
                          _showSnackBar('Password baru minimal 8 karakter', Icons.error_outline_rounded, Colors.red);
                          return;
                        }
                        if (newPasswordController.text != confirmPasswordController.text) {
                          _showSnackBar('Konfirmasi password tidak cocok', Icons.error_outline_rounded, Colors.red);
                          return;
                        }
                        Navigator.pop(modalCtx);
                        _showSnackBar('Password akun berhasil diperbarui', Icons.check_circle_rounded, const Color(0xFF10B981));
                      },
                      child: const Text(
                        'Simpan Password Baru',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDevicesModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (modalCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withAlpha(30),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.devices_rounded, color: Color(0xFF10B981), size: 24),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Perangkat Masuk',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Daftar perangkat yang terhubung ke akun Anda',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Device List Items
                  ..._activeDevices.map((device) {
                    final bool isCurrent = device['isCurrent'] == 'true';
                    IconData iconData = Icons.smartphone_rounded;
                    if (device['icon'] == 'desktop') iconData = Icons.desktop_windows_rounded;
                    if (device['icon'] == 'tablet') iconData = Icons.tablet_mac_rounded;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isCurrent
                              ? const Color(0xFF10B981).withAlpha(150)
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          width: isCurrent ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? const Color(0xFF10B981).withAlpha(30)
                                  : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              iconData,
                              color: isCurrent
                                  ? const Color(0xFF10B981)
                                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        device['name']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    if (isCurrent)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withAlpha(30),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Aktif',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF10B981),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${device['location']} • ${device['time']}',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isCurrent)
                            IconButton(
                              icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
                              onPressed: () {
                                setModalState(() {
                                  _activeDevices.removeWhere((d) => d['name'] == device['name']);
                                });
                                setState(() {});
                                _showSnackBar(
                                  'Perangkat ${device['name']} berhasil dikeluarkan',
                                  Icons.check_circle_rounded,
                                  const Color(0xFF10B981),
                                );
                              },
                              tooltip: 'Keluarkan Perangkat',
                            ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // Logout all other devices button
                  if (_activeDevices.where((d) => d['isCurrent'] != 'true').isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFEF4444), width: 1.4),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.phonelink_erase_rounded, color: Color(0xFFEF4444), size: 20),
                        label: const Text(
                          'Keluarkan dari Semua Perangkat Lain',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                        onPressed: () {
                          setModalState(() {
                            _activeDevices.removeWhere((d) => d['isCurrent'] != 'true');
                          });
                          setState(() {});
                          Navigator.pop(modalCtx);
                          _showSnackBar(
                            'Seluruh perangkat lain berhasil dikeluarkan dari akun',
                            Icons.security_rounded,
                            const Color(0xFF10B981),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showChangeEmailDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
    final emailController = TextEditingController(text: _userEmail);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.email_rounded, color: Color(0xFF3B82F6), size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              'Ubah Alamat Email',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kode verifikasi akan dikirimkan ke email baru Anda.',
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A)),
              decoration: InputDecoration(
                labelText: 'Email Baru',
                labelStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                prefixIcon: const Icon(Icons.alternate_email_rounded, color: Color(0xFF3B82F6)),
                filled: true,
                fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text('Batal', style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D62F1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (emailController.text.contains('@') && emailController.text.contains('.')) {
                setState(() {
                  _userEmail = emailController.text;
                });
                Navigator.pop(dialogCtx);
                _showSnackBar('Kode OTP verifikasi dikirim ke ${emailController.text} 📧', Icons.mark_email_read_rounded, const Color(0xFF10B981));
              } else {
                _showSnackBar('Format alamat email tidak valid', Icons.error_outline_rounded, Colors.red);
              }
            },
            child: const Text('Kirim OTP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showChangePhoneDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
    final phoneController = TextEditingController(text: _userPhone);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.phone_android_rounded, color: Color(0xFF10B981), size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              'Ubah Nomor HP',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nomor HP digunakan untuk login SMS/WhatsApp OTP dan notifikasi laporan darurat.',
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A)),
              decoration: InputDecoration(
                labelText: 'Nomor Handphone Baru',
                labelStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                prefixIcon: const Icon(Icons.phone_rounded, color: Color(0xFF10B981)),
                filled: true,
                fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text('Batal', style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (phoneController.text.length >= 10) {
                setState(() {
                  _userPhone = phoneController.text;
                });
                Navigator.pop(dialogCtx);
                _showSnackBar('OTP WhatsApp dikirim ke ${phoneController.text} 📱', Icons.chat_rounded, const Color(0xFF10B981));
              } else {
                _showSnackBar('Nomor HP minimal 10 digit angka', Icons.error_outline_rounded, Colors.red);
              }
            },
            child: const Text('Kirim OTP WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ==================== PRIVASI DIALOGS & MODALS ====================

  void _showProfileStatusSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Status Visibilitas Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pilih siapa yang dapat melihat informasi profil Anda',
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              tileColor: _profileStatus == 'Publik' ? const Color(0xFF0D62F1).withAlpha(20) : null,
              leading: const Icon(Icons.public_rounded, color: Color(0xFF0D62F1)),
              title: Text(
                'Profil Publik',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              subtitle: const Text('Dapat dilihat oleh sesama warga Bojonegoro'),
              trailing: _profileStatus == 'Publik' ? const Icon(Icons.check_circle_rounded, color: Color(0xFF0D62F1)) : null,
              onTap: () {
                setState(() => _profileStatus = 'Publik');
                Navigator.pop(sheetCtx);
                _showSnackBar('Status profil diubah ke Publik', Icons.public_rounded, const Color(0xFF0D62F1));
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              tileColor: _profileStatus == 'Privat' ? const Color(0xFF0D62F1).withAlpha(20) : null,
              leading: const Icon(Icons.lock_rounded, color: Color(0xFF8B5CF6)),
              title: Text(
                'Profil Privat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              subtitle: const Text('Hanya dapat dilihat Anda & Petugas Pemkab'),
              trailing: _profileStatus == 'Privat' ? const Icon(Icons.check_circle_rounded, color: Color(0xFF8B5CF6)) : null,
              onTap: () {
                setState(() => _profileStatus = 'Privat');
                Navigator.pop(sheetCtx);
                _showSnackBar('Status profil diubah ke Privat', Icons.lock_rounded, const Color(0xFF8B5CF6));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReportPrivacySelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Default Privasi Laporan Warga',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pengaturan bawaan saat Anda mengirimkan pengaduan/laporan',
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            _buildReportOption(sheetCtx, 'Publik (Nama Tersamar)', 'Publik', 'Laporan dapat dilihat umum dengan nama tersamar', Icons.campaign_rounded, const Color(0xFF0D62F1)),
            _buildReportOption(sheetCtx, 'Anonim (Disembunyikan)', 'Anonim', 'Identitas pelapor sepenuhnya dirahasiakan', Icons.visibility_off_rounded, const Color(0xFFF59E0B)),
            _buildReportOption(sheetCtx, 'Rahasia (Khusus Dinas)', 'Rahasia', 'Hanya dapat dibaca oleh Dinas / Instansi Terkait', Icons.admin_panel_settings_rounded, const Color(0xFFEF4444)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOption(BuildContext sheetCtx, String key, String label, String sub, IconData icon, Color color) {
    final bool isSelected = _reportPrivacyDefault == key;
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: isSelected ? color.withAlpha(20) : null,
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        subtitle: Text(sub, style: const TextStyle(fontSize: 11.5)),
        trailing: isSelected ? Icon(Icons.check_circle_rounded, color: color) : null,
        onTap: () {
          setState(() => _reportPrivacyDefault = key);
          Navigator.pop(sheetCtx);
          _showSnackBar('Default privasi laporan: $label', icon, color);
        },
      ),
    );
  }

  // ==================== MAIN BUILD METHOD ====================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Keamanan & Privasi',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Health Banner Card
            _buildSecurityScoreCard(isDark),
            const SizedBox(height: 24),

            // SECTION 1: KEAMANAN
            _buildSectionHeader('KEAMANAN', 'Kelola kata sandi & sesi perangkat terhubung', isDark),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 30 : 6),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.vpn_key_rounded,
                    iconColor: const Color(0xFF0D62F1),
                    title: 'Ubah Password',
                    subtitle: 'Perbarui kata sandi akun secara berkala',
                    isDark: isDark,
                    onTap: _showChangePasswordModal,
                    trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                  ),
                  _buildDivider(isDark),
                  _buildListTile(
                    icon: Icons.devices_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: 'Perangkat Masuk',
                    subtitle: '${_activeDevices.length} Perangkat Aktif • Terakhir di Bojonegoro',
                    isDark: isDark,
                    onTap: _showDevicesModal,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_activeDevices.length} Aktif',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ),
                  _buildDivider(isDark),
                  _buildListTile(
                    icon: Icons.email_rounded,
                    iconColor: const Color(0xFF3B82F6),
                    title: 'Ubah Email',
                    subtitle: _userEmail,
                    isDark: isDark,
                    onTap: _showChangeEmailDialog,
                    trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                  ),
                  _buildDivider(isDark),
                  _buildListTile(
                    icon: Icons.phone_android_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'Ubah Nomor HP',
                    subtitle: '$_userPhone • Verifikasi WA',
                    isDark: isDark,
                    onTap: _showChangePhoneDialog,
                    trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // SECTION 2: PRIVASI
            _buildSectionHeader('PRIVASI', 'Kontrol privasi profil, NIK & izin aplikasi', isDark),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 30 : 6),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 1. Status Profil
                  _buildListTile(
                    icon: Icons.account_circle_rounded,
                    iconColor: const Color(0xFF0D62F1),
                    title: 'Status Profil',
                    subtitle: _profileStatus == 'Publik'
                        ? 'Publik • Warga lain dapat melihat nama Anda'
                        : 'Privat • Hanya terlihat oleh Anda & petugas',
                    isDark: isDark,
                    onTap: _showProfileStatusSelector,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _profileStatus,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: _profileStatus == 'Publik' ? const Color(0xFF0D62F1) : const Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                      ],
                    ),
                  ),
                  _buildDivider(isDark),

                  // 2. Tampilkan NIK Toggle
                  _buildSwitchTile(
                    icon: Icons.badge_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Tampilkan NIK',
                    subtitle: _showNIK
                        ? 'NIK Terbuka: $_nikFull'
                        : 'NIK Tersensor: $_nikMasked',
                    value: _showNIK,
                    isDark: isDark,
                    onChanged: (val) {
                      setState(() => _showNIK = val);
                      _showSnackBar(
                        val ? 'NIK ditampilkan pada tampilan profil' : 'NIK disembunyikan/tersensor (Standar Privasi)',
                        val ? Icons.badge_rounded : Icons.lock_rounded,
                        val ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                      );
                    },
                  ),
                  _buildDivider(isDark),

                  // 3. Izin Lokasi
                  _buildSwitchTile(
                    icon: Icons.location_on_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: 'Izin Lokasi',
                    subtitle: _locationPermission
                        ? 'Diizinkan saat aplikasi dibuka (GPS Presisi Tinggi)'
                        : 'Lokasi dinonaktifkan (Memengaruhi laporan warga)',
                    value: _locationPermission,
                    isDark: isDark,
                    onChanged: (val) {
                      setState(() => _locationPermission = val);
                      _showSnackBar(
                        val ? 'Izin akses lokasi GPS diaktifkan' : 'Izin lokasi dinonaktifkan',
                        val ? Icons.location_on_rounded : Icons.location_off_rounded,
                        val ? const Color(0xFF10B981) : Colors.orange,
                      );
                    },
                  ),
                  _buildDivider(isDark),

                  // 4. Izin Kamera
                  _buildSwitchTile(
                    icon: Icons.camera_alt_rounded,
                    iconColor: const Color(0xFFEC4899),
                    title: 'Izin Kamera',
                    subtitle: _cameraPermission
                        ? 'Diizinkan untuk foto laporan & scan QR KTP'
                        : 'Kamera dinonaktifkan',
                    value: _cameraPermission,
                    isDark: isDark,
                    onChanged: (val) {
                      setState(() => _cameraPermission = val);
                      _showSnackBar(
                        val ? 'Izin kamera diaktifkan' : 'Izin kamera dinonaktifkan',
                        val ? Icons.camera_alt_rounded : Icons.camera_outlined,
                        val ? const Color(0xFF10B981) : Colors.orange,
                      );
                    },
                  ),
                  _buildDivider(isDark),

                  // 5. Izin Penyimpanan
                  _buildSwitchTile(
                    icon: Icons.folder_special_rounded,
                    iconColor: const Color(0xFF06B6D4),
                    title: 'Izin Penyimpanan',
                    subtitle: _storagePermission
                        ? 'Diizinkan untuk simpan & lampirkan dokumen'
                        : 'Akses galeri & berkas dinonaktifkan',
                    value: _storagePermission,
                    isDark: isDark,
                    onChanged: (val) {
                      setState(() => _storagePermission = val);
                      _showSnackBar(
                        val ? 'Izin penyimpanan diaktifkan' : 'Izin penyimpanan dinonaktifkan',
                        val ? Icons.folder_special_rounded : Icons.folder_off_rounded,
                        val ? const Color(0xFF10B981) : Colors.orange,
                      );
                    },
                  ),
                  _buildDivider(isDark),

                  // 6. Privasi Laporan
                  _buildListTile(
                    icon: Icons.description_rounded,
                    iconColor: const Color(0xFF6366F1),
                    title: 'Privasi Laporan',
                    subtitle: 'Default: $_reportPrivacyDefault',
                    isDark: isDark,
                    onTap: _showReportPrivacySelector,
                    trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // SSL Certification Footnote Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withAlpha(18),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF10B981).withAlpha(60),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: Color(0xFF10B981), size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Terlindungi SSL 256-bit',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Seluruh informasi dilindungi enkripsi kelas pemerintah sesuai standar Diskominfo Pemkab Bojonegoro.',
                          style: TextStyle(
                            fontSize: 11.5,
                            height: 1.35,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ==================== REUSABLE HELPER WIDGETS ====================

  Widget _buildSecurityScoreCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D62F1), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D62F1).withAlpha(80),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        'Skor Keamanan Akun',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '95% Sangat Aman',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Akun & Privasi Terlindungi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Autentikasi 2-Faktor Aktif • Enkripsi End-to-End',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withAlpha(210),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0D62F1),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required bool isDark,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: Colors.transparent,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeTrackColor: const Color(0xFF0D62F1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 62,
      endIndent: 16,
      color: isDark ? const Color(0xFF334155).withAlpha(150) : const Color(0xFFF1F5F9),
    );
  }
}
