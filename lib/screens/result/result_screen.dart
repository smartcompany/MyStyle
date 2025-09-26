import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../models/analysis_result.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/score_card.dart';
import '../../widgets/common/share_ui.dart';
import '../photo_upload_screen.dart';

class ResultScreen extends StatefulWidget {
  final AnalysisResult analysisResult;

  const ResultScreen({super.key, required this.analysisResult});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Analysis result from API
  late AnalysisResult _analysisResult;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _analysisResult = widget.analysisResult;
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _analyzeAgain() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const PhotoUploadScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('분석 결과'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(onPressed: _shareResult, icon: const Icon(Icons.share)),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall Score Card
                _buildOverallScoreCard(),

                const SizedBox(height: 24),

                // Analysis Sections
                _buildAnalysisSections(),

                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverallScoreCard() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              AppTheme.secondaryColor.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '종합 분석 결과',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _analysisResult.overallComment,
              style: const TextStyle(
                fontSize: 18,
                color: AppTheme.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSections() {
    return Column(
      children: [
        ScoreCard(
          title: '얼굴형 분석',
          comment: _analysisResult.faceAnalysis.balanceComment,
          details: [
            '얼굴형: ${_analysisResult.faceAnalysis.faceShape}',
            ..._analysisResult.faceAnalysis.strengths.map((s) => '장점: $s'),
            ..._analysisResult.faceAnalysis.improvements.map((i) => '개선점: $i'),
          ],
          icon: Icons.face_outlined,
        ),

        ScoreCard(
          title: '피부 분석',
          comment: _analysisResult.skinAnalysis.skinComment,
          details: [
            '피부톤: ${_analysisResult.skinAnalysis.skinTone}',
            '피부타입: ${_analysisResult.skinAnalysis.skinType}',
            ..._analysisResult.skinAnalysis.skinIssues.map((i) => '관심사항: $i'),
          ],
          icon: Icons.face_retouching_natural,
        ),

        ScoreCard(
          title: '헤어스타일',
          comment: _analysisResult.hairAnalysis.hairComment,
          details: _analysisResult.hairAnalysis.recommendedStyles,
          icon: Icons.content_cut,
        ),

        ScoreCard(
          title: '눈썹 관리',
          comment: _analysisResult.eyebrowAnalysis.eyebrowComment,
          details: _analysisResult.eyebrowAnalysis.maintenanceTips,
          icon: Icons.visibility,
        ),

        ScoreCard(
          title: '패션 & 액세서리',
          comment: _analysisResult.fashionAnalysis.fashionComment,
          details: [
            ..._analysisResult.fashionAnalysis.recommendedColors.map(
              (c) => '추천 색상: $c',
            ),
            ..._analysisResult.fashionAnalysis.glassesRecommendations.map(
              (g) => '안경: $g',
            ),
          ],
          icon: Icons.style,
        ),

        ScoreCard(
          title: '라이프스타일',
          comment: _analysisResult.lifestyleAdvice.generalAdvice,
          details: [
            _analysisResult.lifestyleAdvice.sleepAdvice,
            _analysisResult.lifestyleAdvice.dietAdvice,
            _analysisResult.lifestyleAdvice.exerciseAdvice,
          ],
          icon: Icons.favorite,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        AppButton(
          text: '다시 분석하기',
          onPressed: _analyzeAgain,
          icon: Icons.refresh,
          isFullWidth: true,
        ),
        const SizedBox(height: 12),
        // 공유 섹션 추가
        ShareUI.buildShareSection(
          context: context,
          title: '결과 공유하기',
          description: '분석 결과를 친구들과 공유해보세요!',
          shareText: _generateShareText(),
          onShareTap: _shareResult,
        ),
      ],
    );
  }

  String _generateShareText() {
    return '''
🎨 MyStyle 분석 결과

📊 종합 분석 결과
${_analysisResult.overallComment}

👤 얼굴형 분석
${_analysisResult.faceAnalysis.balanceComment}

✨ 피부 분석
${_analysisResult.skinAnalysis.skinComment}

💇‍♀️ 헤어스타일
${_analysisResult.hairAnalysis.hairComment}

👁️ 눈썹 관리
${_analysisResult.eyebrowAnalysis.eyebrowComment}

👔 패션 & 액세서리
${_analysisResult.fashionAnalysis.fashionComment}

💪 라이프스타일
${_analysisResult.lifestyleAdvice.generalAdvice}

MyStyle 앱으로 나만의 스타일을 찾아보세요! ✨
    ''';
  }

  void _shareResult() {
    ShareUI.showShareOptionsDialog(
      context: context,
      shareText: _generateShareText(),
    );
  }
}
