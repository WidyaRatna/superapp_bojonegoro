import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../views/login_screen.dart';
import '../views/register_screen.dart';

/// Helper Guard for protected features requiring user authentication.
class AuthGuard {
  /// Checks if the user is authenticated.
  /// If authenticated, executes [onAuthenticated] immediately.
  /// If Guest, shows the "Login Diperlukan" bottom sheet modal.
  static void requireLogin(
    BuildContext context, {
    required VoidCallback onAuthenticated,
    String? serviceName,
    bool isDarkMode = false,
    VoidCallback? onToggleDarkMode,
  }) {
    final auth = AuthService();

    if (auth.isLoggedIn) {
      onAuthenticated();
      return;
    }

    // Show "Login Diperlukan" Centered Popup Dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (modalContext) {
        final isDark = isDarkMode || Theme.of(modalContext).brightness == Brightness.dark;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lock Icon Badge Container
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D62F1).withAlpha(isDark ? 40 : 15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0D62F1).withAlpha(50),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.lock_person_rounded,
                    color: Color(0xFF0D62F1),
                    size: 34,
                  ),
                ),
                const SizedBox(height: 18),

                // Title
                Text(
                  'Login Diperlukan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  serviceName != null && serviceName.isNotEmpty
                      ? 'Silakan masuk atau daftar terlebih dahulu untuk menggunakan $serviceName.'
                      : 'Silakan masuk atau daftar terlebih dahulu untuk menggunakan layanan ini.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Button 1: Masuk (Primary)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(modalContext); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(
                            isDarkMode: isDarkMode,
                            onToggleDarkMode: onToggleDarkMode,
                            onLoginSuccess: () {
                              // Automatically proceed to intended service after login
                              onAuthenticated();
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.login_rounded, color: Colors.white, size: 20),
                    label: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D62F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Button 2: Daftar (Outlined)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(modalContext); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(
                            isDarkMode: isDarkMode,
                            onToggleDarkMode: onToggleDarkMode,
                            onLoginSuccess: () {
                              // Automatically proceed to intended service after register
                              onAuthenticated();
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF0D62F1), size: 20),
                    label: const Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D62F1),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0D62F1), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Button 3: Batal (Text Button)
                TextButton(
                  onPressed: () => Navigator.pop(modalContext),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
