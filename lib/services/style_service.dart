import '../models/style_recommendation.dart';
import '../models/weather.dart';
import '../models/user_preferences.dart';

class StyleService {
  StyleService();

  Future<List<StyleRecommendation>> getStyleRecommendations({
    required Weather weather,
    required UserPreferences preferences,
  }) async {
    // 로컬 추천 로직만 사용
    return _getLocalStyleRecommendations(weather, preferences);
  }

  Future<List<ActivityRecommendation>> getActivityRecommendations({
    required Weather weather,
    required UserPreferences preferences,
  }) async {
    // 로컬 추천 로직만 사용
    return _getLocalActivityRecommendations(weather, preferences);
  }

  List<StyleRecommendation> _getLocalStyleRecommendations(
    Weather weather,
    UserPreferences preferences,
  ) {
    List<StyleRecommendation> recommendations = [];

    // 온도 기반 기본 추천
    if (weather.temperature >= 30) {
      recommendations.addAll(_getHotWeatherRecommendations(preferences));
    } else if (weather.temperature >= 20) {
      recommendations.addAll(_getWarmWeatherRecommendations(preferences));
    } else if (weather.temperature >= 10) {
      recommendations.addAll(_getCoolWeatherRecommendations(preferences));
    } else if (weather.temperature >= 0) {
      recommendations.addAll(_getColdWeatherRecommendations(preferences));
    } else {
      recommendations.addAll(_getVeryColdWeatherRecommendations(preferences));
    }

    // 날씨 상태별 추가 추천
    switch (weather.main.toLowerCase()) {
      case 'rain':
        recommendations.addAll(_getRainyWeatherRecommendations(preferences));
        break;
      case 'snow':
        recommendations.addAll(_getSnowyWeatherRecommendations(preferences));
        break;
      case 'clouds':
        recommendations.addAll(_getCloudyWeatherRecommendations(preferences));
        break;
    }

    return recommendations;
  }

  List<StyleRecommendation> _getHotWeatherRecommendations(
    UserPreferences preferences,
  ) {
    return [
      StyleRecommendation(
        id: 'hot_1',
        title: '시원한 여름 룩',
        description: '가벼운 소재의 민소매나 반팔을 추천해요',
        clothingItems: ['민소매', '반팔', '반바지', '치마', '샌들'],
        colors: ['흰색', '파란색', '연한 색상'],
        category: StyleCategory.casual,
        weatherType: WeatherType.sunny,
        temperature: 30.0,
        imageUrl: '',
        confidence: 85,
      ),
    ];
  }

  List<StyleRecommendation> _getWarmWeatherRecommendations(
    UserPreferences preferences,
  ) {
    return [
      StyleRecommendation(
        id: 'warm_1',
        title: '편안한 봄/가을 룩',
        description: '가벼운 긴팔이나 얇은 외투를 추천해요',
        clothingItems: ['긴팔', '반바지', '가벼운 외투', '스니커즈'],
        colors: ['베이지', '회색', '파스텔 톤'],
        category: StyleCategory.casual,
        weatherType: WeatherType.sunny,
        temperature: 25.0,
        imageUrl: '',
        confidence: 80,
      ),
    ];
  }

  List<StyleRecommendation> _getCoolWeatherRecommendations(
    UserPreferences preferences,
  ) {
    return [
      StyleRecommendation(
        id: 'cool_1',
        title: '따뜻한 가을 룩',
        description: '점퍼나 가디건을 추가해보세요',
        clothingItems: ['긴팔', '긴바지', '점퍼', '가디건', '부츠'],
        colors: ['갈색', '오렌지', '따뜻한 톤'],
        category: StyleCategory.casual,
        weatherType: WeatherType.cloudy,
        temperature: 15.0,
        imageUrl: '',
        confidence: 85,
      ),
    ];
  }

