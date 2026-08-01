import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'settings_screen.dart';
import 'security_privacy_screen.dart';
import 'faq_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// Global Profile Data Store for Persistent Session Memory
class UserProfileData {
  static String name = 'Widya Ratna';
  static String nik = '3522081234560001';
  static String email = 'widya.ratna@bojonegoro.go.id';
  static String phone = '0812-3456-7890';
  static String address = 'Jl. Mastrip No. 12, Kab. Bojonegoro';
  static String avatarType = 'default';
  static String avatarImagePath = '';
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _userName;
  late String _userNik;
  late String _userEmail;
  late String _userPhone;
  late String _userAddress;
  late String _avatarType;
  late String _avatarImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    _userName = UserProfileData.name;
    _userNik = UserProfileData.nik;
    _userEmail = UserProfileData.email;
    _userPhone = UserProfileData.phone;
    _userAddress = UserProfileData.address;
    _avatarType = UserProfileData.avatarType;
    _avatarImagePath = UserProfileData.avatarImagePath;
  }

  void _openEditProfileScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          isDarkMode: widget.isDarkMode,
          initialName: _userName,
          initialNik: _userNik,
          initialEmail: _userEmail,
          initialPhone: _userPhone,
          initialAddress: _userAddress,
          initialAvatarType: _avatarType,
          initialAvatarImagePath: _avatarImagePath,
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        UserProfileData.name = result['name'] ?? UserProfileData.name;
        UserProfileData.nik = result['nik'] ?? UserProfileData.nik;
        UserProfileData.email = result['email'] ?? UserProfileData.email;
        UserProfileData.phone = result['phone'] ?? UserProfileData.phone;
        UserProfileData.address = result['address'] ?? UserProfileData.address;
        UserProfileData.avatarType = result['avatarType'] ?? UserProfileData.avatarType;
        UserProfileData.avatarImagePath = result['avatarImagePath'] ?? UserProfileData.avatarImagePath;

        _loadProfileData();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perubahan data profil & foto berhasil disimpan!'),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 3),
          ),
        );
      }
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFF0052D4),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 50 : 25),
                    blurRadius: 16,
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
                        'Profil Saya',
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
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: buildAvatarCircle(_avatarType, 42, 50, avatarImagePath: _avatarImagePath),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _openEditProfileScreen,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A).withAlpha(200),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _openEditProfileScreen,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.edit_rounded, color: Colors.white70, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'NIK: $_userNik',
                    style: const TextStyle(
                      color: Color(0xFFDBEAFE),
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withAlpha(40),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF10B981), width: 1),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Warga Terverifikasi NIK',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildProfileMenuItem(
                    icon: Icons.person_outline_rounded,
                    color: const Color(0xFF0D62F1),
                    title: 'Data Profil',
                    subtitle: 'Lihat & perbarui informasi data diri',
                    onTap: _openEditProfileScreen,
                    isDark: isDark,
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.receipt_long_rounded,
                    color: const Color(0xFF10B981),
                    title: 'Riwayat Layanan',
                    subtitle: 'Daftar riwayat permohonan layanan publik',
                    onTap: () => _showMenuDetailModal('Riwayat Layanan'),
                    isDark: isDark,
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.campaign_rounded,
                    color: const Color(0xFFF59E0B),
                    title: 'Riwayat Pengaduan',
                    subtitle: 'Status laporan warga Wadul Bupati',
                    onTap: () => _showMenuDetailModal('Riwayat Pengaduan'),
                    isDark: isDark,
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.favorite_outline_rounded,
                    color: const Color(0xFFEC4899),
                    title: 'Favorit',
                    subtitle: 'Layanan & berita favorit tersimpan',
                    onTap: () => _showMenuDetailModal('Favorit Saya'),
                    isDark: isDark,
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.shield_outlined,
                    color: const Color(0xFF10B981),
                    title: 'Keamanan & Privasi',
                    subtitle: 'Ubah password, NIK, izin & sesi perangkat',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecurityPrivacyScreen(
                            isDarkMode: widget.isDarkMode,
                          ),
                        ),
                      );
                    },
                    isDark: isDark,
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.settings_outlined,
                    color: const Color(0xFF6366F1),
                    title: 'Pengaturan',
                    subtitle: 'Mode gelap, notifikasi & bahasa',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                            isDarkMode: widget.isDarkMode,
                            onToggleDarkMode: widget.onToggleDarkMode,
                          ),
                        ),
                      );
                    },
                    isDark: isDark,
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    color: const Color(0xFF06B6D4),
                    title: 'Bantuan',
                    subtitle: 'Pusat bantuan & FAQ pengguna',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaqScreen(
                            isDarkMode: widget.isDarkMode,
                          ),
                        ),
                      );
                    },
                    isDark: isDark,
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.info_outline_rounded,
                    color: const Color(0xFF8B5CF6),
                    title: 'Tentang Aplikasi',
                    subtitle: 'Versi 2.4.0 • Pemkab Bojonegoro',
                    onTap: () => _showMenuDetailModal('Tentang SuperApp Bojonegoro'),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _buildProfileMenuItem(
                    icon: Icons.logout_rounded,
                    color: const Color(0xFFEF4444),
                    title: 'Keluar',
                    subtitle: 'Keluar dari akun SuperApp Bojonegoro',
                    onTap: _showLogoutConfirmDialog,
                    isDark: isDark,
                    isDestructive: true,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: isDestructive
                  ? const Color(0xFFEF4444)
                  : (isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
            size: 20,
          ),
        ),
      ),
    );
  }

  void _showMenuDetailModal(String title) {
    final isDark = widget.isDarkMode;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Halaman $title sedang dalam proses integrasi data Pemkab Bojonegoro.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D62F1),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmDialog() {
    final isDark = widget.isDarkMode;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Konfirmasi Keluar',
          style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A)),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun SuperApp Bojonegoro?',
          style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Anda berhasil keluar dari akun.')),
              );
            },
            child: const Text('Keluar Akun', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

Widget buildAvatarCircle(
  String avatarType,
  double radius,
  double iconSize, {
  String? avatarImagePath,
}) {
  if (avatarImagePath != null && avatarImagePath.isNotEmpty) {
    if (kIsWeb || avatarImagePath.startsWith('blob:') || avatarImagePath.startsWith('http')) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: NetworkImage(avatarImagePath),
      );
    } else if (File(avatarImagePath).existsSync()) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: FileImage(File(avatarImagePath)),
      );
    }
  }

  Color bgColor = const Color(0xFF0D62F1);
  IconData icon = Icons.person_rounded;
  String textInitials = '';

  if (avatarType == 'kamera') {
    bgColor = const Color(0xFFEC4899);
    icon = Icons.camera_alt_rounded;
  } else if (avatarType == 'galeri') {
    bgColor = const Color(0xFF10B981);
    icon = Icons.photo_library_rounded;
  } else if (avatarType == 'formal_pria') {
    bgColor = const Color(0xFF6366F1);
    icon = Icons.account_circle_rounded;
  } else if (avatarType == 'formal_wanita') {
    bgColor = const Color(0xFF06B6D4);
    icon = Icons.face_3_rounded;
  } else if (avatarType == 'inisial') {
    bgColor = const Color(0xFF8B5CF6);
    textInitials = 'WR';
  }

  return CircleAvatar(
    radius: radius,
    backgroundColor: bgColor,
    child: textInitials.isNotEmpty
        ? Text(
            textInitials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: iconSize * 0.5,
            ),
          )
        : Icon(icon, color: Colors.white, size: iconSize),
  );
}

