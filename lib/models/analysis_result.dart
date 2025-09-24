class AnalysisResult {
  final String id;
  final DateTime createdAt;
  final String gender;
  final String? imagePath;

  // Basic Face Analysis
  final FaceAnalysis faceAnalysis;

  // Skin & Health
  final SkinAnalysis skinAnalysis;

  // Hair & Jawline
  final HairAnalysis hairAnalysis;

  // Eyebrows & Details
  final EyebrowAnalysis eyebrowAnalysis;

  // Fashion & Accessories
  final FashionAnalysis fashionAnalysis;

  // Lifestyle Advice
  final LifestyleAdvice lifestyleAdvice;

  // Overall Score
  final int overallScore;
  final String overallComment;

  AnalysisResult({
    required this.id,
    required this.createdAt,
    required this.gender,
    this.imagePath,
    required this.faceAnalysis,
    required this.skinAnalysis,
    required this.hairAnalysis,
    required this.eyebrowAnalysis,
    required this.fashionAnalysis,
    required this.lifestyleAdvice,
    required this.overallScore,
    required this.overallComment,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      id: json['id'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      gender: json['gender'] ?? '',
      imagePath: json['imagePath'],
      faceAnalysis: FaceAnalysis.fromJson(json['faceAnalysis'] ?? {}),
      skinAnalysis: SkinAnalysis.fromJson(json['skinAnalysis'] ?? {}),
      hairAnalysis: HairAnalysis.fromJson(json['hairAnalysis'] ?? {}),
      eyebrowAnalysis: EyebrowAnalysis.fromJson(json['eyebrowAnalysis'] ?? {}),
      fashionAnalysis: FashionAnalysis.fromJson(json['fashionAnalysis'] ?? {}),
      lifestyleAdvice: LifestyleAdvice.fromJson(json['lifestyleAdvice'] ?? {}),
      overallScore: json['overallScore'] ?? 0,
      overallComment: json['overallComment'] ?? '',
    );
  }
}

class FaceAnalysis {
  final String faceShape;
  final int balanceScore;
  final String balanceComment;
  final List<String> strengths;
  final List<String> improvements;

  FaceAnalysis({
    required this.faceShape,
    required this.balanceScore,
    required this.balanceComment,
    required this.strengths,
    required this.improvements,
  });

  factory FaceAnalysis.fromJson(Map<String, dynamic> json) {
    return FaceAnalysis(
      faceShape: json['faceShape'] ?? '',
      balanceScore: json['balanceScore'] ?? 0,
      balanceComment: json['balanceComment'] ?? '',
      strengths: List<String>.from(json['strengths'] ?? []),
      improvements: List<String>.from(json['improvements'] ?? []),
    );
  }
}

class SkinAnalysis {
  final String skinTone;
  final String skinType;
  final int skinScore;
  final String skinComment;
  final List<String> skinIssues;
  final List<String> careRoutine;
  final List<String> productRecommendations;

  SkinAnalysis({
    required this.skinTone,
    required this.skinType,
    required this.skinScore,
    required this.skinComment,
    required this.skinIssues,
    required this.careRoutine,
    required this.productRecommendations,
  });

  factory SkinAnalysis.fromJson(Map<String, dynamic> json) {
    return SkinAnalysis(
      skinTone: json['skinTone'] ?? '',
      skinType: json['skinType'] ?? '',
      skinScore: json['skinScore'] ?? 0,
      skinComment: json['skinComment'] ?? '',
      skinIssues: List<String>.from(json['skinIssues'] ?? []),
      careRoutine: List<String>.from(json['careRoutine'] ?? []),
      productRecommendations: List<String>.from(
        json['productRecommendations'] ?? [],
      ),
    );
  }
}

class HairAnalysis {
  final List<String> recommendedStyles;
  final String hairComment;
  final List<String> stylingTips;
  final String beardAdvice; // For male users
  final int hairScore;

  HairAnalysis({
    required this.recommendedStyles,
    required this.hairComment,
    required this.stylingTips,
    required this.beardAdvice,
    required this.hairScore,
  });

  factory HairAnalysis.fromJson(Map<String, dynamic> json) {
    return HairAnalysis(
      recommendedStyles: List<String>.from(json['recommendedStyles'] ?? []),
      hairComment: json['hairComment'] ?? '',
      stylingTips: List<String>.from(json['stylingTips'] ?? []),
      beardAdvice: json['beardAdvice'] ?? '',
      hairScore: json['hairScore'] ?? 0,
    );
  }
}

class EyebrowAnalysis {
  final String eyebrowShape;
  final int eyebrowScore;
  final String eyebrowComment;
  final List<String> maintenanceTips;
  final List<String> stylingRecommendations;

  EyebrowAnalysis({
    required this.eyebrowShape,
    required this.eyebrowScore,
    required this.eyebrowComment,
    required this.maintenanceTips,
    required this.stylingRecommendations,
  });

  factory EyebrowAnalysis.fromJson(Map<String, dynamic> json) {
    return EyebrowAnalysis(
      eyebrowShape: json['eyebrowShape'] ?? '',
      eyebrowScore: json['eyebrowScore'] ?? 0,
      eyebrowComment: json['eyebrowComment'] ?? '',
      maintenanceTips: List<String>.from(json['maintenanceTips'] ?? []),
      stylingRecommendations: List<String>.from(
        json['stylingRecommendations'] ?? [],
      ),
    );
  }
}

class FashionAnalysis {
  final List<String> recommendedColors;
  final List<String> glassesRecommendations;
  final List<String> accessoryRecommendations;
  final String fashionComment;
  final int fashionScore;

  FashionAnalysis({
    required this.recommendedColors,
    required this.glassesRecommendations,
    required this.accessoryRecommendations,
    required this.fashionComment,
    required this.fashionScore,
  });

  factory FashionAnalysis.fromJson(Map<String, dynamic> json) {
    return FashionAnalysis(
      recommendedColors: List<String>.from(json['recommendedColors'] ?? []),
      glassesRecommendations: List<String>.from(
        json['glassesRecommendations'] ?? [],
      ),
      accessoryRecommendations: List<String>.from(
        json['accessoryRecommendations'] ?? [],
      ),
      fashionComment: json['fashionComment'] ?? '',
      fashionScore: json['fashionScore'] ?? 0,
    );
  }
}

class LifestyleAdvice {
  final String sleepAdvice;
  final String dietAdvice;
  final String exerciseAdvice;
  final String generalAdvice;
  final int lifestyleScore;

  LifestyleAdvice({
    required this.sleepAdvice,
    required this.dietAdvice,
    required this.exerciseAdvice,
    required this.generalAdvice,
    required this.lifestyleScore,
  });

  factory LifestyleAdvice.fromJson(Map<String, dynamic> json) {
    return LifestyleAdvice(
      sleepAdvice: json['sleepAdvice'] ?? '',
      dietAdvice: json['dietAdvice'] ?? '',
      exerciseAdvice: json['exerciseAdvice'] ?? '',
      generalAdvice: json['generalAdvice'] ?? '',
      lifestyleScore: json['lifestyleScore'] ?? 0,
    );
  }
}
