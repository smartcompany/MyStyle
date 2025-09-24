class AdConstants {
  // App ID
  static const String appId = 'ca-app-pub-5520596727761259~4145160225';

  // Test Ad Unit IDs (for development)
  static const String testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';
  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';

  // Production Ad Unit IDs (replace with your actual IDs)
  static const String rewardedAdUnitId =
      'ca-app-pub-5520596727761259/1234567890'; // Replace with your actual rewarded ad unit ID
  static const String bannerAdUnitId =
      'ca-app-pub-5520596727761259/1234567891'; // Replace with your actual banner ad unit ID
  static const String interstitialAdUnitId =
      'ca-app-pub-5520596727761259/1234567892'; // Replace with your actual interstitial ad unit ID

  // Use test ads in debug mode
  static bool get isTestMode => true; // Set to false for production

  static String get rewardedAdId =>
      isTestMode ? testRewardedAdUnitId : rewardedAdUnitId;
  static String get bannerAdId =>
      isTestMode ? testBannerAdUnitId : bannerAdUnitId;
  static String get interstitialAdId =>
      isTestMode ? testInterstitialAdUnitId : interstitialAdUnitId;
}
