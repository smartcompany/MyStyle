import '../models/style_recommendation.dart';
import '../models/weather.dart';
import '../models/user_preferences.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class StyleService {
  StyleService();

  Future<List<StyleRecommendation>> getStyleRecommendations({
    required Weather weather,
    required UserPreferences preferences,
    required BuildContext context,
  }) async {
    // JSON 파일에서 스타일 추천 데이터 로드
    final recommendation = await _getLocalStyleRecommendations(
      weather,
      preferences,
      context,
    );
    return recommendation != null ? [recommendation] : [];
  }

  Future<List<ActivityRecommendation>> getActivityRecommendations({
    required Weather weather,
    required UserPreferences preferences,
  }) async {
    // TODO: 서버 API 호출로 대체 예정
    // 현재는 빈 리스트 반환
    return [];
  }

  Future<StyleRecommendation?> _getLocalStyleRecommendations(
    Weather weather,
    UserPreferences preferences,
    BuildContext context,
  ) async {
    try {
      // 현재 언어 설정에 따라 적절한 JSON 파일 로드
      final currentLocale = Localizations.localeOf(context);
      final languageCode = currentLocale.languageCode;

      // 언어별 JSON 파일 경로 결정
      String jsonFileName;
      switch (languageCode) {
        case 'ko':
          jsonFileName = 'assets/data/style_recommendations_ko.json';
          break;
        case 'ja':
          jsonFileName = 'assets/data/style_recommendations_ja.json';
          break;
        case 'zh':
          jsonFileName = 'assets/data/style_recommendations_zh.json';
          break;
        case 'en':
        default:
          jsonFileName = 'assets/data/style_recommendations_en.json';
          break;
      }

      // JSON 파일 로드
      final String jsonString = await rootBundle.loadString(jsonFileName);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> recommendations = jsonData['recommendations'];

      // 날씨와 온도 조건에 맞는 추천 찾기
      for (var rec in recommendations) {
        final conditions = rec['conditions'];
        final tempRange = conditions['temperature'];
        final weatherTypes = List<String>.from(conditions['weather']);

        // 온도 조건 확인
        final bool tempMatch =
            weather.temperature >= tempRange['min'] &&
            weather.temperature <= tempRange['max'];

        // 날씨 조건 확인 (main 필드와 매칭)
        final bool weatherMatch = weatherTypes.any(
          (type) =>
              weather.main.toLowerCase().contains(type.toLowerCase()) ||
              type.toLowerCase().contains(weather.main.toLowerCase()),
        );

        if (tempMatch && weatherMatch) {
          return StyleRecommendation(
            id: rec['id'],
            title: rec['title'],
            description: rec['description'],
            clothingItems: List<String>.from(rec['clothingItems']),
            colors: List<String>.from(rec['colors']),
            category: _parseStyleCategory(rec['category']),
            weatherType: _parseWeatherType(rec['weatherType']),
            temperature: rec['temperature'].toDouble(),
            imageUrl: '', // 이미지는 별도 처리
            confidence: rec['confidence'],
          );
        }
      }

      // 매칭되는 조건이 없으면 기본 추천 반환
      return _getDefaultRecommendation(weather, context);
    } catch (e) {
      print('스타일 추천 로드 오류: $e');
      return _getDefaultRecommendation(weather, context);
    }
  }

  StyleRecommendation _getDefaultRecommendation(
    Weather weather,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;

    // 기본 추천 (온도 기반)
    if (weather.temperature >= 25) {
      return StyleRecommendation(
        id: 'default_hot',
        title: l10n.coolLook,
        description: l10n.lightClothingRecommendation,
        clothingItems: [l10n.shortSleeve, l10n.shorts, l10n.sandals],
        colors: [l10n.white, l10n.lightColors],
        category: StyleCategory.casual,
        weatherType: WeatherType.sunny,
        temperature: weather.temperature,
        imageUrl: '',
        confidence: 70,
      );
    } else if (weather.temperature >= 15) {
      return StyleRecommendation(
        id: 'default_mild',
        title: l10n.moderateLook,
        description: l10n.moderateWarmClothingRecommendation,
        clothingItems: [l10n.longSleeve, l10n.longPants, l10n.sneakers],
        colors: [l10n.beige, l10n.gray],
        category: StyleCategory.casual,
        weatherType: WeatherType.cloudy,
        temperature: weather.temperature,
        imageUrl: '',
        confidence: 70,
      );
    } else {
      return StyleRecommendation(
        id: 'default_cold',
        title: l10n.warmLook,
        description: l10n.warmClothingRecommendation,
        clothingItems: [l10n.padding, l10n.coat, l10n.scarf],
        colors: [l10n.black, l10n.darkTones],
        category: StyleCategory.casual,
        weatherType: WeatherType.cloudy,
        temperature: weather.temperature,
        imageUrl: '',
        confidence: 70,
      );
    }
  }

  StyleCategory _parseStyleCategory(String category) {
    switch (category.toLowerCase()) {
      case 'casual':
        return StyleCategory.casual;
      case 'formal':
        return StyleCategory.formal;
      case 'sporty':
        return StyleCategory.sporty;
      default:
        return StyleCategory.casual;
    }
  }

  WeatherType _parseWeatherType(String weatherType) {
    switch (weatherType.toLowerCase()) {
      case 'sunny':
        return WeatherType.sunny;
      case 'cloudy':
        return WeatherType.cloudy;
      case 'rainy':
        return WeatherType.rainy;
      case 'snowy':
        return WeatherType.snowy;
      default:
        return WeatherType.cloudy;
    }
  }
}
