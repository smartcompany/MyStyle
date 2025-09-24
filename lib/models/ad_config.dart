class AdConfig {
  final String iosAd;
  final String androidAd;
  final String iosBannerAd;
  final String androidBannerAd;
  final AdRef ref;

  AdConfig({
    required this.iosAd,
    required this.androidAd,
    required this.iosBannerAd,
    required this.androidBannerAd,
    required this.ref,
  });

  factory AdConfig.fromJson(Map<String, dynamic> json) {
    return AdConfig(
      iosAd: json['ios_ad'] ?? '',
      androidAd: json['android_ad'] ?? '',
      iosBannerAd: json['ios_banner_ad'] ?? '',
      androidBannerAd: json['android_banner_ad'] ?? '',
      ref: AdRef.fromJson(json['ref'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ios_ad': iosAd,
      'android_ad': androidAd,
      'ios_banner_ad': iosBannerAd,
      'android_banner_ad': androidBannerAd,
      'ref': ref.toJson(),
    };
  }
}

class AdRef {
  final IosAds ios;
  final AndroidAds android;

  AdRef({required this.ios, required this.android});

  factory AdRef.fromJson(Map<String, dynamic> json) {
    return AdRef(
      ios: IosAds.fromJson(json['ios'] ?? {}),
      android: AndroidAds.fromJson(json['android'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'ios': ios.toJson(), 'android': android.toJson()};
  }
}

class IosAds {
  final String initialAd;
  final String rewardedAd;
  final String bannerAd;

  IosAds({
    required this.initialAd,
    required this.rewardedAd,
    required this.bannerAd,
  });

  factory IosAds.fromJson(Map<String, dynamic> json) {
    return IosAds(
      initialAd: json['initial_ad'] ?? '',
      rewardedAd: json['rewarded_ad'] ?? '',
      bannerAd: json['banner_ad'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'initial_ad': initialAd,
      'rewarded_ad': rewardedAd,
      'banner_ad': bannerAd,
    };
  }
}

class AndroidAds {
  final String initialAd;
  final String rewardedAd;
  final String bannerAd;

  AndroidAds({
    required this.initialAd,
    required this.rewardedAd,
    required this.bannerAd,
  });

  factory AndroidAds.fromJson(Map<String, dynamic> json) {
    return AndroidAds(
      initialAd: json['initial_ad'] ?? '',
      rewardedAd: json['rewarded_ad'] ?? '',
      bannerAd: json['banner_ad'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'initial_ad': initialAd,
      'rewarded_ad': rewardedAd,
      'banner_ad': bannerAd,
    };
  }
}
