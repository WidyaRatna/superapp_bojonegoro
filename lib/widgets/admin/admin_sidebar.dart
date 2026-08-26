import 'package:flutter/material.dart';

class AdminSidebarItem {
  final String title;
  final IconData icon;
  final int index;

  const AdminSidebarItem({
    required this.title,
    required this.icon,
    required this.index,
  });
}

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectTab;
  final VoidCallback onLogout;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelectTab,
    required this.onLogout,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  static const List<AdminSidebarItem> sidebarItems = [
    AdminSidebarItem(title: 'Dashboard', icon: Icons.dashboard_rounded, index: 0),
    AdminSidebarItem(title: 'Kependudukan', icon: Icons.badge_rounded, index: 1),
    AdminSidebarItem(title: 'Pendidikan & Beasiswa', icon: Icons.school_rounded, index: 2),
    AdminSidebarItem(title: 'Pertanian', icon: Icons.agriculture_rounded, index: 3),
    AdminSidebarItem(title: 'Pariwisata', icon: Icons.landscape_rounded, index: 4),
    AdminSidebarItem(title: 'Lapor / Pengaduan', icon: Icons.campaign_rounded, index: 5),
    AdminSidebarItem(title: 'Kontak Instansi', icon: Icons.domain_rounded, index: 6),
    AdminSidebarItem(title: 'Layanan Darurat', icon: Icons.phone_in_talk_rounded, index: 7),
    AdminSidebarItem(title: 'Lowongan Kerja', icon: Icons.work_rounded, index: 8),
    AdminSidebarItem(title: 'Layanan Sosial', icon: Icons.volunteer_activism_rounded, index: 9),
    AdminSidebarItem(title: 'Berita', icon: Icons.newspaper_rounded, index: 10),
  ];

  @override
  Widget build(BuildContext context) {
    const Color brandColor = Color(0xFF0D62F1); // Royal Blue
    const Color sidebarBg = Color(0xFF0F172A); // Dark Slate Blue

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isCollapsed ? 76 : 260,
      decoration: const BoxDecoration(
        color: sidebarBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Sidebar Brand Header
          Container(
            height: 72,
            padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 12 : 20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF1E293B), width: 1.0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: brandColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: brandColor.withAlpha(100),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.account_balance_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SuperApp Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Kabupaten Bojonegoro',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Menu Navigation Scroll List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              itemCount: sidebarItems.length,
              itemBuilder: (context, i) {
                final item = sidebarItems[i];
                final isSelected = selectedIndex == item.index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () => onSelectTab(item.index),
                      borderRadius: BorderRadius.circular(10),
                      hoverColor: brandColor.withAlpha(30),
                      splashColor: brandColor.withAlpha(50),
                      child: Container(
                        height: 46,
                        padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 14 : 14),
                        decoration: BoxDecoration(
                          color: isSelected ? brandColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: brandColor.withAlpha(90),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                          children: [
                            Icon(
                              item.icon,
                              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                              size: 21,
                            ),
                            if (!isCollapsed) ...[
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                                    fontSize: 13.5,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Sidebar Footer (Collapse Toggle + Logout)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF1E293B), width: 1.0),
              ),
            ),
            child: Column(
              children: [
                if (onToggleCollapse != null)
                  InkWell(
                    onTap: onToggleCollapse,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment:
                            isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                        children: [
                          Icon(
                            isCollapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
                            color: const Color(0xFF94A3B8),
                            size: 22,
                          ),
                          if (!isCollapsed) ...[
                            const SizedBox(width: 12),
                            const Text(
                              'Ciutkan Menu',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: onLogout,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.logout_rounded,
                          color: Color(0xFFEF4444),
                          size: 20,
                        ),
                        if (!isCollapsed) ...[
                          const SizedBox(width: 12),
                          const Text(
                            'Keluar (Logout)',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
