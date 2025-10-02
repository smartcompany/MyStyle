import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../models/analysis_result.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/score_card.dart';
import '../../widgets/common/share_ui.dart';
import '../photo_upload_screen.dart';
import '../settings_screen.dart';
import '../../l10n/app_localizations.dart';

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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.styleAnalysisResult,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: _shareResult,
              icon: const Icon(Icons.share, color: Colors.blue),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings_outlined, color: Colors.black87),
          ),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.purple.shade400],
                  ),
                  borderRadius: BorderRadius.circular(12),
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
                      AppLocalizations.of(context)!.overallAnalysisResultTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.aiAnalyzedYourStyle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Text(
              _analysisResult.overallComment,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
                height: 1.6,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSections() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildModernScoreCard(
            title: AppLocalizations.of(context)!.faceShapeAnalysisTitle,
            comment: _analysisResult.faceAnalysis.balanceComment,
            details: [
              '${AppLocalizations.of(context)!.faceShape}: ${_analysisResult.faceAnalysis.faceShape}',
              '${AppLocalizations.of(context)!.strengths}: ${_analysisResult.faceAnalysis.strengths}',
              '${AppLocalizations.of(context)!.improvements}: ${_analysisResult.faceAnalysis.improvements}',
            ],
            icon: Icons.face_outlined,
            gradientColors: [Colors.pink.shade400, Colors.orange.shade400],
          ),

          _buildModernScoreCard(
            title: AppLocalizations.of(context)!.skinAnalysisTitle,
            comment: _analysisResult.skinAnalysis.skinComment,
            details: [
              '${AppLocalizations.of(context)!.skinTone}: ${_analysisResult.skinAnalysis.skinTone}',
              '${AppLocalizations.of(context)!.skinType}: ${_analysisResult.skinAnalysis.skinType}',
              '${AppLocalizations.of(context)!.skinIssues}: ${_analysisResult.skinAnalysis.skinIssues}',
            ],
            icon: Icons.face_retouching_natural,
            gradientColors: [Colors.green.shade400, Colors.teal.shade400],
          ),

          _buildModernScoreCard(
            title: AppLocalizations.of(context)!.hairStyleTitle,
            comment: _analysisResult.hairAnalysis.hairComment,
            details: [_analysisResult.hairAnalysis.recommendedStyles],
            icon: Icons.content_cut,
            gradientColors: [Colors.purple.shade400, Colors.indigo.shade400],
          ),

          _buildModernScoreCard(
            title: AppLocalizations.of(context)!.eyebrowManagementTitle,
            comment: _analysisResult.eyebrowAnalysis.eyebrowComment,
            details: [_analysisResult.eyebrowAnalysis.maintenanceTips],
            icon: Icons.visibility,
            gradientColors: [Colors.amber.shade400, Colors.orange.shade400],
          ),

          _buildModernScoreCard(
            title: AppLocalizations.of(context)!.fashionAccessoriesTitle,
            comment: _analysisResult.fashionAnalysis.fashionComment,
            details: [
              '${AppLocalizations.of(context)!.recommendedColors}: ${_analysisResult.fashionAnalysis.recommendedColors}',
              '${AppLocalizations.of(context)!.glassesRecommendations}: ${_analysisResult.fashionAnalysis.glassesRecommendations}',
            ],
            icon: Icons.style,
            gradientColors: [Colors.cyan.shade400, Colors.blue.shade400],
          ),

          _buildModernScoreCard(
            title: AppLocalizations.of(context)!.lifestyleTitle,
            comment: _analysisResult.lifestyleAdvice.generalAdvice,
            details: [
              _analysisResult.lifestyleAdvice.sleepAdvice,
              _analysisResult.lifestyleAdvice.dietAdvice,
              _analysisResult.lifestyleAdvice.exerciseAdvice,
            ],
            icon: Icons.favorite,
            gradientColors: [Colors.red.shade400, Colors.pink.shade400],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade500, Colors.purple.shade500],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _analyzeAgain,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                AppLocalizations.of(context)!.analyzeAgain,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 공유 섹션 추가
          ShareUI.buildShareSection(
            context: context,
            title: AppLocalizations.of(context)!.shareResultTitle,
            description: AppLocalizations.of(context)!.styleGuideDescription,
            shareText: _generateShareText(),
            onShareTap: _shareResult,
          ),
        ],
      ),
    );
  }

  String _generateShareText() {
    return '''
🎨 ${AppLocalizations.of(context)!.myStyleAnalysisResult}

📊 ${AppLocalizations.of(context)!.overallAnalysisResultTitle}
${_analysisResult.overallComment}

👤 ${AppLocalizations.of(context)!.faceShapeAnalysisTitle}
${_analysisResult.faceAnalysis.balanceComment}

✨ ${AppLocalizations.of(context)!.skinAnalysisTitle}
${_analysisResult.skinAnalysis.skinComment}

💇‍♀️ ${AppLocalizations.of(context)!.hairStyleTitle}
${_analysisResult.hairAnalysis.hairComment}

👁️ ${AppLocalizations.of(context)!.eyebrowManagementTitle}
${_analysisResult.eyebrowAnalysis.eyebrowComment}

👔 ${AppLocalizations.of(context)!.fashionAccessoriesTitle}
${_analysisResult.fashionAnalysis.fashionComment}

💪 ${AppLocalizations.of(context)!.lifestyleTitle}
${_analysisResult.lifestyleAdvice.generalAdvice}

${AppLocalizations.of(context)!.myStyleAppRecommendation}
    ''';
  }

  void _shareResult() {
    ShareUI.showShareOptionsDialog(
      context: context,
      shareText: _generateShareText(),
    );
  }

  Widget _buildModernScoreCard({
    required String title,
    required String comment,
    required List<String> details,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: gradientColors[0].withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: gradientColors[0].withOpacity(0.1)),
            ),
            child: Text(
              comment,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
                height: 1.5,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
          if (details.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...details.map(
              (detail) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 8, right: 8),
                      decoration: BoxDecoration(
                        color: gradientColors[0],
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        detail,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          height: 1.4,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
