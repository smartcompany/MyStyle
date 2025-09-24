import 'dart:io';
import 'package:dio/dio.dart';
import '../models/ad_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  AdConfig? _adConfig;
  bool _isConfigLoaded = false;

  void initialize({String baseUrl = 'https://your-api-server.com'}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print(obj),
      ),
    );
  }

  // Get ad configuration from server
  Future<AdConfig> getAdConfig() async {
    if (_isConfigLoaded && _adConfig != null) {
      return _adConfig!;
    }

    try {
      final response = await _dio.get('/api/settings');

      if (response.statusCode == 200) {
        _adConfig = AdConfig.fromJson(response.data);
        _isConfigLoaded = true;
        return _adConfig!;
      } else {
        throw Exception('Failed to load ad config: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading ad config: $e');
      // Return fallback config if server fails
      return _getFallbackConfig();
    }
  }

  // Get platform-specific ad unit ID
  Future<String> getRewardedAdUnitId() async {
    final config = await getAdConfig();

    if (Platform.isIOS) {
      return config.ref.ios.rewardedAd;
    } else if (Platform.isAndroid) {
      return config.ref.android.rewardedAd;
    } else {
      // Web or other platforms - use test ad
      return 'ca-app-pub-3940256099942544/5224354917';
    }
  }

  Future<String> getBannerAdUnitId() async {
    final config = await getAdConfig();

    if (Platform.isIOS) {
      return config.ref.ios.bannerAd;
    } else if (Platform.isAndroid) {
      return config.ref.android.bannerAd;
    } else {
      // Web or other platforms - use test ad
      return 'ca-app-pub-3940256099942544/6300978111';
    }
  }

  Future<String> getInitialAdUnitId() async {
    final config = await getAdConfig();

    if (Platform.isIOS) {
      return config.ref.ios.initialAd;
    } else if (Platform.isAndroid) {
      return config.ref.android.initialAd;
    } else {
      // Web or other platforms - use test ad
      return 'ca-app-pub-3940256099942544/1033173712';
    }
  }

  // Fallback configuration if server is unavailable
  AdConfig _getFallbackConfig() {
    return AdConfig(
      iosAd: 'initial_ad',
      androidAd: 'initial_ad',
      iosBannerAd: 'banner_ad',
      androidBannerAd: 'banner_ad',
      ref: AdRef(
        ios: IosAds(
          initialAd: 'ca-app-pub-5520596727761259/9323926836',
          rewardedAd: 'ca-app-pub-5520596727761259/5241271661',
          bannerAd: 'ca-app-pub-5520596727761259/2440272873',
        ),
        android: AndroidAds(
          initialAd: 'ca-app-pub-5520596727761259/7157620423',
          rewardedAd: 'ca-app-pub-5520596727761259/3882705925',
          bannerAd: 'ca-app-pub-5520596727761259/7127862465',
        ),
      ),
    );
  }

  // Clear cached config (useful for testing or when config changes)
  void clearConfigCache() {
    _adConfig = null;
    _isConfigLoaded = false;
  }
}
