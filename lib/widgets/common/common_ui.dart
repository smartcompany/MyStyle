import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/font_constants.dart';

class CommonUI {
  /// 표준 AppBar 생성
  static PreferredSizeWidget buildStandardAppBar({
    required BuildContext context,
    String? title,
    List<Widget>? actions,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) {
    return AppBar(
      title: Text(
        title ?? AppLocalizations.of(context)!.appTitle,
        style: const TextStyle(
          fontSize: FontConstants.appBarTitle,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF4A90E2),
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton && onBackPressed != null
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: onBackPressed,
            )
          : null,
      actions: actions,
    );
  }

  /// 홈 화면용 AppBar (설정 버튼 포함)
  static PreferredSizeWidget buildCustomAppBar({
    required BuildContext context,
    required String title,
    VoidCallback? onSettingsPressed,
  }) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: FontConstants.appBarTitle,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF4A90E2),
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: onSettingsPressed != null
          ? [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: onSettingsPressed,
                  icon: const Icon(
                    Icons.settings_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ]
          : null,
    );
  }

  /// 설정 버튼 없는 AppBar
  static PreferredSizeWidget buildSimpleAppBar({
    required BuildContext context,
    required String title,
  }) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: FontConstants.appBarTitle,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF4A90E2),
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  /// 설정 화면용 AppBar (백 버튼 없음)
  static PreferredSizeWidget buildSettingsAppBar({
    required BuildContext context,
  }) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)?.settings ?? 'Settings',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: FontConstants.appBarTitle,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF4A90E2),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: true,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  /// 공유 버튼이 포함된 AppBar
  static PreferredSizeWidget buildShareAppBar({
    required BuildContext context,
    required String title,
    required VoidCallback onSharePressed,
    VoidCallback? onBackPressed,
  }) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF4A90E2),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: onBackPressed != null
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: onBackPressed,
            )
          : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: onSharePressed,
        ),
      ],
    );
  }

  /// 카메라/사진 업로드용 AppBar
  static PreferredSizeWidget buildCameraAppBar({
    required BuildContext context,
    required String title,
    VoidCallback? onBackPressed,
  }) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF4A90E2),
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: onBackPressed != null
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: onBackPressed,
            )
          : null,
    );
  }

  /// 표준 설정 버튼 위젯
  static Widget buildSettingsButton({
    required VoidCallback onPressed,
    double size = 20,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.settings_outlined, size: size, color: Colors.white),
      ),
    );
  }

  /// 표준 공유 버튼 위젯
  static Widget buildShareButton({
    required VoidCallback onPressed,
    double size = 20,
  }) {
    return IconButton(
      icon: Icon(Icons.share, color: Colors.white, size: size),
      onPressed: onPressed,
    );
  }

  /// 표준 백 버튼 위젯
  static Widget buildBackButton({
    required VoidCallback onPressed,
    double size = 20,
  }) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: size),
      onPressed: onPressed,
    );
  }
}