// Full Screen Edit Profile Screen Widget
class EditProfileScreen extends StatefulWidget {
  final bool isDarkMode;
  final String initialName;
  final String initialNik;
  final String initialEmail;
  final String initialPhone;
  final String initialAddress;
  final String initialAvatarType;
  final String initialAvatarImagePath;

  const EditProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.initialName,
    required this.initialNik,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialAddress,
    this.initialAvatarType = 'default',
    this.initialAvatarImagePath = '',
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _nikCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;

  late String _selectedAvatarType;
  late String _selectedAvatarImagePath;
  bool _isAvatarUpdated = false;
  String _avatarSource = 'Default';

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _nikCtrl = TextEditingController(text: widget.initialNik);
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _phoneCtrl = TextEditingController(text: widget.initialPhone);
    _addressCtrl = TextEditingController(text: widget.initialAddress);
    _selectedAvatarType = widget.initialAvatarType;
    _selectedAvatarImagePath = widget.initialAvatarImagePath;
    if (_selectedAvatarImagePath.isNotEmpty) {
      _isAvatarUpdated = true;
      _avatarSource = 'File Foto Perangkat';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nikCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() {
          _selectedAvatarType = 'custom_file';
          _selectedAvatarImagePath = photo.path;
          _isAvatarUpdated = true;
          _avatarSource = 'Kamera';
        });
        _showSnackBarNotice('Foto baru berhasil diambil!');
      }
    } catch (e) {
      _showSnackBarNotice('Kamera tidak tersedia. Gunakan opsi pilih file.');
    }
  }

  Future<void> _pickFromStorage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedAvatarType = 'custom_file';
          _selectedAvatarImagePath = image.path;
          _isAvatarUpdated = true;
          _avatarSource = kIsWeb ? 'File Browser' : 'File Perangkat';
        });
        _showSnackBarNotice('File foto berhasil dipilih!');
      }
    } catch (e) {
      _showSnackBarNotice('Gagal memilih file foto.');
    }
  }
  // ==============================================================

  void _showAvatarSourcePicker() {
    final isDark = widget.isDarkMode;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
            const SizedBox(height: 16),
            Text(
              'Ubah Foto Profil Saya',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pilih sumber foto profil baru dari kamera langsung atau file di perangkat Anda.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 18),

            // Option 1: Kamera (hanya tampil di HP, bukan laptop/web)
            if (!kIsWeb) ...[
              _buildPickerOption(
                ctx,
                icon: Icons.camera_alt_rounded,
                color: const Color(0xFF0D62F1),
                title: 'Ambil Foto dari Kamera',
                subtitle: 'Buka kamera HP untuk foto profil baru',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFromCamera();
                },
                isDark: isDark,
              ),
              const SizedBox(height: 10),
            ],

            // Option 2: Pilih File dari Laptop / HP (pakai file_picker)
            _buildPickerOption(
              ctx,
              icon: Icons.photo_library_rounded,
              color: const Color(0xFF10B981),
              title: 'Pilih File dari Laptop / HP',
              subtitle: 'Buka file foto (JPG/PNG) dari penyimpanan perangkat Anda',
              onTap: () {
                Navigator.pop(ctx);
                _pickFromStorage();
              },
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            // Option 3: Avatar Formal Pria Warga
            _buildPickerOption(
              ctx,
              icon: Icons.account_circle_rounded,
              color: const Color(0xFF6366F1),
              title: 'Avatar Formal Pria (Warga)',
              subtitle: 'Gunakan simbol avatar profil formal warga',
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _selectedAvatarType = 'formal_pria';
                  _selectedAvatarImagePath = '';
                  _isAvatarUpdated = true;
                  _avatarSource = 'Avatar Formal Pria';
                });
                _showSnackBarNotice('Foto profil diubah ke Avatar Formal Pria');
              },
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            // Option 4: Avatar Formal Wanita Warga
            _buildPickerOption(
              ctx,
              icon: Icons.face_3_rounded,
              color: const Color(0xFF06B6D4),
              title: 'Avatar Formal Wanita (Warga)',
              subtitle: 'Gunakan simbol avatar profil formal wanita',
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _selectedAvatarType = 'formal_wanita';
                  _selectedAvatarImagePath = '';
                  _isAvatarUpdated = true;
                  _avatarSource = 'Avatar Formal Wanita';
                });
                _showSnackBarNotice('Foto profil diubah ke Avatar Formal Wanita');
              },
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBarNotice(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildPickerOption(
    BuildContext ctx, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
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
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
          ],
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
        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF0052D4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ubah Data Profil',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text(
              'Perbarui Data Diri Warga Kab. Bojonegoro',
              style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 11),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: InkWell(
                onTap: _showAvatarSourcePicker,
                borderRadius: BorderRadius.circular(50),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isAvatarUpdated ? const Color(0xFF10B981) : const Color(0xFF0D62F1),
                              width: 3,
                            ),
                          ),
                          child: buildAvatarCircle(_selectedAvatarType, 44, 52, avatarImagePath: _selectedAvatarImagePath),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _isAvatarUpdated ? const Color(0xFF10B981) : const Color(0xFF0D62F1),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              _isAvatarUpdated ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isAvatarUpdated
                          ? 'Foto Profil Diperbarui ($_avatarSource)'
                          : 'Ketuk untuk Ubah Foto Profil (Kamera / File)',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: _isAvatarUpdated
                            ? const Color(0xFF10B981)
                            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildInputField('Nama Lengkap', _nameCtrl, Icons.person_outline_rounded, isDark),
            const SizedBox(height: 14),
            _buildInputField(
              'NIK (Nomor Induk Kependudukan)',
              _nikCtrl,
              Icons.badge_outlined,
              isDark,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            _buildInputField(
              'Email',
              _emailCtrl,
              Icons.email_outlined,
              isDark,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            _buildInputField(
              'Nomor WhatsApp / HP',
              _phoneCtrl,
              Icons.phone_outlined,
              isDark,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            _buildInputField(
              'Alamat Domisili Lengkap',
              _addressCtrl,
              Icons.location_on_outlined,
              isDark,
              maxLines: 2,
            ),
            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white70 : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D62F1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    onPressed: () {
                      Navigator.pop(context, {
                        'name': _nameCtrl.text,
                        'nik': _nikCtrl.text,
                        'email': _emailCtrl.text,
                        'phone': _phoneCtrl.text,
                        'address': _addressCtrl.text,
                        'avatarType': _selectedAvatarType,
                        'avatarImagePath': _selectedAvatarImagePath,
                      });
                    },
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isDark, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 14,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}