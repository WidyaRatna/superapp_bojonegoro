import 'package:flutter/material.dart';
import 'security_privacy_screen.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'Bahasa Indonesia';

  void _showLanguageSelectorDialog() {
    final isDark = widget.isDarkMode;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: [
            const Icon(Icons.language_rounded, color: Color(0xFF0D62F1), size: 24),
            const SizedBox(width: 10),
            Text(
              'Pilih Bahasa Aplikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              leading: Icon(
                _selectedLanguage == 'Bahasa Indonesia' ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: _selectedLanguage == 'Bahasa Indonesia' ? const Color(0xFF0D62F1) : Colors.grey,
              ),
              title: Text(
                '🇮🇩 Bahasa Indonesia (Default)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedLanguage = 'Bahasa Indonesia';
                });
                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bahasa aplikasi diubah ke Bahasa Indonesia 🇮🇩'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
            ),
            const SizedBox(height: 6),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              leading: Icon(
                _selectedLanguage == 'English (US)' ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: _selectedLanguage == 'English (US)' ? const Color(0xFF0D62F1) : Colors.grey,
              ),
              title: Text(
                '🇺🇸 English (United States)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedLanguage = 'English (US)';
                });
                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('App language changed to English (US) 🇺🇸'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
            ),
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
              'Pengaturan Aplikasi',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text(
              'Kelola Tema, Notifikasi, Bahasa & Privasi',
              style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 11),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title: Pengaturan Utama
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Pengaturan Utama',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),

            // 1. Mode Gelap Toggle Tile
            _buildSettingCard(
              icon: isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded,
              iconColor: isDark ? Colors.amber : const Color(0xFF0D62F1),
              title: 'Mode Gelap',
              subtitle: isDark ? 'Mode gelap aktif (Lebih hemat baterai)' : 'Mode terang aktif (Standar)',
              isDark: isDark,
              trailing: Switch(
                value: isDark,
                activeTrackColor: const Color(0xFF0D62F1),
                onChanged: (val) => widget.onToggleDarkMode(),
              ),
            ),
            const SizedBox(height: 10),

            // 2. Pengaturan Notifikasi Tile
            _buildSettingCard(
              icon: Icons.notifications_active_rounded,
              iconColor: const Color(0xFFF59E0B),
              title: 'Pengaturan Notifikasi',
              subtitle: 'Status Layanan, Berita, Pengaduan, Suara & Getar',
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationSettingsScreen(isDarkMode: isDark),
                  ),
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Aktif',
                      style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 3. Bahasa Tile
            _buildSettingCard(
              icon: Icons.language_rounded,
              iconColor: const Color(0xFF06B6D4),
              title: 'Bahasa Aplikasi',
              subtitle: 'Pilih bahasa antarmuka pengguna',
              isDark: isDark,
              onTap: _showLanguageSelectorDialog,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedLanguage == 'Bahasa Indonesia' ? '🇮🇩 ID' : '🇺🇸 EN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 4. Privasi & Keamanan Tile
            _buildSettingCard(
              icon: Icons.security_rounded,
              iconColor: const Color(0xFF10B981),
              title: 'Keamanan & Privasi',
              subtitle: 'Keamanan akun, izin lokasi, NIK & privasi laporan',
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecurityPrivacyScreen(isDarkMode: isDark),
                  ),
                );
              },
              trailing: Icon(Icons.chevron_right_rounded, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDark,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
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
              fontSize: 11.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Full Screen Notification Settings Screen
// -----------------------------------------------------------------------------
class NotificationSettingsScreen extends StatefulWidget {
  final bool isDarkMode;

  const NotificationSettingsScreen({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Master Switch
  bool _masterNotificationEnabled = true;

  // Individual Channel Toggles
  bool _statusLayanan = true;
  bool _beritaPengumuman = true;
  bool _agendaKegiatan = true;
  bool _statusPengaduan = true;
  bool _informasiDarurat = true;
  bool _aktivitasAkun = true;
  bool _updateAplikasi = true;

  // Sound & Vibration Toggles
  bool _suaraNotifikasi = true;
  bool _getarNotifikasi = true;

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
              'Pengaturan Notifikasi',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text(
              'Kelola Pemberitahuan HP & Saluran Notifikasi',
              style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 11),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Master Toggle Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _masterNotificationEnabled
                      ? [const Color(0xFF0D62F1), const Color(0xFF0052D4)]
                      : [const Color(0xFF64748B), const Color(0xFF475569)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: (_masterNotificationEnabled ? const Color(0xFF0D62F1) : Colors.black).withAlpha(50),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _masterNotificationEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _masterNotificationEnabled ? 'Notifikasi HP Aktif' : 'Notifikasi HP Dinonaktifkan',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _masterNotificationEnabled
                              ? 'Anda akan menerima pemberitahuan layanan & laporan di HP'
                              : 'Semua pemberitahuan aplikasi disenyapkan',
                          style: const TextStyle(color: Color(0xFFDBEAFE), fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _masterNotificationEnabled,
                    activeTrackColor: const Color(0xFF10B981),
                    onChanged: (val) {
                      setState(() {
                        _masterNotificationEnabled = val;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            val
                                ? 'Notifikasi HP Diaktifkan! 🔔 Anda akan menerima pemberitahuan resmi.'
                                : 'Notifikasi HP Dinonaktifkan 🔕',
                          ),
                          backgroundColor: val ? const Color(0xFF10B981) : const Color(0xFF64748B),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Category 1: Saluran Notifikasi
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Saluran Notifikasi Kategori',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),

            // 1. Status Layanan
            _buildNotificationSwitchTile(
              icon: Icons.design_services_rounded,
              iconColor: const Color(0xFF0D62F1),
              title: 'Status Layanan',
              subtitle: 'Notifikasi update status permohonan layanan & dokumen',
              value: _statusLayanan && _masterNotificationEnabled,
              enabled: _masterNotificationEnabled,
              isDark: isDark,
              onChanged: (val) {
                setState(() {
                  _statusLayanan = val;
                });
              },
            ),
            const SizedBox(height: 8),

            // 2. Berita & Pengumuman
            _buildNotificationSwitchTile(
              icon: Icons.campaign_rounded,
              iconColor: const Color(0xFF06B6D4),
              title: 'Berita & Pengumuman',
              subtitle: 'Notifikasi berita terkini dan siaran pers Pemkab Bojonegoro',
              value: _beritaPengumuman && _masterNotificationEnabled,
              enabled: _masterNotificationEnabled,
              isDark: isDark,
              onChanged: (val) {
                setState(() {
                  _beritaPengumuman = val;
                });
              },
            ),
            const SizedBox(height: 8),

            // 3. Agenda Kegiatan
            _buildNotificationSwitchTile(
              icon: Icons.calendar_month_rounded,
              iconColor: const Color(0xFF8B5CF6),
              title: 'Agenda Kegiatan',
              subtitle: 'Pengingat acara bupati, festival & kegiatan daerah',
              value: _agendaKegiatan && _masterNotificationEnabled,
              enabled: _masterNotificationEnabled,
              isDark: isDark,
              onChanged: (val) {
                setState(() {
                  _agendaKegiatan = val;
                });
              },
            ),
            const SizedBox(height: 8),

            // 4. Status Pengaduan
            _buildNotificationSwitchTile(
              icon: Icons.mark_email_read_rounded,
              iconColor: const Color(0xFF10B981),
              title: 'Status Pengaduan',
              subtitle: 'Tanggapan dan tindak lanjut laporan warga Wadul Bupati',
              value: _statusPengaduan && _masterNotificationEnabled,
              enabled: _masterNotificationEnabled,
              isDark: isDark,
              onChanged: (val) {
                setState(() {
                  _statusPengaduan = val;
                });
              },
            ),
            const SizedBox(height: 8),

            // 5. Informasi Darurat
            _buildNotificationSwitchTile(
              icon: Icons.warning_amber_rounded,
              iconColor: const Color(0xFFDC2626),
              title: 'Informasi Darurat',
              subtitle: 'Peringatan siaga bencana alam, cuaca ekstrem & darurat 112',
              value: _informasiDarurat && _masterNotificationEnabled,
              enabled: _masterNotificationEnabled,
              isDark: isDark,
              onChanged: (val) {
                setState(() {
                  _informasiDarurat = val;
                });
              },
            ),
            const SizedBox(height: 8),

            // 6. Aktivitas Akun
            _buildNotificationSwitchTile(
              icon: Icons.security_rounded,
              iconColor: const Color(0xFFF59E0B),
              title: 'Aktivitas Akun',
              subtitle: 'Notifikasi keamanan login dan perubahan data profil',
              value: _aktivitasAkun && _masterNotificationEnabled,
              enabled: _masterNotificationEnabled,
              isDark: isDark,
              onChanged: (val) {
                setState(() {
                  _aktivitasAkun = val;
                });
              },
            ),
            const SizedBox(height: 8),

            // 7. Update Aplikasi
            _buildNotificationSwitchTile(
              icon: Icons.system_update_rounded,
              iconColor: const Color(0xFF6366F1),
              title: 'Update Aplikasi',
              subtitle: 'Pemberitahuan pembaruan versi SuperApp Bojonegoro',
              value: _updateAplikasi && _masterNotificationEnabled,
              enabled: _masterNotificationEnabled,
              isDark: isDark,
              onChanged: (val) {
                setState(() {
                  _updateAplikasi = val;
                });
              },
            ),
            const SizedBox(height: 20),

            // Category 2: Suara & Getaran HP
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Efek Suara & Getaran HP',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),

            // 8. Suara Notifikasi
            _buildNotificationSwitchTile(
              icon: Icons.volume_up_rounded,
              iconColor: const Color(0xFF0D62F1),
              title: 'Suara Notifikasi',
              subtitle: 'Bunyikan nada dering saat notifikasi masuk ke HP',
              value: _suaraNotifikasi && _masterNotificationEnabled,
              enabled: _masterNotificationEnabled,
              isDark: isDark,
              onChanged: (val) {
                setState(() {
                  _suaraNotifikasi = val;
                });
              },
            ),
            const SizedBox(height: 8),

            // 9. Getar Notifikasi
            _buildNotificationSwitchTile(
              icon: Icons.vibration_rounded,
              iconColor: const Color(0xFFEC4899),
              title: 'Getar',
              subtitle: 'Getarkan HP saat notifikasi baru masuk',
              value: _getarNotifikasi && _masterNotificationEnabled,
              enabled: _masterNotificationEnabled,
              isDark: isDark,
              onChanged: (val) {
                setState(() {
                  _getarNotifikasi = val;
                });
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required bool enabled,
    required bool isDark,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          leading: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: enabled ? iconColor.withAlpha(25) : Colors.grey.withAlpha(25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: enabled ? iconColor : Colors.grey, size: 20),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: enabled
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          trailing: Switch(
            value: value,
            activeTrackColor: const Color(0xFF0D62F1),
            onChanged: enabled ? onChanged : null,
          ),
        ),
      ),
    );
  }
}
