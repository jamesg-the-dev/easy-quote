import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  // ---------- Supabase ----------
  static String get supabaseUrl {
    return _get('SUPABASE_URL');
  }

  static String get supabaseAnonKey {
    return _get('SUPABASE_ANON_KEY');
  }

  // ---------- Core resolver ----------
  static String _get(String key) {
    // 1. Try compile-time (Codemagic / production builds)
    const fromCompileTime = String.fromEnvironment('');

    // We can't dynamically pass key into const, so we use a map instead
    final compileTime = _compileTimeEnv[key];

    if (compileTime != null && compileTime.isNotEmpty) {
      return compileTime;
    }

    // 2. Fallback to dotenv (local dev)
    return dotenv.env[key] ?? '';
  }

  // ---------- Compile-time env map ----------
  // This is populated via --dart-define
  static const Map<String, String> _compileTimeEnv = {
    'SUPABASE_URL': String.fromEnvironment('SUPABASE_URL'),
    'SUPABASE_ANON_KEY': String.fromEnvironment('SUPABASE_ANON_KEY'),
  };
}
