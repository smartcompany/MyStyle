/// 사진 분석 요청 모델
class PhotoAnalysisRequest {
  final String imageBase64;
  final String userId;
  final AnalysisType analysisType;
  final Map<String, dynamic>? additionalData;

  PhotoAnalysisRequest({
    required this.imageBase64,
    required this.userId,
    required this.analysisType,
    this.additionalData,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageBase64': imageBase64,
      'userId': userId,
      'analysisType': analysisType.name,
      'additionalData': additionalData,
    };
  }
}

/// 사진 분석 응답 모델
class PhotoAnalysisResponse {
  final String imageUrl;
  final String style;
  final String outfitSummary;
  final List<String> careTips;

  PhotoAnalysisResponse({
    required this.imageUrl,
    required this.style,
    required this.outfitSummary,
    required this.careTips,
  });

  factory PhotoAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return PhotoAnalysisResponse(
      imageUrl: json['image_url'] as String? ?? '',
      style: json['style'] as String? ?? 'casual',
      outfitSummary: json['outfit_summary'] as String? ?? '',
      careTips: List<String>.from(json['care_tips'] ?? []),
    );
  }
}

/// 개인 분석 결과
class PersonAnalysis {
  final BodyType bodyType;
  final SkinTone skinTone;
  final double estimatedHeight;
  final String currentStyle;
  final List<String> detectedColors;
  final double confidenceScore;

  PersonAnalysis({
    required this.bodyType,
    required this.skinTone,
    required this.estimatedHeight,
    required this.currentStyle,
    required this.detectedColors,
    required this.confidenceScore,
  });

  factory PersonAnalysis.fromJson(Map<String, dynamic> json) {
    return PersonAnalysis(
      bodyType: BodyType.values.firstWhere(
        (e) => e.name == json['bodyType'],
        orElse: () => BodyType.average,
      ),
      skinTone: SkinTone.values.firstWhere(
        (e) => e.name == json['skinTone'],
        orElse: () => SkinTone.medium,
      ),
      estimatedHeight: (json['estimatedHeight'] as num).toDouble(),
      currentStyle: json['currentStyle'] as String,
      detectedColors: List<String>.from(json['detectedColors']),
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bodyType': bodyType.name,
      'skinTone': skinTone.name,
      'estimatedHeight': estimatedHeight,
      'currentStyle': currentStyle,
      'detectedColors': detectedColors,
      'confidenceScore': confidenceScore,
    };
  }
}

/// 분석 메타데이터
class AnalysisMetadata {
  final DateTime timestamp;
  final String aiModel;
  final double processingTime;
  final String version;

  AnalysisMetadata({
    required this.timestamp,
    required this.aiModel,
    required this.processingTime,
    required this.version,
  });

  factory AnalysisMetadata.fromJson(Map<String, dynamic> json) {
    return AnalysisMetadata(
      timestamp: DateTime.parse(json['timestamp']),
      aiModel: json['aiModel'] as String,
      processingTime: (json['processingTime'] as num).toDouble(),
      version: json['version'] as String,
    );
  }
}

/// 분석 타입
enum AnalysisType {
  styleRecommendation, // 스타일 추천
  bodyAnalysis, // 체형 분석
  colorAnalysis, // 색상 분석
  fullAnalysis, // 전체 분석
}

/// 체형 타입
enum BodyType {
  slim, // 슬림
  average, // 보통
  athletic, // 운동체형
  curvy, // 곡선형
  plus, // 플러스 사이즈
}

/// 피부톤
enum SkinTone {
  cool, // 쿨톤
  warm, // 웜톤
  neutral, // 중성톤
  light, // 밝은 톤
  medium, // 중간 톤
  dark, // 어두운 톤
}

/// 체형별 한국어 이름
extension BodyTypeExtension on BodyType {
  String get displayName {
    switch (this) {
      case BodyType.slim:
        return '슬림';
      case BodyType.average:
        return '보통';
      case BodyType.athletic:
        return '운동체형';
      case BodyType.curvy:
        return '곡선형';
      case BodyType.plus:
        return '플러스 사이즈';
    }
  }
}

/// 피부톤별 한국어 이름
extension SkinToneExtension on SkinTone {
  String get displayName {
    switch (this) {
      case SkinTone.cool:
        return '쿨톤';
      case SkinTone.warm:
        return '웜톤';
      case SkinTone.neutral:
        return '중성톤';
      case SkinTone.light:
        return '밝은 톤';
      case SkinTone.medium:
        return '중간 톤';
      case SkinTone.dark:
        return '어두운 톤';
    }
  }
}
