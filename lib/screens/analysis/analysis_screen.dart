import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_theme.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  int _currentProgress = 0;
  int _currentStep = 0;

  final List<AnalysisStep> _steps = [
    AnalysisStep(
      title: '얼굴형 분석 중...',
      description: '얼굴의 기본 구조와 형태를 분석하고 있습니다',
      icon: Icons.face_outlined,
      color: AppTheme.primaryColor,
    ),
    AnalysisStep(
      title: '피부 상태 분석 중...',
      description: '피부톤과 피부 타입을 분석하고 있습니다',
      icon: Icons.face_retouching_natural,
      color: AppTheme.secondaryColor,
    ),
    AnalysisStep(
      title: '헤어스타일 분석 중...',
      description: '어울리는 헤어스타일을 찾고 있습니다',
      icon: Icons.content_cut,
      color: AppTheme.accentColor,
    ),
    AnalysisStep(
      title: '패션 분석 중...',
      description: '어울리는 색상과 스타일을 분석하고 있습니다',
      icon: Icons.style,
      color: AppTheme.successColor,
    ),
    AnalysisStep(
      title: '종합 분석 중...',
      description: '모든 분석 결과를 종합하여 리포트를 작성하고 있습니다',
      icon: Icons.analytics,
      color: AppTheme.warningColor,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnalysis();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startAnalysis() {
    _progressController.forward();

    // Simulate progress updates
    _updateProgress();
  }

  void _updateProgress() {
    if (_currentProgress < 100) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            _currentProgress += 2;
            _currentStep = (_currentProgress / 20).floor();
            if (_currentStep >= _steps.length) {
              _currentStep = _steps.length - 1;
            }
          });
          _updateProgress();
        }
      });
    } else {
      // Analysis complete
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          // 현재 분석 화면을 스택에서 제거하고 결과 화면으로 이동
          context.pushReplacement(AppRoutes.result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1F2937), Color(0xFF111827)],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Analysis Icon
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: _steps[_currentStep].color.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _steps[_currentStep].color,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            _steps[_currentStep].icon,
                            size: 60,
                            color: _steps[_currentStep].color,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 48),

                  // Current Step
                  Text(
                    _steps[_currentStep].title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    _steps[_currentStep].description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // Progress Bar
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '진행률',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '$_currentProgress%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: _currentProgress / 100,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _steps[_currentStep].color,
                            ),
                            minHeight: 8,
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Steps Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _steps.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? _steps[index].color
                              : Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnalysisStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  AnalysisStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
