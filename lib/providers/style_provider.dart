import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/style_recommendation.dart';
import '../models/weather.dart';
import '../models/user_preferences.dart';
import '../services/style_service.dart';

class StyleProvider with ChangeNotifier {
  final StyleService _styleService = StyleService();

  List<StyleRecommendation> _styleRecommendations = [];
  List<ActivityRecommendation> _activityRecommendations = [];
  bool _isLoading = false;
  String? _error;

  List<StyleRecommendation> get styleRecommendations => _styleRecommendations;
  List<ActivityRecommendation> get activityRecommendations =>
      _activityRecommendations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getRecommendations({
    required Weather weather,
    required UserPreferences preferences,
    required BuildContext context,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final results = await Future.wait([
        _styleService.getStyleRecommendations(
          weather: weather,
          preferences: preferences,
          context: context,
        ),
        _styleService.getActivityRecommendations(
          weather: weather,
          preferences: preferences,
        ),
      ]);

      _styleRecommendations = results[0] as List<StyleRecommendation>;
      _activityRecommendations = results[1] as List<ActivityRecommendation>;

      notifyListeners();
    } catch (e) {
      _setError('추천 정보를 가져올 수 없습니다: $e');
    }

    _setLoading(false);
  }

  Future<void> refreshRecommendations({
    required Weather weather,
    required UserPreferences preferences,
    required BuildContext context,
  }) async {
    await getRecommendations(
      weather: weather,
      preferences: preferences,
      context: context,
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearRecommendations() {
    _styleRecommendations = [];
    _activityRecommendations = [];
    _error = null;
    notifyListeners();
  }

  void addToFavorites(StyleRecommendation recommendation) {
    // TODO: Implement favorites functionality
    // This could involve saving to local storage or sending to server
  }

  void removeFromFavorites(String recommendationId) {
    // TODO: Implement favorites functionality
  }
}
