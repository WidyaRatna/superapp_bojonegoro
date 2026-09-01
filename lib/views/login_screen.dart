import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'admin/admin_main_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;
  final VoidCallback? onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
    this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillAdminDemoCredentials() {
    setState(() {
      _identifierController.text = 'admin@bojonegoro.go.id';
      _passwordController.text = 'admin123';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kredensial Admin Demo terisi otomatis! Silakan tekan tombol Masuk. 🔑'),
        backgroundColor: Color(0xFF0D62F1),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final identifier = _identifierController.text.trim();
      final password = _passwordController.text.trim();
      final auth = AuthService();

      // Check if credentials are for Admin Account
      if (identifier.toLowerCase().contains('admin') || identifier == '3522000000000001') {
        final adminSuccess = auth.loginAdmin(
          email: identifier,
          password: password,
        );

        setState(() => _isLoading = false);

        if (adminSuccess && auth.isAdmin) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Autentikasi Administrator Berhasil! Selamat datang di Portal Admin Pemkab Bojonegoro.'),
              backgroundColor: Color(0xFF10B981),
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => AdminMainScreen(
                isDarkMode: widget.isDarkMode,
                onToggleDarkMode: widget.onToggleDarkMode ?? () {},
              ),
            ),
            (route) => false,
          );
          return;
        }
      }

      // Standard User Login
      final success = auth.login(
        identifier: identifier,
        password: password,
      );

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil masuk ke akun Anda!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );

        if (widget.onLoginSuccess != null) {
          Navigator.pop(context); // Close Login Screen
          widget.onLoginSuccess!(); // Restore target service screen
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                isDarkMode: widget.isDarkMode,
                onToggleDarkMode: widget.onToggleDarkMode ?? () {},
              ),
            ),
            (route) => false,
          );
        }
      }
    });
  }

  void _showForgotPasswordDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Untuk mereset kata sandi, silakan hubungi Layanan Bantuan Pemkab Bojonegoro.'),
        backgroundColor: Color(0xFF0D62F1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Action Navigation Bar (Back Button Left & Dark Mode Right)
              Padding(
                padding: EdgeInsets.only(top: topPadding > 0 ? 8 : 12, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        size: 22,
                      ),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Kembali',
                    ),
                    if (widget.onToggleDarkMode != null)
                      IconButton(
                        icon: Icon(
                          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          color: isDark ? Colors.amber : const Color(0xFF0D62F1),
                          size: 22,
                        ),
                        onPressed: widget.onToggleDarkMode,
                        tooltip: 'Ganti Mode',
                      ),
                  ],
                ),
              ),

              // Header Branding & Title
              Center(
                child: Column(
                  children: [
                    // Proportional Logo
                    Container(
                      width: 68,
                      height: 68,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 40 : 12),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/1/18/Logo_Kabupaten_Bojonegoro.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.account_balance_rounded,
                          color: Color(0xFF0D62F1),
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Selamat Datang Kembali',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Masuk untuk mengakses layanan SuperApp Bojonegoro.',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Form Inputs
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Field 1: NIK / Email
                    Text(
                      'NIK / Email',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _identifierController,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 14,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Mohon masukkan NIK atau Email Anda';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Masukkan NIK atau Email',
                        hintStyle: TextStyle(
                          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          fontSize: 13.5,
                        ),
                        prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF0D62F1), size: 20),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D62F1),
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFEF4444)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Field 2: Kata Sandi
                    Text(
                      'Kata Sandi',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 14,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Mohon masukkan kata sandi Anda';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Masukkan kata sandi',
                        hintStyle: TextStyle(
                          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          fontSize: 13.5,
                        ),
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF0D62F1), size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D62F1),
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFEF4444)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                        ),
                      ),
                    ),

                    // Lupa Kata Sandi Text Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPasswordDialog,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Lupa kata sandi?',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D62F1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Primary Button: Masuk
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D62F1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Footer Link: Belum punya akun? Daftar
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(
                                  isDarkMode: widget.isDarkMode,
                                  onToggleDarkMode: widget.onToggleDarkMode,
                                  onLoginSuccess: widget.onLoginSuccess,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D62F1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Demo Administrator Credentials Quick Fill Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF0D62F1).withAlpha(isDark ? 60 : 30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.shield_rounded, color: Color(0xFF0D62F1), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Akun Demo Administrator:',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '• Email: admin@bojonegoro.go.id\n• Password: admin123',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 38,
                            child: OutlinedButton.icon(
                              onPressed: _fillAdminDemoCredentials,
                              icon: const Icon(Icons.touch_app_rounded, color: Color(0xFF0D62F1), size: 16),
                              label: const Text(
                                'Isi Otomatis Akun Admin Demo',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0D62F1),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF0D62F1), width: 1.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
