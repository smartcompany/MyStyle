import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/photo/photo_upload_screen.dart';
import '../screens/analysis/analysis_screen.dart';
import '../screens/result/result_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // Onboarding Flow
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main Flow
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const PhotoUploadScreen(),
      ),
      GoRoute(
        path: AppRoutes.photoUpload,
        builder: (context, state) => const PhotoUploadScreen(),
      ),
      GoRoute(
        path: AppRoutes.analysis,
        builder: (context, state) => const AnalysisScreen(),
      ),
      GoRoute(
        path: AppRoutes.result,
        builder: (context, state) => const ResultScreen(),
      ),

      // Result Details (Placeholder routes for now)
      GoRoute(
        path: AppRoutes.faceAnalysis,
        builder: (context, state) => _buildPlaceholderScreen('얼굴형 분석 상세'),
      ),
      GoRoute(
        path: AppRoutes.skinAnalysis,
        builder: (context, state) => _buildPlaceholderScreen('피부 분석 상세'),
      ),
      GoRoute(
        path: AppRoutes.hairAnalysis,
        builder: (context, state) => _buildPlaceholderScreen('헤어스타일 분석 상세'),
      ),
      GoRoute(
        path: AppRoutes.eyebrowAnalysis,
        builder: (context, state) => _buildPlaceholderScreen('눈썹 분석 상세'),
      ),
      GoRoute(
        path: AppRoutes.fashionAnalysis,
        builder: (context, state) => _buildPlaceholderScreen('패션 분석 상세'),
      ),
      GoRoute(
        path: AppRoutes.lifestyleAnalysis,
        builder: (context, state) => _buildPlaceholderScreen('라이프스타일 분석 상세'),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              '페이지를 찾을 수 없습니다',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '요청하신 페이지가 존재하지 않습니다.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    ),
  );

  static GoRouter get router => _router;

  static Widget _buildPlaceholderScreen(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '상세 페이지는 곧 추가될 예정입니다.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
