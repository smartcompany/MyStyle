import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  // Analytics Events
  static Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  static Future<void> logPhotoUpload() async {
    await _analytics.logEvent(
      name: 'photo_upload',
      parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
  }

  static Future<void> logAnalysisStart() async {
    await _analytics.logEvent(
      name: 'analysis_start',
      parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
  }

  static Future<void> logAnalysisComplete() async {
    await _analytics.logEvent(
      name: 'analysis_complete',
      parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
  }

  static Future<void> logAdViewed(String adType) async {
    await _analytics.logEvent(
      name: 'ad_viewed',
      parameters: {
        'ad_type': adType,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static Future<void> logShareResult(String shareMethod) async {
    await _analytics.logEvent(
      name: 'share_result',
      parameters: {
        'share_method': shareMethod,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static Future<void> logOnboardingView() async {
    await _analytics.logEvent(
      name: 'onboarding_view',
      parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
  }

  // Crashlytics
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(exception, stackTrace, fatal: fatal);
  }

  static Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
    await _analytics.setUserId(id: userId);
  }

  static Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  static Future<void> log(String message) async {
    await _crashlytics.log(message);
  }
}
