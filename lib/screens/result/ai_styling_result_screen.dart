import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/photo_analysis.dart';

class AIStylingResultScreen extends StatefulWidget {
  final File originalImage;
  final PhotoAnalysisResponse analysisResult;

  const AIStylingResultScreen({
    super.key,
    required this.originalImage,
    required this.analysisResult,
  });

  @override
  State<AIStylingResultScreen> createState() => _AIStylingResultScreenState();
}

class _AIStylingResultScreenState extends State<AIStylingResultScreen> {
  int _selectedStyleIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 코디 추천 결과'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: _shareResult),
          IconButton(icon: const Icon(Icons.download), onPressed: _saveResult),
        ],
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
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.file(widget.originalImage, fit: BoxFit.cover),
            ),
          ),

          const SizedBox(height: 16),

          // AI 생성 이미지
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF6C63FF), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.analysisResult.imageUrl.isNotEmpty
                  ? Image.network(
                      widget.analysisResult.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // 액션 버튼들
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _shareResult,
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('공유하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _saveResult,
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('저장하기'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6C63FF),
                      side: const BorderSide(color: Color(0xFF6C63FF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            Row(
              children: [
                Icon(Icons.wb_sunny, color: Colors.orange[600], size: 24),
                const SizedBox(width: 8),
                Text(
                  '오늘 날씨 맞춤 추천',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.analysisResult.outfitSummary,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.5),
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
                  '스타일 정보',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStyleColor(widget.analysisResult.style),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.analysisResult.style.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
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
                  '스타일링 팁',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...widget.analysisResult.careTips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 6, right: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6C63FF),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tip,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStyleColor(String style) {
    switch (style.toLowerCase()) {
      case 'casual':
        return const Color(0xFF74B9FF);
      case 'smart_casual':
        return const Color(0xFF00B894);
      case 'date':
        return const Color(0xFFE84393);
      case 'outdoor':
        return const Color(0xFF00B894);
      case 'business':
        return const Color(0xFF2D3436);
      default:
        return const Color(0xFF6C63FF);
    }
  }

  void _shareResult() {
    Share.share(
      'AI 스타일링 결과를 확인해보세요!\n\n스타일: ${widget.analysisResult.style}\n설명: ${widget.analysisResult.outfitSummary}',
      subject: 'AI 스타일링 결과',
    );
  }

  void _saveResult() {
    // TODO: 이미지 저장 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('이미지 저장 기능은 곧 추가될 예정입니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
