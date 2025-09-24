import 'package:flutter/material.dart';
import '../services/ad_service.dart';

class RewardedAdDialog extends StatefulWidget {
  final VoidCallback onAdCompleted;
  final VoidCallback onAdSkipped;

  const RewardedAdDialog({
    super.key,
    required this.onAdCompleted,
    required this.onAdSkipped,
  });

  @override
  State<RewardedAdDialog> createState() => _RewardedAdDialogState();
}

class _RewardedAdDialogState extends State<RewardedAdDialog> {
  bool _isLoading = true;
  bool _adError = false;
  String _statusMessage = '광고를 불러오는 중...';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    try {
      setState(() {
        _statusMessage = '광고를 불러오는 중...';
      });
      await AdService().loadRewardedAd();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = '광고를 시청하고 분석을 시작하세요';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _adError = true;
          _statusMessage = '광고를 불러올 수 없습니다';
        });
      }
    }
  }

  Future<void> _showAd() async {
    if (!AdService().isRewardedAdReady) {
      _loadAd();
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = '광고를 시청하고 분석 중...';
    });

    // 광고 시청과 분석을 동시에 시작
    final adFuture = AdService().showRewardedAd();
    final analysisFuture = _startAnalysis();

    // 진행 상황 업데이트
    _updateProgress();

    // 둘 다 완료될 때까지 대기
    final results = await Future.wait([adFuture, analysisFuture]);
    final adSuccess = results[0] as bool;
    final analysisSuccess = results[1] as bool;

    if (mounted) {
      if (adSuccess && analysisSuccess) {
        setState(() {
          _statusMessage = '분석 완료! 결과를 확인하세요';
        });
        await Future.delayed(Duration(milliseconds: 500));
        widget.onAdCompleted();
        Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = false;
          _adError = true;
          _statusMessage = '광고 시청 또는 분석에 실패했습니다';
        });
      }
    }
  }

  // 진행 상황 업데이트
  void _updateProgress() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && _isLoading) {
        setState(() {
          _statusMessage = '광고 시청 중...';
        });
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      if (mounted && _isLoading) {
        setState(() {
          _statusMessage = 'AI가 분석 중...';
        });
      }
    });
  }

  // 분석 시뮬레이션
  Future<bool> _startAnalysis() async {
    try {
      // 3-5초 동안 분석 시뮬레이션
      await Future.delayed(
        Duration(seconds: 3 + (DateTime.now().millisecond % 3)),
      );
      return true;
    } catch (e) {
      print('Analysis failed: $e');
      return false;
    }
  }

  void _skipAd() {
    widget.onAdSkipped();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_circle_outline,
                size: 40,
                color: Colors.amber,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            const Text(
              '광고를 보고 분석하세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              _adError
                  ? '광고를 불러올 수 없습니다.\n다시 시도하거나 건너뛸 수 있습니다.'
                  : '짧은 광고를 시청하면\nAI 스타일 분석을 받을 수 있습니다.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Buttons
            if (_isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(_statusMessage),
            ] else if (_adError) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _loadAd,
                      child: const Text('다시 시도'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _skipAd,
                      child: const Text('건너뛰기'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _skipAd,
                      child: const Text('건너뛰기'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showAd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('광고 보기'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
