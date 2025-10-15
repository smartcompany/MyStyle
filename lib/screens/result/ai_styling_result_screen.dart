import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/photo_analysis.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/common_ui.dart';
import '../../widgets/common/share_ui.dart';
import '../../constants/font_constants.dart';

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
                      // 현재 스타일
                      if (widget
                          .analysisResult
                          .styleAnalysis
                          .currentStyle
                          .isNotEmpty)
                        _buildStyleInfoItem(
                          AppLocalizations.of(context)!.currentStyleAnalysis,
                          widget.analysisResult.styleAnalysis.currentStyle,
                          Icons.style,
                        ),

                      // 색상 평가
                      if (widget
                          .analysisResult
                          .styleAnalysis
                          .colorEvaluation
                          .isNotEmpty)
                        _buildStyleInfoItem(
                          AppLocalizations.of(context)!.colorEvaluation,
                          widget.analysisResult.styleAnalysis.colorEvaluation,
                          Icons.palette,
                        ),

                      // 실루엣 분석
                      if (widget
                          .analysisResult
                          .styleAnalysis
                          .silhouette
                          .isNotEmpty)
                        _buildStyleInfoItem(
                          AppLocalizations.of(context)!.silhouetteAnalysis,
                          widget.analysisResult.styleAnalysis.silhouette,
                          Icons.accessibility_new,
                        ),

                      // 모든 정보가 비어있는 경우
                      if (widget
                              .analysisResult
                              .styleAnalysis
                              .currentStyle
                              .isEmpty &&
                          widget
                              .analysisResult
                              .styleAnalysis
                              .colorEvaluation
                              .isEmpty &&
                          widget
                              .analysisResult
                              .styleAnalysis
                              .silhouette
                              .isEmpty)
                        Text(
                          AppLocalizations.of(context)!.currentStyleAnalyzing,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
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
            Row(
              children: [
                Icon(Icons.checkroom, color: Colors.blue[600], size: 24),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.recommendedItems,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: FontConstants.aiResultSectionTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 상의
            _buildItemCategory(
              AppLocalizations.of(context)!.tops,
              widget.analysisResult.recommendations.tops,
              Icons.checkroom,
            ),
            const SizedBox(height: 12),

            // 하의
            _buildItemCategory(
              AppLocalizations.of(context)!.bottoms,
              widget.analysisResult.recommendations.bottoms,
              Icons.accessibility_new,
            ),
            const SizedBox(height: 12),

            // 아우터
            _buildItemCategory(
              AppLocalizations.of(context)!.outerwear,
              widget.analysisResult.recommendations.outerwear,
              Icons.ac_unit,
            ),
            const SizedBox(height: 12),

            // 신발
            _buildItemCategory(
              AppLocalizations.of(context)!.shoes,
              widget.analysisResult.recommendations.shoes,
              Icons.directions_walk,
            ),
            const SizedBox(height: 12),

            // 액세서리
            _buildItemCategory(
              AppLocalizations.of(context)!.accessories,
              widget.analysisResult.recommendations.accessories,
              Icons.watch,
            ),
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

            // 컬러 팔레트
            Row(
              children: [
                Icon(Icons.palette, color: Colors.purple[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.recommendedColors,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.analysisResult.colorPalette.recommended
                  .map(
                    (color) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getColorByName(color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getColorByName(color).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        color,
                        style: const TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.w600,
                          fontSize: FontConstants.aiResultSubText,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
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

  // 색상명으로 Color 객체 반환
  Color _getColorByName(String colorName) {
    switch (colorName.toLowerCase()) {
      case '네이비':
        return const Color(0xFF1E3A8A);
      case '아이보리':
        return const Color(0xFFFFF8DC);
      case '카키':
        return const Color(0xFF9CAF88);
      case '브라운':
        return const Color(0xFF8B4513);
      case '그레이':
        return const Color(0xFF6B7280);
      case '블랙':
        return const Color(0xFF000000);
      case '화이트':
        return const Color(0xFFFFFFFF);
      case '레드':
        return const Color(0xFFDC2626);
      case '블루':
        return const Color(0xFF2563EB);
      case '그린':
        return const Color(0xFF16A34A);
      default:
        return const Color(0xFF6C63FF);
    }
  }

  String _generateShareText() {
    return '''
AI 전신 분석 결과를 확인해보세요!

체형: ${_getBodyTypeDisplayName(widget.analysisResult.bodyType)}
키: ${_getHeightDisplayName(widget.analysisResult.height)}

현재 스타일 분석:
${widget.analysisResult.styleAnalysis.currentStyle.isNotEmpty ? '• 현재 스타일: ${widget.analysisResult.styleAnalysis.currentStyle}' : ''}
${widget.analysisResult.styleAnalysis.colorEvaluation.isNotEmpty ? '• 색상 평가: ${widget.analysisResult.styleAnalysis.colorEvaluation}' : ''}
${widget.analysisResult.styleAnalysis.silhouette.isNotEmpty ? '• 실루엣 분석: ${widget.analysisResult.styleAnalysis.silhouette}' : ''}

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
    ShareUI.showShareOptionsDialog(
      context: context,
      shareText: _generateShareText(),
      imagePath: widget.originalImage.path,
    );
  }
}
