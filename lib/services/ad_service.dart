import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import '../constants/ad_constants.dart';
import 'api_service.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  final ApiService _apiService = ApiService();

  // Initialize AdMob
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // Load Ad based on server configuration
  Future<bool> loadAd() async {
    // 웹에서는 테스트 모드로 처리
    if (kIsWeb) {
      print('Web platform: simulating ad load');
      return true;
    }

    // Get ad configuration from server
    final response = await http.get(
      Uri.parse('https://my-style-server-chi.vercel.app/api/settings'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      String? adType;
      String? adUnitId;

      if (Platform.isIOS) {
        adType = json['ios_ad'] as String?;
        final iosRef = json['ref']?['ios'] as Map<String, dynamic>?;
        if (adType != null && iosRef != null && iosRef.containsKey(adType)) {
          adUnitId = iosRef[adType] as String?;
        }
      } else if (Platform.isAndroid) {
        adType = json['android_ad'] as String?;
        final androidRef = json['ref']?['android'] as Map<String, dynamic>?;
        if (adType != null &&
            androidRef != null &&
            androidRef.containsKey(adType)) {
          adUnitId = androidRef[adType] as String?;
        }
      }

      if (adUnitId == null) {
        print('Failed to get ad unit ID from server');
        return false;
      }

      print('Loading ad type: $adType with ID: $adUnitId');

      // Load appropriate ad type based on server configuration
      if (adType?.startsWith('rewarded') ?? false) {
        await _loadRewardedAd(adUnitId);
      } else if (adType?.startsWith('initial') ?? false) {
        await _loadInterstitialAd(adUnitId);
      } else {
        print('Unknown ad type: $adType');
        return false;
      }

      return true;
    }

    return false;
  }

  Future<void> _loadRewardedAd(String adUnitId) async {
    final completer = Completer<void>();

    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          print('Rewarded ad loaded successfully with ID: $adUnitId');
          completer.complete();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded ad failed to load: $error');
          completer.completeError(error);
        },
      ),
    );

    return completer.future;
  }

  Future<void> _loadInterstitialAd(String adUnitId) async {
    final completer = Completer<void>();

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad; // Use same flag for simplicity
          print('Interstitial ad loaded successfully with ID: $adUnitId');

          completer.complete();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
          completer.completeError(error);
        },
      ),
    );

    return completer.future;
  }

  // Show Ad (Rewarded or Interstitial based on loaded type)
  Future<bool> showAd() async {
    // 웹에서는 테스트 모드로 처리
    if (kIsWeb) {
      print('Web platform: simulating ad completion');
      await Future.delayed(const Duration(seconds: 2));
      return true;
    }

    if (_rewardedAd != null) {
      return _showRewardedAd();
    } else if (_interstitialAd != null) {
      return _showInterstitialAd();
    } else {
      print('No ad loaded');
      return false;
    }
  }

  Future<bool> _showRewardedAd() async {
    if (_rewardedAd == null) return false;

    final Completer<bool> completer = Completer<bool>();
    bool rewardEarned = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        print('Rewarded ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('Rewarded ad dismissed');
        ad.dispose();
        _rewardedAd = null;
        rewardEarned = true;
        completer.complete(rewardEarned);
        // Load next ad
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('Rewarded ad failed to show: $error');
        ad.dispose();
        _rewardedAd = null;
        if (!completer.isCompleted) {
          completer.complete(false);
        }
        // Load next ad
        loadAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('User earned reward: ${reward.amount} ${reward.type}');
        rewardEarned = true;
        completer.complete(rewardEarned);
      },
    );

    return completer.future;
  }

  Future<bool> _showInterstitialAd() async {
    if (_interstitialAd == null) return false;

    final completer = Completer<bool>();

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('Interstitial ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (ad) {
        print('Interstitial ad dismissed');
        ad.dispose();
        _interstitialAd = null;
        completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('Interstitial ad failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
        completer.complete(false);
      },
    );

    _interstitialAd!.show();
    return completer.future;
  }

  // Preload ad
  Future<void> preloadAd() async {
    await loadAd();
  }
}
