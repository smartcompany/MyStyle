import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

/// 공유 관련 UI 컴포넌트들을 제공하는 클래스
class ShareUI {
  /// 앱 아이콘 경로를 가져오는 함수
  static Future<String> _getAppIconPath() async {
    try {
      // 방법 1: PackageInfo를 사용하여 앱 아이콘 경로 가져오기
      final packageInfo = await PackageInfo.fromPlatform();
      print('🔍 [앱 아이콘] 패키지명: ${packageInfo.packageName}');

      // 방법 2: assets 폴더의 앱 아이콘 사용
      final assetIconPath = 'assets/icon/app_icon.png';

      // 방법 3: 플랫폼별 기본 아이콘 경로
      String platformIconPath;
      if (Platform.isAndroid) {
        platformIconPath =
            '/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png';
      } else {
        platformIconPath = assetIconPath;
      }

      print('🔍 [앱 아이콘] 플랫폼별 경로: $platformIconPath');
      print('🔍 [앱 아이콘] assets 경로: $assetIconPath');

      // assets 경로를 우선 사용 (가장 안정적)
      return assetIconPath;
    } catch (e) {
      print('❌ [앱 아이콘] 경로 가져오기 실패: $e');
      // 기본값 반환
      return 'assets/icon/app_icon.png';
    }
  }

  /// 공통 공유 컴포넌트
  static Widget buildShareSection({
    required BuildContext context,
    required String title,
    required String description,
    required String shareText,
    String? imagePath,
    required VoidCallback onShareTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목과 아이콘
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.purple.shade400],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.save_alt_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 설명 텍스트
          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // 저장 & 공유하기 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onShareTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade500,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 2,
                shadowColor: Colors.blue.withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '저장 & 공유하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 공유 옵션 선택 다이얼로그
  static Future<void> showShareOptionsDialog({
    required BuildContext context,
    required String shareText,
    String? imagePath,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade500, Colors.purple.shade500],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 제목
                Text(
                  '공유하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // 공유 옵션들
                _buildShareOption(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: '카카오톡',
                  subtitle: '친구들과 공유하기',
                  onTap: () => _shareToKakao(context, shareText),
                ),

                _buildShareOption(
                  context,
                  icon: Icons.copy_outlined,
                  title: '텍스트 복사',
                  subtitle: '클립보드에 복사',
                  onTap: () => _copyToClipboard(context, shareText),
                ),

                _buildShareOption(
                  context,
                  icon: Icons.save_outlined,
                  title: '파일로 저장',
                  subtitle: '파일 앱에 저장',
                  onTap: () => saveToFile(
                    shareText,
                    fileName: 'style_analysis_result.txt',
                  ),
                ),

                _buildShareOption(
                  context,
                  icon: Icons.share_outlined,
                  title: '기타 공유',
                  subtitle: '기본 공유 기능',
                  onTap: () => _shareWithDefault(context, shareText, imagePath),
                ),

                const SizedBox(height: 16),

                // 취소 버튼
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    '취소',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 공유 옵션 아이템 위젯
  static Widget _buildShareOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          print('🔍 [공유 옵션] $title 버튼 클릭됨');
          Navigator.of(context).pop();
          print('🔍 [공유 옵션] 다이얼로그 닫기 완료, onTap 실행');
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 카카오톡 공유 (SDK 사용)
  static Future<bool> _shareToKakao(
    BuildContext context,
    String shareText,
  ) async {
    print('🔍 [카카오톡 공유] SDK 방식 시작: $shareText');

    // 카카오톡 설치 여부 확인
    if (await ShareClient.instance.isKakaoTalkSharingAvailable() == false) {
      print('🔍 [카카오톡 공유] 카카오톡 미설치');
      return false;
    }

    try {
      // SDK 방식으로 카카오톡에 바로 공유
      print('🔍 [카카오톡 공유] SDK 방식 사용');

      final template = TextTemplate(
        text: shareText,
        link: Link(), // 빈 링크로 앱 이동 방지
      );

      final uri = await ShareClient.instance.shareDefault(template: template);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('카카오톡으로 공유되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
      return true;
    } catch (sdkError) {
      print('🔍 [카카오톡 공유] SDK 공유 실패: $sdkError');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('공유 중 오류가 발생했습니다: ${sdkError.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  /// 클립보드에 복사
  static Future<void> _copyToClipboard(
    BuildContext context,
    String shareText,
  ) async {
    try {
      await Clipboard.setData(ClipboardData(text: shareText));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('클립보드에 복사되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('복사 중 오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 기본 공유 (기타 공유)
  static Future<void> _shareWithDefault(
    BuildContext context,
    String shareText,
    String? imagePath,
  ) async {
    try {
      if (imagePath != null && File(imagePath).existsSync()) {
        // 이미지와 함께 공유
        await Share.shareXFiles(
          [XFile(imagePath)],
          text: shareText,
          subject: 'MyStyle 분석 결과',
        );
      } else {
        // 텍스트만 공유
        await Share.share(shareText, subject: 'MyStyle 분석 결과');
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('공유가 완료되었습니다'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('공유 중 오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 파일로 저장 (public 메서드)
  static Future<void> saveToFile(
    String data, {
    String fileName = "result.txt",
  }) async {
    try {
      // 1) 임시 디렉토리에 파일 생성
      final tmpDir = await getTemporaryDirectory();
      final filePath = '${tmpDir.path}/$fileName';
      final file = File(filePath);

      // 2) 문자열 내용을 파일에 저장
      await file.writeAsString(data);

      // 3) 파일 앱(문서 피커) 열기
      final params = SaveFileDialogParams(
        sourceFilePath: filePath,
        fileName: fileName,
      );

      final savedPath = await FlutterFileDialog.saveFile(params: params);

      if (savedPath != null) {
        print("✅ 저장 완료: $savedPath");
      } else {
        print("⚠️ 사용자가 취소했음");
      }
    } catch (e) {
      print("❌ 저장 중 오류: $e");
    }
  }
}
