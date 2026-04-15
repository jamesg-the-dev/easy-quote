import 'package:easy_quote/core/app/app_wrapper.dart';
import 'package:easy_quote/screens/signup/email_signup_step1.dart';
import 'package:easy_quote/screens/signup/signup_step2.dart';
import 'package:easy_quote/screens/signup/signup_step3.dart';
import 'package:easy_quote/screens/signup/signup_success_screen.dart';
import 'package:easy_quote/screens/signup/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/auth_store.dart';
import 'services/quote_store.dart';
import 'services/signup_store.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'core/config/env.dart';
import 'core/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
  } catch (e) {}

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(create: (_) => QuoteStore()),
        ChangeNotifierProvider(create: (_) => SignupStore()),
      ],
      child: MaterialApp(
        title: 'Easy Quote',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          splashFactory: NoSplash.splashFactory,
        ),

        // 👇 WRAP HERE
        home: AppWrapper(child: const AuthGate()),

        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupWelcomeScreen(),
          '/signup/email': (context) => const EmailSignupStep1(),
          '/signup/details': (context) => const SignupStep2(),
          '/signup/business': (context) => const SignupStep3(),
          '/signup/success': (context) => const SignupSuccessScreen(),
        },
      ),
    );
  }
}
