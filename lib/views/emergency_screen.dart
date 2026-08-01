import 'package:flutter/material.dart';

class EmergencyScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const EmergencyScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode;

    final emergencyContacts = [
      {
        'title': 'Call Center 112 (Bebas Pulsa 24 Jam)',
        'subtitle': 'Layanan Darurat Utama Pemkab Bojonegoro',
        'phone': '112',
        'icon': Icons.notifications_active_rounded,
        'color': const Color(0xFFDC2626), // Emergency Red
        'isHero': true,
      },
      {
        'title': 'Ambulans & Gawat Darurat RSUD',
        'subtitle': 'RSUD dr. R. Sosodoro Djatikoesoemo Bojonegoro',
        'phone': '0811-3444-118',
        'icon': Icons.medical_services_rounded,
        'color': const Color(0xFF10B981), // Emerald
        'isHero': false,
      },
      {
        'title': 'Pemadam Kebakaran (Damkar)',
        'subtitle': 'Dinas Pemadam Kebakaran & Penyelamatan',
        'phone': '(0353) 881511',
        'icon': Icons.local_fire_department_rounded,
        'color': const Color(0xFFF97316), // Orange Damkar
        'isHero': false,
      },
      {
        'title': 'BPBD Penanggulangan Bencana',
        'subtitle': 'Badan Penanggulangan Bencana Daerah',
        'phone': '(0353) 887011',
        'icon': Icons.tsunami_rounded,
        'color': const Color(0xFF0284C7), // Blue BPBD
        'isHero': false,
      },
      {
        'title': 'Polres Bojonegoro (Kepolisian)',
        'subtitle': 'Sentra Pelayanan Kepolisian Terpadu (SPKT)',
        'phone': '110',
        'icon': Icons.local_police_rounded,
        'color': const Color(0xFF1E40AF), // Police Blue
        'isHero': false,
      },
      {
        'title': 'PMI Kab. Bojonegoro (Krisis & Blood Bank)',
        'subtitle': 'Palang Merah Indonesia Bojonegoro',
        'phone': '(0353) 881180',
        'icon': Icons.bloodtype_rounded,
        'color': const Color(0xFFE11D48), // Rose
        'isHero': false,
      },
      {
        'title': 'PLN Rayon Bojonegoro (Gangguan Listrik)',
        'subtitle': 'Layanan Gangguan Listrik & Darurat',
        'phone': '123',
        'icon': Icons.bolt_rounded,
        'color': const Color(0xFFEAB308), // Yellow PLN
        'isHero': false,
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFDC2626),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Telepon & Layanan Darurat',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text(
              'Kabupaten Bojonegoro • Siaga 24 Jam',
              style: TextStyle(color: Color(0xFFFCA5A5), fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amber : Colors.white,
            ),
            onPressed: onToggleDarkMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Emergency Notice Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDC2626).withAlpha(80),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone_in_talk_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Panggilan Darurat Utama',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Layanan Call Center 112 Bebas Pulsa (Gratis 24 Jam Non-Stop).',
                          style: TextStyle(
                            color: Color(0xFFFEE2E2),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFDC2626),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.call_rounded, size: 16),
                          label: const Text(
                            'Panggil Now 112',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          onPressed: () {
                            _makeCall(context, '112', 'Call Center 112 Bojonegoro');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Daftar Nomor Kontak Darurat',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),

            // Emergency Contacts List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: emergencyContacts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = emergencyContacts[index];
                final IconData icon = item['icon'] as IconData;
                final Color color = item['color'] as Color;
                final String title = item['title'] as String;
                final String subtitle = item['subtitle'] as String;
                final String phone = item['phone'] as String;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDark ? 30 : 10),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withAlpha(25),
                          borderRadius: BorderRadius.circular(14),
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
                                fontSize: 13.5,
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
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.call_rounded, color: Colors.white, size: 14),
                        label: Text(
                          phone,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          _makeCall(context, phone, title);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _makeCall(BuildContext context, String number, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menghubungkan panggilan darurat ke $name ($number)... 📞'),
        backgroundColor: const Color(0xFFDC2626),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
