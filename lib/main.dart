import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';

void main() {
  runApp(const FlowApp());
}

class FlowApp extends StatelessWidget {
  const FlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow App',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'AE'), // توجيه التطبيق باللغة العربية ومن اليمين لليسار
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E1A), // الخلفية الداكنة جداً للتطبيق
        primaryColor: const Color(0xFF007AFF), // الأزرق النيون الأساسي
        hintColor: const Color(0xFFFF9500), // اللون البرتقالي المضيء للتقييمات والوقت
        textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
