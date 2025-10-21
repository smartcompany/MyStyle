import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'widgets/common/share_ui.dart';
import 'constants/api_constants.dart';

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

  /// 카카오 공유 테스트 버튼 위젯
  static Widget buildKakaoShareTestButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () => _testKakaoShareFunction(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow.withOpacity(0.8),
            foregroundColor: Colors.black,
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            '💬 카카오 공유 테스트',
            style: TextStyle(
              color: Colors.black,
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

    // 테스트용 웹 URL 생성
    final testWebUrl = _generateTestShareUrl();

    // 공유 옵션 다이얼로그 표시 (웹 URL 포함)
    ShareUI.showShareOptionsDialog(
      context: context,
      shareText: dummyShareText,
      imagePath: null, // 이미지 없이 텍스트만 테스트
      webUrl: testWebUrl,
    );
  }

  /// 테스트용 웹 URL 생성 함수
  static String _generateTestShareUrl() {
    try {
      // 테스트용 결과 데이터 구성
      final testResultData = {
        'styleAnalysis': {
          'colorEvaluation': '테스트용 색상 평가 - 웜톤에 어울리는 색상입니다',
          'silhouette': '테스트용 실루엣 분석 - A라인 실루엣이 잘 어울립니다',
        },
        'bodyAnalysis': {'height': 'medium', 'bodyType': 'average'},
        'recommendations': [
          {'item': '화이트 블라우스', 'reason': '깔끔한 이미지 연출'},
          {'item': '데님 팬츠', 'reason': '캐주얼한 스타일'},
          {'item': '블레이저', 'reason': '포멀한 자리용'},
          {'item': '로퍼', 'reason': '편안한 신발'},
          {'item': '목걸이', 'reason': '포인트 액세서리'},
        ],
        'language': 'ko',
        'confidence': 92,
      };

      // JSON을 문자열로 변환 후 URL 인코딩
      final jsonString = jsonEncode(testResultData);
      final encodedData = Uri.encodeComponent(jsonString);

      // 고정 URL + 파라미터 조합
      return '${ApiConstants.apiBaseUrl}/share?data=$encodedData';
    } catch (e) {
      print('테스트 URL 생성 중 오류: $e');
      // 에러 시 기본 URL 반환
      return '${ApiConstants.apiBaseUrl}/share';
    }
  }

  /// 카카오 공유 테스트 함수
  static void _testKakaoShareFunction(BuildContext context) {
    // 카카오 공유 전용 테스트 메시지
    final kakaoShareText = '''🎨 MyStyle AI 스타일 분석 결과

✨ 나만의 맞춤형 스타일 분석이 완료되었습니다!

📊 분석 결과:
• 색상 평가: 웜톤에 어울리는 색상
• 실루엣 분석: A라인 실루엣 추천
• 체형: 보통 체형, 중간 키

👔 추천 아이템:
• 화이트 블라우스 - 깔끔한 이미지
• 데님 팬츠 - 캐주얼한 스타일
• 블레이저 - 포멀한 자리용

📱 자세한 분석 결과는 아래 링크에서 확인하세요!''';

    // 테스트용 웹 URL 생성
    final testWebUrl = _generateTestShareUrl();

    // 카카오 공유 다이얼로그 표시 (웹 URL 포함)
    ShareUI.showShareOptionsDialog(
      context: context,
      shareText: kakaoShareText,
      imagePath: null,
      webUrl: testWebUrl,
    );
  }

  /// API 테스트 함수
  static void _testApiFunction(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.apiTest),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.apiTestFeatures),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.serverConnectionCheck),
              Text(AppLocalizations.of(context)!.analysisApiTest),
              Text(AppLocalizations.of(context)!.settingsApiTest),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.featureInDevelopment),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.close),
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
          title: Text(AppLocalizations.of(context)!.adTest),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.adTestFeatures),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.rewardAdLoadTest),
              Text(AppLocalizations.of(context)!.interstitialAdLoadTest),
              Text(AppLocalizations.of(context)!.adDisplayTest),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.featureInDevelopment),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.close),
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
          buildKakaoShareTestButton(context),
          const SizedBox(height: 12),
          buildApiTestButton(context),
          const SizedBox(height: 12),
          buildAdTestButton(context),
        ],
      ),
    );
  }
}
