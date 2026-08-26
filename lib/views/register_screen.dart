import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;
  final VoidCallback? onLoginSuccess;

  const RegisterScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
    this.onLoginSuccess,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      final auth = AuthService();
      final success = auth.register(
        name: _nameController.text.trim(),
        nik: _nikController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran akun berhasil! Selamat datang di SuperApp Bojonegoro.'),
            backgroundColor: Color(0xFF10B981),
          ),
        );

        if (widget.onLoginSuccess != null) {
          Navigator.pop(context); // Close Register Screen
          widget.onLoginSuccess!(); // Trigger target callback
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

              // Header Title
              Center(
                child: Column(
                  children: [
                    Text(
                      'Buat Akun',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Daftarkan diri untuk menggunakan layanan SuperApp Bojonegoro.',
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
              const SizedBox(height: 32),

              // Form Inputs
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Field 1: Nama Lengkap
                    _buildInputFieldLabel('Nama Lengkap', isDark),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 14),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Mohon isi nama lengkap Anda';
                        }
                        return null;
                      },
                      decoration: _buildInputDecoration(
                        hint: 'Masukkan nama lengkap',
                        icon: Icons.person_outline_rounded,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Field 2: NIK
                    _buildInputFieldLabel('NIK', isDark),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nikController,
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 14),
                      validator: (val) {
                        if (val == null || val.trim().length != 16) {
                          return 'NIK harus 16 digit angka';
                        }
                        return null;
                      },
                      decoration: _buildInputDecoration(
                        hint: '16 digit NIK sesuai KTP',
                        icon: Icons.badge_outlined,
                        isDark: isDark,
                      ).copyWith(counterText: ''),
                    ),
                    const SizedBox(height: 18),

                    // Field 3: Email
                    _buildInputFieldLabel('Email', isDark),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 14),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty || !val.contains('@')) {
                          return 'Mohon masukkan email yang valid';
                        }
                        return null;
                      },
                      decoration: _buildInputDecoration(
                        hint: 'nama@email.com',
                        icon: Icons.email_outlined,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Field 4: Nomor HP
                    _buildInputFieldLabel('Nomor HP', isDark),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 14),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Mohon isi nomor HP aktif Anda';
                        }
                        return null;
                      },
                      decoration: _buildInputDecoration(
                        hint: '081234567890',
                        icon: Icons.phone_iphone_rounded,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Field 5: Kata Sandi
                    _buildInputFieldLabel('Kata Sandi', isDark),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 14),
                      validator: (val) {
                        if (val == null || val.trim().length < 6) {
                          return 'Kata sandi minimal 6 karakter';
                        }
                        return null;
                      },
                      decoration: _buildInputDecoration(
                        hint: 'Minimal 6 karakter',
                        icon: Icons.lock_outline_rounded,
                        isDark: isDark,
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
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Field 6: Konfirmasi Kata Sandi
                    _buildInputFieldLabel('Konfirmasi Kata Sandi', isDark),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 14),
                      validator: (val) {
                        if (val == null || val.trim() != _passwordController.text.trim()) {
                          return 'Konfirmasi kata sandi tidak cocok';
                        }
                        return null;
                      },
                      decoration: _buildInputDecoration(
                        hint: 'Ulangi kata sandi',
                        icon: Icons.lock_reset_rounded,
                        isDark: isDark,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Primary Button: Daftar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
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
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Footer Link: Sudah punya akun? Masuk
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun? ',
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
                                builder: (context) => LoginScreen(
                                  isDarkMode: widget.isDarkMode,
                                  onToggleDarkMode: widget.onToggleDarkMode,
                                  onLoginSuccess: widget.onLoginSuccess,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D62F1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
    required bool isDark,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        fontSize: 13.5,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF0D62F1), size: 20),
      suffixIcon: suffixIcon,
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
    );
  }
}
