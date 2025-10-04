import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../services/ad_service.dart';
import '../../services/api_service.dart';
import '../result/result_screen.dart';
import '../../models/analysis_result.dart';
import '../../l10n/app_localizations.dart';
import 'dart:async';

class AnalysisScreen extends StatefulWidget {
  final String imagePath;

  const AnalysisScreen({super.key, required this.imagePath});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with TickerProviderStateMixin {
  bool _isAdLoaded = false;
  bool _isAdShowing = false;
  bool _isAnalysisComplete = false;
  bool _isAdCompleted = false;
  AnalysisResult? _analysisResult;
  String? _errorMessage;

  late AnimationController _sparkleController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _sparkleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadAd();
  }

  void _initializeAnimations() {
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _sparkleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_rotateController);
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  Future<void> _loadAd() async {
    try {
      final adLoaded = await AdService().loadAd();

      if (adLoaded) {
        setState(() {
          _isAdLoaded = true;
        });
        // 광고가 로드되면 자동으로 광고를 보여줌
        _showAd();
      } else {
        _showAdLoadFailedDialog();
      }
    } catch (e) {
      _showAdLoadFailedDialog();
    }
  }

  Future<void> _showAd() async {
    if (!_isAdLoaded) {
      _showAdLoadFailedDialog();
      return;
    }

    setState(() {
      _isAdShowing = true;
    });

    // 광고 시청과 분석을 동시에 시작
    _startAnalysis();

    final adSuccess = await AdService().showAd();
    if (adSuccess) {
      setState(() {
        _isAdCompleted = true;
      });
      _checkAndNavigateToResult();
    } else {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.adViewingFailed;
      });
    }
  }

  Future<void> _startAnalysis() async {
    if (_isAnalysisComplete) return;

    try {
      // 실제 OpenAI API 호출
      final currentLocale = Localizations.localeOf(context);
      final result = await ApiService().analyzeFace(
        widget.imagePath,
        language: currentLocale.languageCode,
      );

      if (result != null) {
        setState(() {
          _analysisResult = result;
          _isAnalysisComplete = true;
        });
        _checkAndNavigateToResult();
      } else {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.analysisFailed;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            '${AppLocalizations.of(context)!.analysisErrorOccurred}: $e';
      });
    }
  }

  void _checkAndNavigateToResult() {
    if (_isAdCompleted && _isAnalysisComplete && _analysisResult != null) {
      _navigateToResult();
    }
  }

  void _navigateToResult() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ResultScreen(analysisResult: _analysisResult!),
      ),
    );
  }

  void _showAdLoadFailedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B69),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.of(context)!.adLoadFailedTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          AppLocalizations.of(context)!.adLoadFailedMessage,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 팝업 닫기
              Navigator.of(context).pop(); // 이전 화면으로 돌아가기
            },
            child: Text(
              AppLocalizations.of(context)!.no,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // 팝업 닫기
              _loadAd(); // 광고 재로드
            },
            child: Text(AppLocalizations.of(context)!.yes),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3B82F6), // 블루 500
              Color(0xFF6366F1), // 인디고 500
              Color(0xFF8B5CF6), // 바이올렛 500
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 헤더
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.styleAnalysis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // 메인 콘텐츠
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 분석 아이콘 (애니메이션 포함)
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _sparkleAnimation,
                          _pulseAnimation,
                        ]),
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.15),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(70),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: const Offset(0, -5),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // 메인 아이콘
                                  Icon(
                                    Icons.auto_awesome,
                                    color: Colors.white,
                                    size: 70,
                                  ),
                                  // 회전하는 작은 아이콘들
                                  ...List.generate(3, (index) {
                                    return AnimatedBuilder(
                                      animation: _rotateAnimation,
                                      builder: (context, child) {
                                        final angle =
                                            (index * 120) * (3.14159 / 180) +
                                            (_rotateAnimation.value *
                                                2 *
                                                3.14159);
                                        return Transform.translate(
                                          offset: Offset(
                                            (60 * _sparkleAnimation.value) *
                                                math.cos(angle),
                                            (60 * _sparkleAnimation.value) *
                                                math.sin(angle),
                                          ),
                                          child: Transform.scale(
                                            scale: _sparkleAnimation.value,
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.8,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.blue[400],
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),

                      // 제목
                      Text(
                        _isAdCompleted
                            ? AppLocalizations.of(context)!.aiAnalyzing
                            : AppLocalizations.of(context)!.aiStyleAnalysis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // 설명
                      if (!_isAdCompleted)
                        Text(
                          AppLocalizations.of(context)!.analyzeAfterAd,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        )
                      else
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.analysisDescription,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      const SizedBox(height: 40),

                      // 광고 로딩 중 또는 광고 시청 중
                      if (!_isAdShowing && !_isAnalysisComplete)
                        Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context)!.adPreparing,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                      // 광고 표시 중 또는 분석 진행 중
                      if (_isAdShowing || _isAnalysisComplete)
                        Column(
                          children: [
                            // 간단한 로딩 인디케이터
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _pulseAnimation.value,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withOpacity(
                                                0.5,
                                              ),
                                              blurRadius: 12,
                                              spreadRadius: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // 대기 메시지
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.pleaseWaitLongTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),

                      // 에러 메시지
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.analysisError,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.2),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.goBack,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _errorMessage = null;
                                          _isAnalysisComplete = false;
                                        });
                                        _startAnalysis();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF22C55E,
                                        ),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.retry,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
