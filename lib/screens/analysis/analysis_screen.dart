import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import '../../constants/app_theme.dart';
import '../../services/ad_service.dart';
import '../../services/api_service.dart';
import '../result/result_screen.dart';
import '../../models/analysis_result.dart';

class AnalysisScreen extends StatefulWidget {
  final String imagePath;

  const AnalysisScreen({super.key, required this.imagePath});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  bool _isAdLoaded = false;
  bool _isAdShowing = false;
  bool _isAnalysisComplete = false;
  bool _isAdCompleted = false;
  AnalysisResult? _analysisResult;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAd();
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
        _errorMessage = '광고 시청에 실패했습니다';
      });
    }
  }

  Future<void> _startAnalysis() async {
    if (_isAnalysisComplete) return;

    setState(() {
      _isAnalysisComplete = true;
    });

    try {
      // 실제 OpenAI API 호출
      final result = await ApiService().analyzeFace(widget.imagePath);

      if (result != null) {
        _analysisResult = result;
        _checkAndNavigateToResult();
      } else {
        setState(() {
          _errorMessage = '분석에 실패했습니다. 다시 시도해주세요.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '분석 중 오류가 발생했습니다: $e';
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
      MaterialPageRoute(
        builder: (context) => ResultScreen(analysisResult: _analysisResult!),
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
        title: const Text(
          '광고 로드 실패',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          '광고를 본 후 분석을 진행합니다.\n다시 시도하시겠습니까?',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 팝업 닫기
              Navigator.of(context).pop(); // 이전 화면으로 돌아가기
            },
            child: const Text('아니오', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // 팝업 닫기
              _loadAd(); // 광고 재로드
            },
            child: const Text('예'),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _generateMockResult() {
    return {
      'id': 'analysis_${DateTime.now().millisecondsSinceEpoch}',
      'createdAt': DateTime.now().toIso8601String(),
      'gender': 'female',
      'imagePath': widget.imagePath,
      'faceAnalysis': {
        'faceShape': '하트형',
        'balanceScore': 85,
        'balanceComment': '균형 잡힌 얼굴형으로 전체적으로 조화로운 비율을 가지고 있습니다.',
        'strengths': ['이마가 넓어 지적인 인상', '턱선이 선명함'],
        'improvements': ['볼 부분이 좀 더 각져 보일 수 있음'],
      },
      'skinAnalysis': {
        'skinTone': '웜톤',
        'skinType': '복합성',
        'skinScore': 78,
        'skinComment': '전반적으로 건강한 피부 상태를 유지하고 있습니다.',
        'skinIssues': ['T존 유분', '볼 부분 건조'],
        'careRoutine': ['아침: 클렌징 → 토너 → 세럼 → 크림', '저녁: 더블 클렌징 → 토너 → 세럼 → 크림'],
        'productRecommendations': ['하이드레이팅 세럼', '논코메도제닉 크림'],
      },
      'hairAnalysis': {
        'recommendedStyles': ['레이어드 컷', '사이드 뱅'],
        'hairComment': '얼굴형에 잘 어울리는 헤어스타일을 추천합니다.',
        'stylingTips': ['앞머리로 이마를 가리기', '볼륨을 살려 얼굴을 길게 보이게 하기'],
        'beardAdvice': '',
        'hairScore': 82,
      },
      'eyebrowAnalysis': {
        'eyebrowShape': '아치형',
        'eyebrowScore': 80,
        'eyebrowComment': '자연스러운 아치형으로 눈매를 돋보이게 합니다.',
        'maintenanceTips': ['정기적인 트리밍', '자연스러운 색상 유지'],
        'stylingRecommendations': ['아치형 유지', '자연스러운 두께'],
      },
      'fashionAnalysis': {
        'fashionScore': 75,
        'fashionComment': '웜톤에 어울리는 컬러를 선택하세요.',
        'colorPalette': ['네이비', '아이보리', '베이지', '따뜻한 브라운'],
        'glassesRecommendations': ['라운드 프레임', '검정 뿔테'],
        'accessoryTips': ['심플한 귀걸이', '미니멀한 목걸이'],
      },
      'lifestyleAdvice': {
        'lifestyleScore': 70,
        'lifestyleComment': '건강한 생활습관을 유지하고 있습니다.',
        'sleepAdvice': '7-8시간 충분한 수면을 취하세요.',
        'dietAdvice': '비타민이 풍부한 과일과 채소를 충분히 섭취하세요.',
        'exerciseAdvice': '규칙적인 운동으로 혈액순환을 개선하세요.',
      },
      'overallScore': 78,
      'overallComment':
          '전반적으로 균형 잡힌 외모를 가지고 있습니다. 몇 가지 개선점을 적용하면 더욱 매력적인 모습이 될 것입니다.',
    };
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
              Color(0xFF667eea), // 모던 블루
              Color(0xFF764ba2), // 딥 퍼플
              Color(0xFFf093fb), // 소프트 핑크
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
                    '스타일 분석',
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
                      // 분석 아이콘
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // 제목
                      Text(
                        _isAdCompleted ? 'AI 분석 완료 중...' : 'AI 스타일 분석',
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
                        const Text(
                          '광고 시청 후 당신만의 스타일을 분석합니다',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
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
                              '광고 준비 중...',
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
                              'AI가 스타일을 분석하고 있습니다...',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
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
                              const Text(
                                '분석 중 오류가 발생했습니다',
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
                                      child: const Text('돌아가기'),
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
                                      child: const Text('재시도'),
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
