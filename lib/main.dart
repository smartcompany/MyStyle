import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/photo_upload_screen.dart';
import 'screens/result/result_screen.dart';
import 'services/ad_service.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API Service
  ApiService().initialize(baseUrl: 'http://localhost:3000');

  // Initialize AdMob
  await AdService.initialize();

  runApp(const StyleGuideApp());
}

class StyleGuideApp extends StatelessWidget {
  const StyleGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Style Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
      routes: {'/result': (context) => const ResultScreen()},
    );
  }
}
