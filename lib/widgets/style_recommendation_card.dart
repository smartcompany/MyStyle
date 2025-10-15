import 'package:flutter/material.dart';
import '../models/style_recommendation.dart';
import '../l10n/app_localizations.dart';

class StyleRecommendationCard extends StatelessWidget {
  final StyleRecommendation recommendation;

  const StyleRecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더: 카테고리와 온도
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(recommendation.category),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(recommendation.category),
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getCategoryDisplayName(recommendation.category),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${recommendation.temperature.round()}°C',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 메인 제목
            Text(
              recommendation.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                height: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            // 간단한 설명
            Text(
              recommendation.description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6C6C6C),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // 의류 아이템들
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: recommendation.clothingItems
                  .take(4)
                  .map(
                    (item) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 12),

            // 하단 정보
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getWeatherIcon(recommendation.weatherType),
                      size: 16,
                      color: const Color(0xFF6C6C6C),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getWeatherDisplayName(recommendation.weatherType),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6C6C6C),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${recommendation.confidence}% ${AppLocalizations.of(context)!.recommended}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 카테고리별 색상
  Color _getCategoryColor(StyleCategory category) {
    switch (category) {
      case StyleCategory.casual:
        return const Color(0xFF74B9FF);
      case StyleCategory.sporty:
        return const Color(0xFF00B894);
      case StyleCategory.formal:
        return const Color(0xFF2D3436);
      case StyleCategory.trendy:
        return const Color(0xFFD4AF37);
    }
  }

  // 카테고리별 아이콘 (옷 관련)
  IconData _getCategoryIcon(StyleCategory category) {
    switch (category) {
      case StyleCategory.casual:
        return Icons.checkroom; // 옷장 아이콘
      case StyleCategory.sporty:
        return Icons.sports; // 스포츠 아이콘
      case StyleCategory.formal:
        return Icons.business_center; // 비즈니스 아이콘
      case StyleCategory.trendy:
        return Icons.local_fire_department; // 트렌드 아이콘
    }
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

  // 날씨별 아이콘
  IconData _getWeatherIcon(WeatherType weatherType) {
    switch (weatherType) {
      case WeatherType.sunny:
        return Icons.wb_sunny;
      case WeatherType.cloudy:
        return Icons.cloud;
      case WeatherType.rainy:
        return Icons.grain;
      case WeatherType.snowy:
        return Icons.ac_unit;
      case WeatherType.windy:
        return Icons.air;
    }
  }

  // 날씨 표시명
  String _getWeatherDisplayName(WeatherType weatherType) {
    switch (weatherType) {
      case WeatherType.sunny:
        return 'SUNNY';
      case WeatherType.cloudy:
        return 'CLOUDY';
      case WeatherType.rainy:
        return 'RAINY';
      case WeatherType.snowy:
        return 'SNOWY';
      case WeatherType.windy:
        return 'WINDY';
    }
  }
}
