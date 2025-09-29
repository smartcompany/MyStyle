import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'l10n/app_localizations.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/photo_upload_screen.dart';
import 'screens/result/result_screen.dart';
import 'services/ad_service.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Firebase Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Initialize API Service
  ApiService().initialize();

  // Initialize AdMob
  await AdService.initialize();

  // Initialize Kakao SDK
  KakaoSdk.init(
    nativeAppKey: 'af92d67a64211ded4d36c978dfcc00da',
    javaScriptAppKey: '72c551e200d94727cafb6a5c8ea218ef',
  );

  runApp(const StyleGuideApp());
}

class StyleGuideApp extends StatelessWidget {
  const StyleGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0), // 시스템 폰트 크기 무시
      ),
      child: MaterialApp(
        title: 'Style Me',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('ko', ''), // Korean
          Locale('zh', ''), // Chinese
          Locale('ja', ''), // Japanese
        ],
        home: const OnboardingLauncher(),
      ),
    );
  }
}

class OnboardingLauncher extends StatelessWidget {
  const OnboardingLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      onFinish: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PhotoUploadScreen()),
        );
      },
    );
  }
}
