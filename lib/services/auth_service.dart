import 'package:flutter/material.dart';

/// User Account Data Model
class UserAccount {
  final String name;
  final String nik;
  final String email;
  final String phone;
  final String role; // 'admin' or 'user' / 'Warga Bojonegoro'
  final String avatarUrl;

  const UserAccount({
    required this.name,
    required this.nik,
    required this.email,
    required this.phone,
    this.role = 'user',
    this.avatarUrl = '',
  });

  bool get isAdmin => role.toLowerCase() == 'admin' || role.toLowerCase().contains('administrator');
}

/// Centralized Authentication Service for SuperApp Bojonegoro.
/// Supports Guest Mode + User Service Auth + Isolated Admin Authentication Flow.
class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isGuest = true;
  bool _isLoggedIn = false;
  bool _hasSeenOnboarding = false;
  UserAccount? _currentUser;

  // Getters
  bool get isGuest => _isGuest;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  UserAccount? get currentUser => _currentUser;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  /// Mark onboarding screen as completed
  void completeOnboarding() {
    _hasSeenOnboarding = true;
    notifyListeners();
  }

  /// Continue application as Guest user (Default Startup State)
  void loginAsGuest() {
    _isGuest = true;
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  /// Perform USER Login with NIK/Email and Password
  // TODO: [Backend Auth Integration] Replace with Supabase Auth: supabase.auth.signInWithPassword(...)
  bool login({
    required String identifier,
    required String password,
    String? name,
  }) {
    final cleanId = identifier.trim().toLowerCase();
    final cleanPass = password.trim();

    if (cleanId.isEmpty || cleanPass.isEmpty) {
      return false;
    }

    _isGuest = false;
    _isLoggedIn = true;
    _currentUser = UserAccount(
      name: name ?? 'Budi Santoso',
      nik: cleanId.contains('@') ? '3522102005920001' : cleanId,
      email: cleanId.contains('@') ? cleanId : 'budi.santoso@bojonegoro.go.id',
      phone: '081234567890',
      role: 'user',
    );

    notifyListeners();
    return true;
  }

  /// Dedicated ADMIN Login with Role Verification
  /// Returns false if credentials or role check fails.
  // TODO: [Backend Auth & Role Integration] Replace with Supabase Auth & query profiles table where role == 'admin'
  bool loginAdmin({
    required String email,
    required String password,
  }) {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPass = password.trim();

    if (cleanEmail.isEmpty || cleanPass.isEmpty) {
      return false;
    }

    // Role Verification Check: Must be admin credentials
    final bool isAdminAccount = cleanEmail.contains('admin') || cleanEmail == '3522000000000001';

    if (!isAdminAccount) {
      // Access Denied: User role is not admin
      return false;
    }

    _isGuest = false;
    _isLoggedIn = true;
    _currentUser = UserAccount(
      name: 'Admin Diskominfo Bojonegoro',
      nik: '3522000000000001',
      email: cleanEmail.contains('@') ? cleanEmail : 'admin@bojonegoro.go.id',
      phone: '081133334444',
      role: 'admin',
    );

    notifyListeners();
    return true;
  }

  /// Register new user account
  bool register({
    required String name,
    required String nik,
    required String phone,
    required String email,
    required String password,
  }) {
    if (name.trim().isEmpty || nik.trim().isEmpty || password.trim().isEmpty) {
      return false;
    }

    _isGuest = false;
    _isLoggedIn = true;
    _currentUser = UserAccount(
      name: name.trim(),
      nik: nik.trim(),
      email: email.trim().isEmpty ? '$nik@bojonegoro.go.id' : email.trim(),
      phone: phone.trim().isEmpty ? '081234567890' : phone.trim(),
      role: 'user',
    );
    notifyListeners();
    return true;
  }

  /// Logout User and return to Guest status
  void logout() {
    _isGuest = true;
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}
