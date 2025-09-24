import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/ad_constants.dart';
import 'api_service.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;
  final ApiService _apiService = ApiService();

  // Initialize AdMob
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // Load Rewarded Ad
  Future<void> loadRewardedAd() async {
    if (_isRewardedAdReady) return;

    // 웹에서는 테스트 모드로 처리
    if (kIsWeb) {
      print('Web platform: simulating ad load');
      _isRewardedAdReady = true;
      return;
    }

    try {
      // Get ad unit ID from server
      final adUnitId = await _apiService.getRewardedAdUnitId();

      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _isRewardedAdReady = true;
            print('Rewarded ad loaded successfully with ID: $adUnitId');
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isRewardedAdReady = false;
            print('Rewarded ad failed to load: $error');
          },
        ),
      );
    } catch (e) {
      print('Error loading rewarded ad: $e');
      // Fallback to test ad if server fails
      await _loadFallbackRewardedAd();
    }
  }

  // Fallback to test ad if server fails
  Future<void> _loadFallbackRewardedAd() async {
    await RewardedAd.load(
      adUnitId: AdConstants.rewardedAdId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          print('Fallback rewarded ad loaded successfully');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isRewardedAdReady = false;
          print('Fallback rewarded ad failed to load: $error');
        },
      ),
    );
  }

  // Show Rewarded Ad
  Future<bool> showRewardedAd() async {
    // 웹에서는 테스트 모드로 처리
    if (kIsWeb) {
      print('Web platform: simulating ad completion');
      await Future.delayed(const Duration(seconds: 2));
      return true;
    }

    if (!_isRewardedAdReady || _rewardedAd == null) {
      print('Rewarded ad is not ready');
      return false;
    }

    final Completer<bool> completer = Completer<bool>();

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        print('Rewarded ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('Rewarded ad dismissed');
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdReady = false;
        if (!completer.isCompleted) {
          completer.complete(false);
        }
        // Load next ad
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('Rewarded ad failed to show: $error');
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdReady = false;
        if (!completer.isCompleted) {
          completer.complete(false);
        }
        // Load next ad
        loadRewardedAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('User earned reward: ${reward.amount} ${reward.type}');
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      },
    );

    return completer.future;
  }

  // Check if rewarded ad is ready
  bool get isRewardedAdReady => _isRewardedAdReady;

  // Preload rewarded ad
  Future<void> preloadRewardedAd() async {
    await loadRewardedAd();
  }
}
