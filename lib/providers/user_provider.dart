import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_preferences.dart';
import '../models/style_recommendation.dart';

class UserProvider with ChangeNotifier {
  UserPreferences _preferences = UserPreferences.defaultPreferences();
  bool _isFirstTime = true;
  bool _isLoading = false;

  UserPreferences get preferences => _preferences;
  bool get isFirstTime => _isFirstTime;
  bool get isLoading => _isLoading;

  Future<void> loadPreferences() async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = prefs.getString('user_preferences');
      final isFirstTimeValue = prefs.getBool('is_first_time') ?? true;

      if (preferencesJson != null) {
        final Map<String, dynamic> preferencesMap = json.decode(
          preferencesJson,
        );
        _preferences = UserPreferences.fromJson(preferencesMap);
      }

      _isFirstTime = isFirstTimeValue;
    } catch (e) {
      // 오류가 발생해도 기본 설정 사용
      _preferences = UserPreferences.defaultPreferences();
    }

    _setLoading(false);
  }

  Future<void> updatePreferences(UserPreferences newPreferences) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = json.encode(newPreferences.toJson());

      await prefs.setString('user_preferences', preferencesJson);
      _preferences = newPreferences;
      notifyListeners();
    } catch (e) {
      // 오류 처리
      debugPrint('Failed to save preferences: $e');
    }

    _setLoading(false);
  }

  Future<void> updateGender(Gender gender) async {
    final updatedPreferences = _preferences.copyWith(gender: gender);
    await updatePreferences(updatedPreferences);
  }

  Future<void> updatePreferredStyles(List<StyleCategory> styles) async {
    final updatedPreferences = _preferences.copyWith(preferredStyles: styles);
    await updatePreferences(updatedPreferences);
  }

  Future<void> updatePreferredColors(List<String> colors) async {
    final updatedPreferences = _preferences.copyWith(preferredColors: colors);
    await updatePreferences(updatedPreferences);
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    // 제거됨: 알림 설정은 더 이상 사용하지 않음
  }

  Future<void> updateAdsEnabled(bool enabled) async {
    // 제거됨: 광고 설정은 더 이상 사용하지 않음
  }

  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_first_time', false);
      _isFirstTime = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to complete onboarding: $e');
    }
  }

  Future<void> resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_preferences');
      _preferences = UserPreferences.defaultPreferences();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to reset preferences: $e');
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }
}
