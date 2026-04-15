import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_quote/services/auth_store.dart';
import 'package:easy_quote/screens/home_screen.dart';
import 'package:easy_quote/screens/login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late StreamSubscription _authSub;

  @override
  void initState() {
    super.initState();
    // Initialize persistent session on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authStore = context.read<AuthStore>();
      authStore.initialize();

      // Listen for auth state changes after initialization
      _authSub = authStore.onAuthStateChange.listen((state) {
        if (!mounted) return;
        // Rebuild to reflect auth state changes
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AuthStore, (bool isLoggedIn, bool isInitialized)>(
      selector: (_, authStore) =>
          (authStore.isLoggedIn, authStore.isInitialized),
      builder: (context, state, _) {
        final (isLoggedIn, isInitialized) = state;

        // Show splash while initializing
        if (!isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Route based on auth state - this is the gatekeeper
        return isLoggedIn ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}
