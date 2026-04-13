import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/quote_store.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuoteStore(),
      child: MaterialApp(
        title: 'Easy Quote',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          splashFactory: NoSplash.splashFactory,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
