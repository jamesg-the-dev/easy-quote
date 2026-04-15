import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStore extends ChangeNotifier {
  final _client = Supabase.instance.client;
  bool _isLoggedIn = false;
  String? _userEmail;
  String? _userId;
  bool _isInitialized = false;

  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  bool get isInitialized => _isInitialized;

  Session? get currentSession => _client.auth.currentSession;

  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  /// Initialize auth state from persistent session and listen for changes
  Future<void> initialize() async {
    try {
      // Restore session from device storage (handled by Supabase automatically)
      final session = currentSession;

      if (session != null) {
        _isLoggedIn = true;
        _userEmail = session.user.email;
        _userId = session.user.id;
      } else {
        _isLoggedIn = false;
        _userEmail = null;
        _userId = null;
      }
    } catch (e) {
      debugPrint('Error initializing auth: $e');
      _isLoggedIn = false;
    }

    _isInitialized = true;
    notifyListeners();

    // Listen for auth state changes (login, logout, session refresh)
    _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;

      if (session != null) {
        _isLoggedIn = true;
        _userEmail = session.user.email;
        _userId = session.user.id;
      } else {
        _isLoggedIn = false;
        _userEmail = null;
        _userId = null;
      }

      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    _isLoggedIn = false;
    _userEmail = null;
    _userId = null;
    notifyListeners();
  }

  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: 'test',
      );

      _isLoggedIn = true;
      _userEmail = response.user?.email;
      _userId = response.user?.id;

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      // TODO: Implement actual Google authentication
      await Future.delayed(const Duration(milliseconds: 500));

      _isLoggedIn = true;
      _userEmail = 'google_user@example.com';
      _userId = 'google_${DateTime.now().millisecondsSinceEpoch}';

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    try {
      // TODO: Implement actual Apple authentication
      await Future.delayed(const Duration(milliseconds: 500));

      _isLoggedIn = true;
      _userEmail = 'apple_user@example.com';
      _userId = 'apple_${DateTime.now().millisecondsSinceEpoch}';

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign in with Apple: $e');
    }
  }
}
