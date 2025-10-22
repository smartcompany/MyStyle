import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../models/photo_analysis.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/common_ui.dart';
import '../../widgets/common/share_ui.dart';
import '../../constants/font_constants.dart';
import '../../constants/api_constants.dart';

class AIStylingResultScreen extends StatefulWidget {
  final File originalImage;
  final FullBodyAnalysisResponse analysisResult;

  const AIStylingResultScreen({
    super.key,
    required this.originalImage,
    required this.analysisResult,
  });

  @override
  State<AIStylingResultScreen> createState() => _AIStylingResultScreenState();
}

class _AIStylingResultScreenState extends State<AIStylingResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonUI.buildShareAppBar(
        context: context,
        title: AppLocalizations.of(context)!.aiStylingTitle,
        onSharePressed: _shareResult,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 스타일링된 사진 카드
            _buildStyledPhotoCard(),

            const SizedBox(height: 24),

            // 날씨 기반 추천 설명
            _buildWeatherRecommendationCard(),

            const SizedBox(height: 16),

            // 아웃핏 상세 정보
            _buildOutfitDetailsCard(),

            const SizedBox(height: 16),

            // 스타일링 팁
            _buildStylingTipsCard(),

            const SizedBox(height: 24),

            // 공유하기 UI 컴포넌트
            ShareUI.buildShareSection(
              context: context,
              title: AppLocalizations.of(context)!.aiStyleAnalysisResult,
              description: AppLocalizations.of(
                context,
              )!.sharePersonalizedStyleAnalysis,
              shareText: _generateShareText(),
              imagePath: widget.originalImage.path,
              onShareTap: _shareResult,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledPhotoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // 원본 이미지
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.file(
                widget.originalImage,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 분석 결과 정보
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF6C63FF), width: 2),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 체형 분석 정보
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF6C63FF),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.bodyAnalysisResult,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: FontConstants.aiResultSectionTitle,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1A1A),
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${AppLocalizations.of(context)!.bodyType}: ${_getBodyTypeDisplayName(widget.analysisResult.bodyType)} • ${AppLocalizations.of(context)!.height}: ${_getHeightDisplayName(widget.analysisResult.height)}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: FontConstants.aiResultDetailText,
                                  color: const Color(0xFF1A1A1A),
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${AppLocalizations.of(context)!.confidence}: ${widget.analysisResult.confidence}%',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontSize: FontConstants.aiResultSubText,
                                  color: const Color(0xFF6C63FF),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 현재 스타일 상세 정보
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 통합 스타일 분석
                      if (widget
                          .analysisResult
                          .styleAnalysis
                          .unifiedAnalysis
                          .isNotEmpty)
                        _buildStyleInfoItem(
                          AppLocalizations.of(context)!.currentStyleAnalysis,
                          widget.analysisResult.styleAnalysis.unifiedAnalysis,
                          Icons.style,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildWeatherRecommendationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.wb_sunny, color: Colors.orange[600], size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.fullBodyAnalysisCustomStyle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: FontConstants.aiResultSectionTitle,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.aiAnalyzedBodyStyleRecommendation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: FontConstants.aiResultDetailText,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutfitDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 통합 서술형 모드인지 확인하여 다른 UI 표시
            if (widget
                .analysisResult
                .recommendations
                .isUnifiedDescriptiveMode) ...[
              // 통합 서술형 모드
              _buildUnifiedDescriptiveRecommendation(
                widget.analysisResult.recommendations.unifiedDescriptive ?? '',
              ),
            ] else ...[
              // 기존 리스트 모드
              _buildItemCategory(
                AppLocalizations.of(context)!.tops,
                widget.analysisResult.recommendations.tops,
                Icons.checkroom,
              ),
              const SizedBox(height: 12),

              _buildItemCategory(
                AppLocalizations.of(context)!.bottoms,
                widget.analysisResult.recommendations.bottoms,
                Icons.accessibility_new,
              ),
              const SizedBox(height: 12),

              _buildItemCategory(
                AppLocalizations.of(context)!.outerwear,
                widget.analysisResult.recommendations.outerwear,
                Icons.ac_unit,
              ),
              const SizedBox(height: 12),

              _buildItemCategory(
                AppLocalizations.of(context)!.shoes,
                widget.analysisResult.recommendations.shoes,
                Icons.directions_walk,
              ),
              const SizedBox(height: 12),

              _buildItemCategory(
                AppLocalizations.of(context)!.accessories,
                widget.analysisResult.recommendations.accessories,
                Icons.watch,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStylingTipsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber[600], size: 24),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.stylingTips,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: FontConstants.aiResultSectionTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...widget.analysisResult.stylingTips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6, right: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tip,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: FontConstants.aiResultDetailText,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // 스타일 정보 아이템 위젯
  Widget _buildStyleInfoItem(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF6C63FF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: FontConstants.aiResultDetailText,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: FontConstants.aiResultDetailText,
                    color: const Color(0xFF1A1A1A),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 아이템 카테고리 위젯
  Widget _buildItemCategory(
    String categoryName,
    List<String> items,
    IconData icon,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF6C63FF)),
            const SizedBox(width: 6),
            Text(
              categoryName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: FontConstants.aiResultDetailText,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: items
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF6C63FF).withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Color(0xFF6C63FF),
                      fontSize: FontConstants.aiResultSubText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // 통합 서술형 추천 위젯
  Widget _buildUnifiedDescriptiveRecommendation(String description) {
    if (description.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.style, size: 20, color: const Color(0xFF6C63FF)),
            const SizedBox(width: 8),
            Text(
              'AI 코디 추천',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: FontConstants.aiResultSectionTitle,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
          ),
          child: Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: FontConstants.aiResultDetailText + 1,
              color: const Color(0xFF495057),
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // 체형 타입 표시명
  String _getBodyTypeDisplayName(String bodyType) {
    switch (bodyType.toLowerCase()) {
      case 'rectangle':
        return AppLocalizations.of(context)!.rectangle;
      case 'hourglass':
        return AppLocalizations.of(context)!.hourglass;
      case 'pear':
        return AppLocalizations.of(context)!.pear;
      case 'apple':
        return AppLocalizations.of(context)!.apple;
      case 'inverted_triangle':
        return AppLocalizations.of(context)!.invertedTriangle;
      default:
        return bodyType;
    }
  }

  // 키 표시명
  String _getHeightDisplayName(String height) {
    switch (height.toLowerCase()) {
      case 'tall':
        return AppLocalizations.of(context)!.tall;
      case 'medium':
        return AppLocalizations.of(context)!.medium;
      case 'short':
        return AppLocalizations.of(context)!.short;
      default:
        return height;
    }
  }

  String _generateShareText() {
    return '''
AI 전신 분석 결과를 확인해보세요!

체형: ${_getBodyTypeDisplayName(widget.analysisResult.bodyType)}
키: ${_getHeightDisplayName(widget.analysisResult.height)}

현재 스타일 분석:
${widget.analysisResult.styleAnalysis.unifiedAnalysis.isNotEmpty ? '• ${widget.analysisResult.styleAnalysis.unifiedAnalysis}' : ''}

추천 아이템:
• 상의: ${widget.analysisResult.recommendations.tops.join(', ')}
• 하의: ${widget.analysisResult.recommendations.bottoms.join(', ')}
• 아우터: ${widget.analysisResult.recommendations.outerwear.join(', ')}

스타일링 팁:
${widget.analysisResult.stylingTips.map((tip) => '• $tip').join('\n')}

신뢰도: ${widget.analysisResult.confidence}%
''';
  }

  void _shareResult() {
    try {
      // 결과 데이터를 URL 파라미터로 인코딩
      final webUrl = _generateShareUrl();

      // 공유 다이얼로그 표시 (웹 URL 포함)
      ShareUI.showShareOptionsDialog(
        context: context,
        shareText: _generateShareText(),
        imagePath: widget.originalImage.path,
        webUrl: webUrl,
      );
    } catch (e) {
      print('공유 URL 생성 실패: $e');
      // 에러 발생 시 기존 방식으로 공유
      ShareUI.showShareOptionsDialog(
        context: context,
        shareText: _generateShareText(),
        imagePath: widget.originalImage.path,
      );
    }
  }

  String _generateShareUrl() {
    try {
      // 결과 데이터 구성 (이미지 제외하고 텍스트만)
      final resultData = {
        'styleAnalysis': widget.analysisResult.styleAnalysis.unifiedAnalysis,
        'bodyAnalysis': {
          'height': widget.analysisResult.height,
          'bodyType': widget.analysisResult.bodyType,
        },
        'recommendations': [
          ...widget.analysisResult.recommendations.tops.map(
            (item) => {'item': item, 'reason': '상의 추천'},
          ),
          ...widget.analysisResult.recommendations.bottoms.map(
            (item) => {'item': item, 'reason': '하의 추천'},
          ),
          ...widget.analysisResult.recommendations.outerwear.map(
            (item) => {'item': item, 'reason': '아우터 추천'},
          ),
          ...widget.analysisResult.recommendations.shoes.map(
            (item) => {'item': item, 'reason': '신발 추천'},
          ),
          ...widget.analysisResult.recommendations.accessories.map(
            (item) => {'item': item, 'reason': '액세서리 추천'},
          ),
        ],
        'language': Localizations.localeOf(context).languageCode,
        'confidence': widget.analysisResult.confidence,
      };

      // JSON을 문자열로 변환 후 URL 인코딩
      final jsonString = jsonEncode(resultData);
      final encodedData = Uri.encodeComponent(jsonString);

      // 고정 URL + 파라미터 조합
      return '${ApiConstants.apiBaseUrl}/share?data=$encodedData';
    } catch (e) {
      print('URL 생성 중 오류: $e');
      // 에러 시 기본 URL 반환
      return '${ApiConstants.apiBaseUrl}/share';
    }
  }
}
