import '../models/style_recommendation.dart';
import '../models/weather.dart';
import '../models/user_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class StyleService {
  StyleService();

  Future<List<StyleRecommendation>> getStyleRecommendations({
    required Weather weather,
    required UserPreferences preferences,
  }) async {
    // JSON 파일에서 스타일 추천 데이터 로드
    final recommendation = await _getLocalStyleRecommendations(
      weather,
      preferences,
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
  ) async {
    try {
      // JSON 파일 로드
      final String jsonString = await rootBundle.loadString(
        'assets/data/style_recommendations.json',
      );
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
      return _getDefaultRecommendation(weather);
    } catch (e) {
      print('스타일 추천 로드 오류: $e');
      return _getDefaultRecommendation(weather);
    }
  }

  StyleRecommendation _getDefaultRecommendation(Weather weather) {
    // 기본 추천 (온도 기반)
    if (weather.temperature >= 25) {
      return StyleRecommendation(
        id: 'default_hot',
        title: '시원한 룩',
        description: '가벼운 옷을 추천해요',
        clothingItems: ['반팔', '반바지', '샌들'],
        colors: ['흰색', '연한 색상'],
        category: StyleCategory.casual,
        weatherType: WeatherType.sunny,
        temperature: weather.temperature,
        imageUrl: '',
        confidence: 70,
      );
    } else if (weather.temperature >= 15) {
      return StyleRecommendation(
        id: 'default_mild',
        title: '적당한 룩',
        description: '적당히 따뜻한 옷을 추천해요',
        clothingItems: ['긴팔', '긴바지', '스니커즈'],
        colors: ['베이지', '회색'],
        category: StyleCategory.casual,
        weatherType: WeatherType.cloudy,
        temperature: weather.temperature,
        imageUrl: '',
        confidence: 70,
      );
    } else {
      return StyleRecommendation(
        id: 'default_cold',
        title: '따뜻한 룩',
        description: '따뜻한 옷을 추천해요',
        clothingItems: ['패딩', '코트', '목도리'],
        colors: ['검은색', '어두운 톤'],
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
