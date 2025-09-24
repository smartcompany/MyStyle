class AppConstants {
  // App Info
  static const String appName = 'Style Guide';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://api.styleguide.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Analysis
  static const Duration analysisDuration = Duration(seconds: 15);
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB

  // UI
  static const double defaultPadding = 16.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Colors
  static const int primaryColorValue = 0xFF6366F1;
  static const int secondaryColorValue = 0xFF8B5CF6;
  static const int accentColorValue = 0xFFF59E0B;
  static const int successColorValue = 0xFF10B981;
  static const int warningColorValue = 0xFFF59E0B;
  static const int errorColorValue = 0xFFEF4444;

  // Gender Options
  static const String male = 'male';
  static const String female = 'female';

  // Face Shape Types
  static const List<String> faceShapes = [
    'round', // 둥근형
    'oval', // 긴형
    'square', // 각진형
    'heart', // 하트형
    'diamond', // 다이아몬드형
  ];

  // Skin Tones
  static const List<String> skinTones = [
    'warm', // 웜톤
    'cool', // 쿨톤
    'neutral', // 뉴트럴톤
  ];

  // Skin Types
  static const List<String> skinTypes = [
    'oily', // 지성
    'dry', // 건성
    'combination', // 복합성
    'sensitive', // 민감성
  ];
}
