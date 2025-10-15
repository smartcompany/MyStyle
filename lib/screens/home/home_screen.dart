import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/style_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/style_recommendation_card.dart';
import '../../widgets/common/common_ui.dart';
import '../../models/style_recommendation.dart';
import '../photo/photo_styling_screen.dart';
import '../settings_screen.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToCamera;

  const HomeScreen({super.key, this.onNavigateToCamera});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final weatherProvider = Provider.of<WeatherProvider>(
      context,
      listen: false,
    );
    final styleProvider = Provider.of<StyleProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // 현재 로케일 언어 코드 가져오기
    final currentLocale = Localizations.localeOf(context);
    final language = currentLocale.languageCode;

    await userProvider.loadPreferences();
    await weatherProvider.getCurrentLocationWeather(language: language);

    if (weatherProvider.currentWeather != null) {
      await styleProvider.getRecommendations(
        weather: weatherProvider.currentWeather!,
        preferences: userProvider.preferences,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: CommonUI.buildCustomAppBar(
        context: context,
        title: AppLocalizations.of(context)!.home,
        onSettingsPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
      ),
      body: Consumer3<WeatherProvider, StyleProvider, UserProvider>(
        builder: (context, weatherProvider, styleProvider, userProvider, child) {
          if (weatherProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (weatherProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    weatherProvider.error!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _initializeData(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          if (weatherProvider.currentWeather == null) {
            return const Center(child: Text('날씨 정보를 불러오는 중...'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await weatherProvider.refreshWeather();
              if (weatherProvider.currentWeather != null) {
                await styleProvider.getRecommendations(
                  weather: weatherProvider.currentWeather!,
                  preferences: userProvider.preferences,
                );
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 날씨 정보를 배경에 직접 표시 (더 컴팩트하게)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    decoration: BoxDecoration(
                      gradient: _getWeatherGradient(
                        weatherProvider.currentWeather!.main,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 위치 정보
                        Text(
                          weatherProvider.currentWeather!.location
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2.0,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // 온도와 날씨 정보를 한 줄로 배치
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 왼쪽: 온도
                            Text(
                              '${weatherProvider.currentWeather!.temperature.round()}°',
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w200,
                                color: Colors.white,
                                letterSpacing: -2.0,
                                height: 1.0,
                              ),
                            ),

                            const SizedBox(width: 20),

                            // 중간: 날씨 아이콘과 설명
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 날씨 아이콘
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      _getWeatherEmoji(
                                        weatherProvider.currentWeather!.main,
                                      ),
                                      style: const TextStyle(fontSize: 36),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // 날씨 설명
                                  Text(
                                    weatherProvider.currentWeather!.description
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'FEELS LIKE ${weatherProvider.currentWeather!.feelsLike.round()}°',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white70,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 20),

                            // 오른쪽: 습도와 바람 정보
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildCompactWeatherInfo(
                                  'HUMIDITY',
                                  '${weatherProvider.currentWeather!.humidity}%',
                                ),
                                const SizedBox(height: 12),
                                _buildCompactWeatherInfo(
                                  'WIND',
                                  '${weatherProvider.currentWeather!.windSpeed.toStringAsFixed(1)}m/s',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 스타일 추천 섹션 (날씨 바로 아래로 이동)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF4A90E2),
                                    Color(0xFF5BA7F7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.todayEdit,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.todayStyleCuration,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        if (styleProvider.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(50),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          )
                        else if (styleProvider.styleRecommendations.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(48),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4A90E2,
                                  ).withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF4A90E2,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome_outlined,
                                      size: 48,
                                      color: Color(0xFF4A90E2),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.styleRecommendationPreparing,
                                    style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.aiAnalyzingYourStyle,
                                    style: TextStyle(
                                      color: const Color(0xFF94A3B8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...styleProvider.styleRecommendations.map(
                            (recommendation) => Container(
                              margin: const EdgeInsets.only(bottom: 0),
                              child: StyleRecommendationCard(
                                recommendation: recommendation,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // AI 코디 미리보기 섹션
                  Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4A90E2), Color(0xFF5BA7F7)],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A90E2).withOpacity(0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 헤더
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.aiStylingPreview,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.previewStyleWithCharacter,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 캐릭터 미리보기 영역
                        Container(
                          height: 200,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: styleProvider.styleRecommendations.isNotEmpty
                              ? _buildCharacterPreview(
                                  styleProvider.styleRecommendations.first,
                                )
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_outline,
                                        size: 48,
                                        color: Colors.white30,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '스타일 분석 중...',
                                        style: TextStyle(
                                          color: Colors.white30,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),

                        // 하단 버튼
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.likeThisStyle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // 추천 정보를 함께 전달
                                    final recommendationData =
                                        styleProvider
                                            .styleRecommendations
                                            .isNotEmpty
                                        ? {
                                            'title': styleProvider
                                                .styleRecommendations
                                                .first
                                                .title,
                                            'temperature': styleProvider
                                                .styleRecommendations
                                                .first
                                                .temperature,
                                            'clothingItems': styleProvider
                                                .styleRecommendations
                                                .first
                                                .clothingItems,
                                            'category': styleProvider
                                                .styleRecommendations
                                                .first
                                                .category
                                                .name,
                                          }
                                        : null;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PhotoStylingScreen(
                                              recommendationData:
                                                  recommendationData,
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF4A90E2),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    shadowColor: Colors.white.withOpacity(0.3),
                                  ),
                                  icon: const Icon(Icons.camera_alt, size: 20),
                                  label: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.tryCoordinatingWithPhoto,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 날씨에 따른 그라데이션 생성
  LinearGradient _getWeatherGradient(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF5BA7F7)],
        );
      case 'clouds':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C7B7F), Color(0xFF8B9CA5)],
        );
      case 'rain':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C3E50), Color(0xFF4A6741)],
        );
      case 'snow':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF74B9FF), Color(0xFFA8E6CF)],
        );
      case 'thunderstorm':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF5BA7F7)],
        );
    }
  }

  // 컴팩트한 날씨 정보 위젯 (오른쪽 정렬용)
  Widget _buildCompactWeatherInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white60,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // 캐릭터 미리보기 위젯
  Widget _buildCharacterPreview(StyleRecommendation recommendation) {
    final imagePath = _getCharacterImagePath(recommendation);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // 캐릭터 이미지
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 캐릭터 이미지 또는 fallback 아이콘
                  SizedBox(
                    height: 130,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // 이미지가 없으면 기본 아이콘 표시
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F0F0),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF6C6C6C),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getCategoryDisplayName(recommendation.category),
                    style: const TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 코디 정보
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  recommendation.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${recommendation.temperature.round()}°C 날씨 추천',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                // 주요 아이템들
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: recommendation.clothingItems
                      .take(3)
                      .map(
                        (item) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 캐릭터 이미지 경로 생성 (의류 아이템 기반)
  String _getCharacterImagePath(StyleRecommendation recommendation) {
    final category = _getCategoryName(recommendation.category);
    final gender = 'male'; // 현재는 기본값으로 처리 (나중에 사용자 설정에서 가져올 예정)
    final weather = _getWeatherFromClothing(
      recommendation.clothingItems,
      recommendation.temperature,
    );

    return 'assets/images/characters/${category}_${gender}_$weather.png';
  }

  // 카테고리 이름 (소문자)
  String _getCategoryName(StyleCategory category) {
    switch (category) {
      case StyleCategory.casual:
        return 'casual';
      case StyleCategory.sporty:
        return 'sporty';
      case StyleCategory.formal:
        return 'formal';
      case StyleCategory.trendy:
        return 'trendy';
    }
  }

  // 의류 아이템 기반으로 날씨 판단
  String _getWeatherFromClothing(
    List<String> clothingItems,
    double temperature,
  ) {
    final items = clothingItems.map((item) => item.toLowerCase()).toList();

    // 추운 날씨 아이템들
    if (items.any(
      (item) =>
          item.contains('패딩') ||
          item.contains('코트') ||
          item.contains('부츠') ||
          item.contains('목도리') ||
          item.contains('장갑'),
    )) {
      return 'cold';
    }

    // 더운 날씨 아이템들
    if (items.any(
      (item) =>
          item.contains('반팔') ||
          item.contains('반바지') ||
          item.contains('샌들') ||
          item.contains('슬리퍼') ||
          item.contains('민소매'),
    )) {
      return 'hot';
    }

    // 시원한 날씨 아이템들
    if (items.any(
      (item) =>
          item.contains('가디건') ||
          item.contains('후드') ||
          item.contains('자켓') ||
          item.contains('가벼운 외투'),
    )) {
      return 'cool';
    }

    // 기본적으로는 온도 기반으로 판단
    if (temperature >= 25) return 'hot';
    if (temperature >= 20) return 'warm';
    if (temperature >= 15) return 'cool';
    return 'cold';
  }

  // 카테고리 표시명
  String _getCategoryDisplayName(StyleCategory category) {
    switch (category) {
      case StyleCategory.casual:
        return 'CASUAL';
      case StyleCategory.sporty:
        return 'SPORTY';
      case StyleCategory.formal:
        return 'FORMAL';
      case StyleCategory.trendy:
        return 'TRENDY';
    }
  }

  // 날씨 이모지 매핑
  String _getWeatherEmoji(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return '☀️'; // 맑음 - 태양
      case 'clouds':
      case 'cloudy':
        return '☁️'; // 흐림 - 구름
      case 'rain':
      case 'drizzle':
        return '🌧️'; // 비
      case 'snow':
        return '❄️'; // 눈
      case 'thunderstorm':
        return '⛈️'; // 천둥번개
      case 'mist':
      case 'fog':
      case 'haze':
        return '🌫️'; // 안개
      default:
        return '☀️'; // 기본값은 맑음
    }
  }
}
