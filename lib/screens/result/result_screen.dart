import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../models/analysis_result.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/score_card.dart';
import '../photo_upload_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock data for demonstration
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

    _initializeMockData();
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    _analysisResult = AnalysisResult(
      id: '1',
      createdAt: DateTime.now(),
      gender: 'auto_detected', // AI가 자동으로 감지
      faceAnalysis: FaceAnalysis(
        faceShape: 'heart',
        balanceScore: 85,
        balanceComment: '하트형 얼굴로 균형이 잘 잡혀있습니다. 이마가 넓고 턱이 뾰족한 특징이 있어요.',
        strengths: ['균형잡힌 얼굴 비율', '자연스러운 턱선'],
        improvements: ['입술 두께가 살짝 얇은 편'],
      ),
      skinAnalysis: SkinAnalysis(
        skinTone: 'warm',
        skinType: 'combination',
        skinScore: 78,
        skinComment: '웜톤의 복합성 피부로 건강한 상태입니다. T존 관리가 필요해요.',
        skinIssues: ['T존 유분', '약간의 건조함'],
        careRoutine: ['아침: 클렌징 → 토너 → 세럼 → 크림', '저녁: 더블 클렌징 → 토너 → 세럼 → 크림'],
        productRecommendations: ['하이드레이팅 세럼', '수분 크림', '각질 제거 스크럽'],
      ),
      hairAnalysis: HairAnalysis(
        recommendedStyles: ['보브 컷', '레이어드 컷', '숏 컷'],
        hairComment: '하트형 얼굴에 잘 어울리는 보브 컷을 추천합니다.',
        stylingTips: ['앞머리로 이마를 가려주세요', '옆머리를 살짝 내려 균형을 맞춰보세요'],
        beardAdvice: '',
        hairScore: 82,
      ),
      eyebrowAnalysis: EyebrowAnalysis(
        eyebrowShape: 'soft_arch',
        eyebrowScore: 75,
        eyebrowComment: '자연스러운 아치형 눈썹으로 전체적으로 잘 정리되어 있습니다.',
        maintenanceTips: ['정기적인 트리밍 필요', '털이 자라는 방향에 맞춰 정리'],
        stylingRecommendations: ['자연스러운 아치 유지', '털이 희박한 부분 보완'],
      ),
      fashionAnalysis: FashionAnalysis(
        recommendedColors: ['네이비', '아이보리', '로즈골드', '딥레드'],
        glassesRecommendations: ['라운드 프레임', '캣아이 프레임'],
        accessoryRecommendations: ['심플한 귀걸이', '미니멀 목걸이'],
        fashionComment: '웜톤에 어울리는 따뜻한 톤의 색상을 추천합니다.',
        fashionScore: 80,
      ),
      lifestyleAdvice: LifestyleAdvice(
        sleepAdvice: '7-8시간의 충분한 수면으로 피부 회복을 도와주세요.',
        dietAdvice: '비타민 C가 풍부한 과일과 채소를 충분히 섭취하세요.',
        exerciseAdvice: '규칙적인 운동으로 혈액순환을 개선하고 피부 건강을 유지하세요.',
        generalAdvice: '스트레스 관리와 충분한 수분 섭취를 잊지 마세요.',
        lifestyleScore: 70,
      ),
      overallScore: 80,
      overallComment:
          '전반적으로 균형잡힌 얼굴형과 피부 상태를 가지고 있습니다. 몇 가지 개선사항을 적용하면 더욱 아름다워질 수 있어요!',
    );
  }

  void _shareResult() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('분석 결과를 공유했습니다!'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
        AppButton(
          text: '결과 공유하기',
          onPressed: _shareResult,
          type: AppButtonType.outline,
          icon: Icons.share,
          isFullWidth: true,
        ),
      ],
    );
  }
}
