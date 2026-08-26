import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/admin/admin_sidebar.dart';
import 'admin_dashboard_overview_screen.dart';
import 'admin_emergency_screen.dart';
import 'admin_kependudukan_screen.dart';
import 'admin_kontak_instansi_screen.dart';
import 'admin_lapor_screen.dart';
import 'admin_layanan_sosial_screen.dart';
import 'admin_login_screen.dart';
import 'admin_loker_screen.dart';
import 'admin_news_screen.dart';
import 'admin_pariwisata_screen.dart';
import 'admin_pendidikan_screen.dart';
import 'admin_pertanian_screen.dart';

class AdminMainScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const AdminMainScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedTabIndex = 0;
  bool _isSidebarCollapsed = false;

  @override
  void initState() {
    super.initState();
    // Security Route Guard: Enforce Admin Role Check on Screen Initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = AuthService();
      if (!auth.isLoggedIn || !auth.isAdmin) {
        // Access Denied: User is not authenticated as Admin -> Redirect to Admin Login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akses Ditolak: Anda harus login sebagai Admin untuk mengakses Dashboard.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminLoginScreen(
              isDarkMode: widget.isDarkMode,
              onToggleDarkMode: widget.onToggleDarkMode,
            ),
          ),
        );
      }
    });
  }

  void _handleAdminLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Konfirmasi Logout Admin'),
        content: const Text('Apakah Anda yakin ingin keluar dari sesi Admin Dashboard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AuthService().logout();
              // Admin Logout redirects back to Admin Login Screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminLoginScreen(
                    isDarkMode: widget.isDarkMode,
                    onToggleDarkMode: widget.onToggleDarkMode,
                  ),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Keluar (Logout)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    switch (_selectedTabIndex) {
      case 0:
        return AdminDashboardOverviewScreen(
          onNavigateTab: (index) => setState(() => _selectedTabIndex = index),
        );
      case 1:
        return const AdminKependudukanScreen();
      case 2:
        return const AdminPendidikanScreen();
      case 3:
        return const AdminPertanianScreen();
      case 4:
        return const AdminPariwisataScreen();
      case 5:
        return const AdminLaporScreen();
      case 6:
        return const AdminKontakInstansiScreen();
      case 7:
        return const AdminEmergencyScreen();
      case 8:
        return const AdminLokerScreen();
      case 9:
        return const AdminLayananSosialScreen();
      case 10:
        return const AdminNewsScreen();
      default:
        return AdminDashboardOverviewScreen(
          onNavigateTab: (index) => setState(() => _selectedTabIndex = index),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    // Secondary Security Check
    if (!authService.isLoggedIn || !authService.isAdmin) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF0D62F1)),
        ),
      );
    }

    final user = authService.currentUser;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Left Permanent Sidebar for Desktop/Tablet
          if (isDesktop)
            AdminSidebar(
              selectedIndex: _selectedTabIndex,
              onSelectTab: (index) => setState(() => _selectedTabIndex = index),
              onLogout: _handleAdminLogout,
              isCollapsed: _isSidebarCollapsed,
              onToggleCollapse: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
            ),

          // Main Screen Area (Topbar Header + Content Body)
          Expanded(
            child: Column(
              children: [
                // Topbar Header
                Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Mobile Drawer Toggle or Active Menu Title
                      Expanded(
                        child: Row(
                          children: [
                            if (!isDesktop)
                              IconButton(
                                icon: const Icon(Icons.menu_rounded, color: Color(0xFF0F172A)),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.85,
                                      child: AdminSidebar(
                                        selectedIndex: _selectedTabIndex,
                                        onSelectTab: (index) {
                                          Navigator.pop(context);
                                          setState(() => _selectedTabIndex = index);
                                        },
                                        onLogout: () {
                                          Navigator.pop(context);
                                          _handleAdminLogout();
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                AdminSidebar.sidebarItems[_selectedTabIndex].title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                  letterSpacing: -0.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Admin Profile Avatar & Quick Actions Right Topbar
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Theme Toggle Button
                          IconButton(
                            icon: Icon(
                              widget.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                              color: const Color(0xFF0D62F1),
                              size: 20,
                            ),
                            onPressed: widget.onToggleDarkMode,
                            tooltip: 'Ganti Mode Tampilan',
                          ),

                          // Notification Badge
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF475569)),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Sistem Admin Bojonegoro: Semua layanan berjalan normal.'),
                                      backgroundColor: Color(0xFF0D62F1),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 6),

                          // Admin User Profile Avatar (Compact on Mobile, Full on Desktop)
                          PopupMenuButton<String>(
                            onSelected: (val) {
                              if (val == 'logout') {
                                _handleAdminLogout();
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                enabled: false,
                                child: Text(
                                  user?.email ?? 'admin@bojonegoro.go.id',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0D62F1)),
                                ),
                              ),
                              const PopupMenuDivider(),
                              const PopupMenuItem(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    Icon(Icons.logout_rounded, color: Colors.red, size: 18),
                                    SizedBox(width: 8),
                                    Text('Kelolar (Logout)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D62F1),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0D62F1).withAlpha(50),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.admin_panel_settings_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                if (isDesktop) ...[
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.name ?? 'Admin Bojonegoro',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const Text(
                                        'Administrator System',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0D62F1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Main Content Body
                Expanded(child: _buildBodyContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