  List<StyleRecommendation> _getColdWeatherRecommendations(
    UserPreferences preferences,
  ) {
    return [
      StyleRecommendation(
        id: 'cold_1',
        title: '따뜻한 겨울 룩',
        description: '패딩이나 코트를 추천해요',
        clothingItems: ['패딩', '코트', '긴바지', '목도리', '장갑'],
        colors: ['검은색', '네이비', '어두운 톤'],
        category: StyleCategory.casual,
        weatherType: WeatherType.cloudy,
        temperature: 5.0,
        imageUrl: '',
        confidence: 90,
      ),
    ];
  }

  List<StyleRecommendation> _getVeryColdWeatherRecommendations(
    UserPreferences preferences,
  ) {
    return [
      StyleRecommendation(
        id: 'very_cold_1',
        title: '매우 따뜻한 겨울 룩',
        description: '두꺼운 패딩과 겨울 액세서리가 필요해요',
        clothingItems: ['두꺼운 패딩', '털부츠', '목도리', '장갑', '모자'],
        colors: ['검은색', '다크 그레이', '따뜻한 톤'],
        category: StyleCategory.casual,
        weatherType: WeatherType.snowy,
        temperature: -5.0,
        imageUrl: '',
        confidence: 95,
      ),
    ];
  }

  List<StyleRecommendation> _getRainyWeatherRecommendations(
    UserPreferences preferences,
  ) {
    return [
      StyleRecommendation(
        id: 'rainy_1',
        title: '비 오는 날 룩',
        description: '우비나 방수 재킷을 준비하세요',
        clothingItems: ['우비', '방수 재킷', '긴바지', '부츠', '우산'],
        colors: ['노란색', '투명', '밝은 색상'],
        category: StyleCategory.casual,
        weatherType: WeatherType.rainy,
        temperature: 15.0,
        imageUrl: '',
        confidence: 90,
      ),
    ];
  }

  List<StyleRecommendation> _getSnowyWeatherRecommendations(
    UserPreferences preferences,
  ) {
    return [
      StyleRecommendation(
        id: 'snowy_1',
        title: '눈 오는 날 룩',
        description: '미끄럼 방지 신발과 따뜻한 옷을 추천해요',
        clothingItems: ['패딩', '스노우부츠', '목도리', '장갑', '모자'],
        colors: ['흰색', '파란색', '따뜻한 톤'],
        category: StyleCategory.sporty,
        weatherType: WeatherType.snowy,
        temperature: 0.0,
        imageUrl: '',
        confidence: 95,
      ),
    ];
  }

  List<StyleRecommendation> _getCloudyWeatherRecommendations(
    UserPreferences preferences,
  ) {
    return [
      StyleRecommendation(
        id: 'cloudy_1',
        title: '흐린 날 룩',
        description: '레이어링으로 대비를 주어보세요',
        clothingItems: ['긴팔', '가디건', '긴바지', '스니커즈'],
        colors: ['회색', '베이지', '중성 톤'],
        category: StyleCategory.casual,
        weatherType: WeatherType.cloudy,
        temperature: 20.0,
        imageUrl: '',
        confidence: 75,
      ),
    ];
  }

  List<ActivityRecommendation> _getLocalActivityRecommendations(
    Weather weather,
    UserPreferences preferences,
  ) {
    List<ActivityRecommendation> recommendations = [];

    if (weather.temperature >= 20 && weather.main.toLowerCase() == 'clear') {
      recommendations.add(
        ActivityRecommendation(
          id: 'outdoor_1',
          title: '야외 활동',
          description: '맑은 날씨에 산책이나 피크닉을 즐겨보세요',
          weatherType: WeatherType.sunny,
          temperature: weather.temperature,
          category: 'outdoor',
          tags: ['산책', '피크닉', '야외'],
        ),
      );
    } else if (weather.main.toLowerCase() == 'rain') {
      recommendations.add(
        ActivityRecommendation(
          id: 'indoor_1',
          title: '실내 활동',
          description: '비 오는 날에는 카페나 박물관을 추천해요',
          weatherType: WeatherType.rainy,
          temperature: weather.temperature,
          category: 'indoor',
          tags: ['카페', '박물관', '실내'],
        ),
      );
    }

    return recommendations;
  }
}
