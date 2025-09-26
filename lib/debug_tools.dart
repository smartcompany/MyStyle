import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'widgets/common/share_ui.dart';

/// 디버그 모드에서 사용할 수 있는 도구들을 제공하는 클래스
class DebugTools {
  /// 크래시 테스트 버튼 위젯
  static Widget buildCrashTestButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _testCrash,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0.8),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            '🚨 크래시 테스트',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// 공유 기능 테스트 버튼 위젯
  static Widget buildShareTestButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () => _testShareFunction(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.withOpacity(0.8),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            '📤 공유 기능 테스트',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// API 테스트 버튼 위젯
  static Widget buildApiTestButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () => _testApiFunction(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.withOpacity(0.8),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            '🌐 API 테스트',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// 광고 테스트 버튼 위젯
  static Widget buildAdTestButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () => _testAdFunction(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple.withOpacity(0.8),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            '📺 광고 테스트',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// 테스트용 크래시 발생 함수
  static void _testCrash() {
    print('🚨 테스트 크래시 발생 시도');
    throw Exception('테스트용 크래시입니다!');
  }

  /// 공유 기능 테스트 함수
  static void _testShareFunction(BuildContext context) {
    // 더미 테스트 컨텐츠 생성
    final dummyShareText = '''🎨 MyStyle - 공유 기능 테스트

💡 테스트 분석 결과
이것은 공유 기능을 테스트하기 위한 더미 컨텐츠입니다.

👤 얼굴형 분석
테스트용 얼굴형 분석 결과입니다.

✨ 피부 분석
테스트용 피부 분석 결과입니다.

💇‍♀️ 헤어스타일
테스트용 헤어스타일 추천입니다.

👁️ 눈썹 관리
테스트용 눈썹 관리 팁입니다.

👔 패션 & 액세서리
테스트용 패션 추천입니다.

💪 라이프스타일
테스트용 라이프스타일 조언입니다.

📱 MyStyle 앱으로 더 자세한 분석을 확인해보세요!''';

    // 공유 옵션 다이얼로그 표시
    ShareUI.showShareOptionsDialog(
      context: context,
      shareText: dummyShareText,
      imagePath: null, // 이미지 없이 텍스트만 테스트
    );
  }

  /// API 테스트 함수
  static void _testApiFunction(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🌐 API 테스트'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('API 테스트 기능:'),
              SizedBox(height: 8),
              Text('• 서버 연결 상태 확인'),
              Text('• 분석 API 응답 테스트'),
              Text('• 설정 API 응답 테스트'),
              SizedBox(height: 16),
              Text('이 기능은 개발 중입니다.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  /// 광고 테스트 함수
  static void _testAdFunction(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('📺 광고 테스트'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('광고 테스트 기능:'),
              SizedBox(height: 8),
              Text('• 리워드 광고 로드 테스트'),
              Text('• 인터스티셜 광고 로드 테스트'),
              Text('• 광고 표시 테스트'),
              SizedBox(height: 16),
              Text('이 기능은 개발 중입니다.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  /// 디버그 패널 위젯 (디버그 모드에서만 표시)
  static Widget buildDebugPanel(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🔧 디버그 모드',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          buildCrashTestButton(context),
          const SizedBox(height: 12),
          buildShareTestButton(context),
          const SizedBox(height: 12),
          buildApiTestButton(context),
          const SizedBox(height: 12),
          buildAdTestButton(context),
        ],
      ),
    );
  }
}
